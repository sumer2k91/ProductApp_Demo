import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ProductDemoApp/global.dart';
import 'api_client.dart';

class MerchantClient {
  final ApiClient apiClient;

  MerchantClient({required this.apiClient});

  /// ✅ Fetch merchants with pagination support
  Future<Map<String, dynamic>> fetchMerchants({int page = 1}) async {
    try {
      final options = await apiClient.getHeaders();

      final response = await apiClient.dio.get(
        "merchants?searchTerm=&currency=INR&page=$page",
        options: options,
      );

      if (response.statusCode == 200) {
        List<dynamic> merchantsJson = response.data["data"]["data"];
        List<MerchantListModel> merchantList = merchantsJson
            .map((json) => MerchantListModel.fromJson(json))
            .toList();

        bool hasMore = response.data["data"]["next_page_url"] != null;

        return {
          "merchants": merchantList,
          "hasMore": hasMore,
        };
      } else {
        throw Exception("Failed to fetch merchants");
      }
    } catch (e) {
      print("❌ Error: $e");
      throw Exception("Error fetching merchants: $e");
    }
  }

  /// ✅ Add new merchant
  Future<String> addMerchants({
    required String fullName,
    required String emailAddress,
    required String mobileCountryId,
    required String mobileNumber,
    required String companyName,
    required String city,
    required String postcode,
    required String address,
    required String longitude,
    required String latitude,
    required List<File> files,
    String referrer = "Test",
  }) async {
    try {
      final headers = await apiClient.getHeaders();

      List<MultipartFile> fileUploads = [];
      for (var file in files) {
        fileUploads.add(
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }

      final formData = FormData.fromMap({
        'files': fileUploads,
        'fullName': fullName,
        'emailAddress': emailAddress,
        'mobileCountryId': mobileCountryId,
        'mobileNumber': mobileNumber,
        'companyName': companyName,
        'city': city,
        'postcode': postcode,
        'address': address,
        'longitude': longitude,
        'latitude': latitude,
        'referrer': referrer,
      });

      final response = await apiClient.dio.post(
        "merchant-store",
        data: formData,
        options: headers,
      );

      if (response.statusCode == 200) {
        return response.data["data"]?["message"] ?? "Merchant added successfully!";
      } else {
        throw Exception(response.data["message"] ?? "Failed to add merchant.");
      }
    } on DioException catch (e) {
      print("❌ Network error: ${e.response?.data}");
      throw Exception(
        "Network error: ${e.response?.data["message"] ?? e.message}",
      );
    } catch (e) {
      throw Exception("Error adding merchant: $e");
    }
  }
}
