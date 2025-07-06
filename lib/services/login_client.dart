import 'package:dio/dio.dart';
// import 'package:tros_product_application/services/api_client.dart';
// import 'package:tros_product_application/models/login_model.dart';

import '../models/login_model.dart';
import 'api_client.dart';
import 'package:ProductDemoApp/global.dart';


class LoginClient {
  final ApiClient apiClient;
  // final String authToken;

  // MyProfileClient({required this.apiClient, required this.authToken});
  LoginClient({required this.apiClient});

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    try {
      print("🔍 Login: {email: $email, password: $password}");
      apiClient.removeToken();

      final options = await apiClient.getHeaders(includeAuth: false); // ✅ Await the headers

      final response = await apiClient.dio.post(
        "login",
        data: {
          "email": email,
          "password": password,
        },
        options: options,
      );

      if (response.statusCode == 200 && response.data["status"] == "ok") {
        return LoginModel.fromJson(response.data["data"]);
      } else {
        throw Exception(response.data["message"] ?? "Failed user login");
      }
    } on DioException catch (e) {
      print("❌ Network error: ${e.response?.data}");
      throw Exception("Network error: ${e.response?.data["message"] ?? e.message}");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}