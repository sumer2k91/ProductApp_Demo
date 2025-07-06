import 'package:dio/dio.dart';
import 'package:ProductDemoApp/global.dart';

class ProfileClient {
  final ApiClient apiClient;

  ProfileClient({required this.apiClient});

  Future<UserModel> fetchUserProfile() async {
    try {
      final options = await apiClient.getHeaders(); // ✅ Await the headers

      final response = await apiClient.dio.get(
        "user-profile-data",
        options: options, // ✅ Now pass the awaited options
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data["data"]["user"]);
      } else {
        throw Exception("Failed to fetch user profile");
      }
    } catch (e) {
      print("❌ Error: $e");
      throw Exception("Error: $e");
    }
  }
}