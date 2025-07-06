import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ProductDemoApp/services/api_client.dart';

class MerchantRepository {
  final ApiClient apiClient;

  MerchantRepository({required this.apiClient});

  Future<String> addMerchant({
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
    final headers = await apiClient.getHeaders();

    final fileUploads = await Future.wait(files.map((file) =>
        MultipartFile.fromFile(file.path, filename: file.path.split('/').last)));

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
  }
}
