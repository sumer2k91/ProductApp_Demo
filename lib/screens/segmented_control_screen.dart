import 'package:flutter/material.dart';
import 'package:ProductDemoApp/theme/app_colors.dart';
// import 'package:/widgets/custom_app_bar.dart';
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
      backgroundColor: AppColors.lightGreyColor, // Solid background color
      appBar: const CustomAppBar(title: 'Merchant', borderRadius: 20.0),
      body: Column(
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
    );
  }

  Widget _buildSegmentedControl() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primaryColor),
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
          fillColor: AppColors.primaryColor,
          color: AppColors.primaryColor,
          selectedColor: AppColors.whiteColor,
          borderWidth: 0,
          constraints: const BoxConstraints(minWidth: 140, minHeight: 50),
          isSelected: [selectedIndex == 0, selectedIndex == 1],
          onPressed: (index) => setState(() => selectedIndex = index),
          children: [
            _buildSegment(Icons.add, "Add Merchant", selectedIndex == 0),
            _buildSegment(Icons.people, "Merchants", selectedIndex == 1),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(IconData icon, String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppColors.whiteColor : AppColors.primaryColor),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
