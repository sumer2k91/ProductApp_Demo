import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiClient apiClient = ApiClient();
  late ProfileClient myProfileClient;

  String fullName = '';
  String email = '';
  String phoneNumber = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    myProfileClient = ProfileClient(apiClient: apiClient);
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    const bool useMock = true; // ✅ Toggle this to switch between mock & real

    try {
      UserModel user;

      if (useMock) {
        final mockData = await MockService().loadMockJson("profile.json");
        user = UserModel.fromJson(mockData["data"]["user"]); // your existing model's fromJson
      } else {
        user = await myProfileClient.fetchUserProfile(); // real API
      }

      setState(() {
        print("$user Neha");
        fullName = '${user.firstName} ${user.lastName}';
        email = user.email;
        phoneNumber = '+91 ${user.mobile}';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      SnackbarService.showSnackbar(context, "Failed to load profile: $e");
    }
  }

  void _logout() async {
    await apiClient.removeToken(); // Remove stored token

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Clear backstack
    );
  }

  Widget _buildProfileSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Match with statistics tile
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(1.2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor, // Black border
              ),
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildOrderHistoryTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // More visible shadow
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: AppColors.whiteColor,
          child: InkWell(
            onTap: () {
              // TODO: Implement Order History
            },
            child: const ListTile(
              title: Text("Statistics"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        ),
      ),
    );
  }




  Widget _buildLogoutButton() {
    return Center(
      child: OutlinedButton(
        onPressed: _logout,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const SizedBox(
          width: double.infinity,
          child: Center(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Profile', borderRadius: 20.0),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.secondaryColor,
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileSummaryCard(),
                            _buildOrderHistoryTile(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildLogoutButton(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
