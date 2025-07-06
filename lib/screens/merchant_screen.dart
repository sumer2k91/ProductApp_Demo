import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';
import 'segmented_control_screen.dart';

class MerchantScreen extends StatelessWidget {
  const MerchantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SegmentedControlScreen();
  }

  void loadMerchants() async {
    MerchantClient merchantClient = MerchantClient(apiClient: ApiClient());

    try {
      final result = await merchantClient.fetchMerchants();
      List<MerchantListModel> merchants = result["merchants"];

      if (merchants.isNotEmpty) {
        print("✅ Fetched ${merchants.length} merchants!");
        for (var merchant in merchants) {
          print("Merchant: ${merchant.name}");
        }
      } else {
        print("⚠️ No merchants found!");
      }
    } catch (e) {
      print("❌ API Error: $e");
    }
  }
}
