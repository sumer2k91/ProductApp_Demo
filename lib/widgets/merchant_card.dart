import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ProductDemoApp/global.dart';

class MerchantCard extends StatelessWidget {
  final MerchantListModel merchant;

  const MerchantCard({required this.merchant, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFAD1A7)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orangeAccent.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(Icons.store, merchant.companyName ?? "", AppColors.primaryColor,
                isCompany: true, screenWidth: screenWidth),
            _buildRow(Icons.person, merchant.name ?? "", Colors.black87,
                screenWidth: screenWidth),
            _buildRow(
              Icons.location_on,
              (merchant.address ?? "").isNotEmpty
                  ? merchant.address!
                  : "No Address Available",
              Colors.grey.shade700,
              isAddress: true,
              screenWidth: screenWidth,
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            _buildActionButtons(context, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
      IconData icon,
      String text,
      Color color, {
        required double screenWidth,
        bool isAddress = false,
        bool isCompany = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment:
        isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: screenWidth * 0.05),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isCompany ? screenWidth * 0.045 : screenWidth * 0.038,
                fontWeight: isCompany ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
              maxLines: isAddress ? 3 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, double screenWidth) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => _openGoogleMaps(context),
          icon: Icon(Icons.map, color: AppColors.blackColor, size: screenWidth * 0.05),
          label: const Text("Google Map"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.blackColor,
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.036,
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.blackColor, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _makePhoneCall(context),
          icon: Icon(Icons.phone, color: AppColors.blackColor, size: screenWidth * 0.05),
          label: Text(
            merchant.mobile ?? '',
            style: TextStyle(fontSize: screenWidth * 0.036),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.blackColor,
            textStyle: TextStyle(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.blackColor, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  void _openGoogleMaps(BuildContext context) async {
    final address = merchant.address;
    if (address != null && address.isNotEmpty) {
      final Uri mapUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
      try {
        if (!await launchUrl(mapUrl, mode: LaunchMode.externalApplication)) {
          _showError(context, 'Could not open Google Maps.');
        }
      } catch (e) {
        _showError(context, 'Error: ${e.toString()}');
      }
    } else {
      _showError(context, 'No address available.');
    }
  }

  void _makePhoneCall(BuildContext context) async {
    final phone = merchant.mobile;
    if (phone != null && phone.isNotEmpty) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phone);
      try {
        if (!await launchUrl(phoneUri)) {
          _showError(context, 'Could not open the phone dialer.');
        }
      } catch (e) {
        _showError(context, 'Error: ${e.toString()}');
      }
    } else {
      _showError(context, 'Phone number is missing.');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
