import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/merchant_model.dart';
import 'mock_service.dart';

class MockMerchantService {
  Future<Map<String, dynamic>> fetchMockMerchants({int page = 1}) async {
    final mockData = await MockService().loadMockJson("merchant_list.json");
    final List<dynamic> merchantListJson = mockData['data']['data'];

    List<MerchantListModel> merchants = merchantListJson
        .map((merchant) => MerchantListModel.fromJson(merchant))
        .toList();

    return {
      "merchants": merchants,
      "hasMore": mockData['data']['next_page_url'] != null,
    };
  }
}
