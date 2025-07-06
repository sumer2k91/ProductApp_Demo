import 'package:dio/dio.dart';
// import 'package:tros_product_application/services/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ProductDemoApp/global.dart';

import 'api_constants.dart';


class ApiClient {
  late Dio dio;
  final storage = FlutterSecureStorage();

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.BASE_URL,
        connectTimeout: ApiConstants.CONNECT_TIMEOUT,
        receiveTimeout: ApiConstants.RECEIVE_TIMEOUT,
        contentType: "application/json"
      ),
    );

    // Logging Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("📤 Request: ${options.method} ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ Response: ${response.statusCode} ${response.data}");
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          print("❌ Error: ${error.response?.statusCode} ${error.message}");
          return handler.next(error);
        },
      ),
    );
  }

  // Common function to add authorization headers
  // Options getAuthHeaders(String token) {
  // ✅ Updated getAuthHeaders() to async
  Future<Options> getHeaders({bool includeAuth = true}) async {
    String? token = await getAuthToken();
    print("Get TOKEN - $token");

    return Options(
      headers: {
        "Accept": "application/json",
        if (includeAuth && token != null) "Authorization": token,
      },
    );
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'access_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> removeToken() async {
    await storage.delete(key: 'access_token');
  }
}
