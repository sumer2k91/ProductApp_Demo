import 'package:flutter/material.dart';
import 'package:ProductDemoApp/theme/app_colors.dart';
import '../data/repositories/merchant_repository.dart';
import '../services/api_client.dart';
import '../widgets/custom_app_bar.dart';
import 'add_merchant_form.dart';
import 'merchant_list_screen.dart';

class SegmentedControlScreen extends StatefulWidget {
  const SegmentedControlScreen({super.key});

  @override
  _SegmentedControlScreenState createState() => _SegmentedControlScreenState();
}

class _SegmentedControlScreenState extends State<SegmentedControlScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Merchant', borderRadius: 20.0),
      body: Stack(
        children: [
          // ✅ Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFFFF),
                  Color(0xFFFAD1A7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: CustomAppBar().height + 20),
              _buildSegmentedControl(),
              const SizedBox(height: 10),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: selectedIndex == 0
                      ? _buildAddMerchantScreen()
                      : const MerchantListScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.blackColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: ToggleButtons(
          borderRadius: BorderRadius.circular(30),
          selectedBorderColor: Colors.transparent,
          fillColor: AppColors.gradientColor1,
          color: Colors.black,
          selectedColor: Colors.black,
          borderWidth: 0,
          constraints: const BoxConstraints(minWidth: 140, minHeight: 50),
          isSelected: [selectedIndex == 0, selectedIndex == 1],
          onPressed: (index) => setState(() => selectedIndex = index),
          children: [
            _buildSegment(Icons.add, "Add Merchant"),
            _buildSegment(Icons.people, "Merchants"),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMerchantScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AddMerchantForm(
        repository: MerchantRepository(apiClient: ApiClient()),
      ),
    );
  }
}
