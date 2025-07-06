import '../models/product_model.dart';
import 'api_client.dart';
import 'package:ProductDemoApp/global.dart';


class ProductClient {
  final ApiClient apiClient;
  ProductClient({required this.apiClient});

  Future<(List<ProductModel>, int)> fetchProducts({required int page, String? searchQuery}) async {
    try {
      final options = await apiClient.getHeaders();

      // Construct the URL with optional search query
      String url = "products?page=$page¤cy=INR";
      if (searchQuery != null && searchQuery.isNotEmpty) {
        url += "&search=$searchQuery";
      }

      print("📡 Fetching products with URL: $url");

      final response = await apiClient.dio.get(
        url,
        options: options,
      );

      if (response.statusCode == 200) {
        List<dynamic> productJson = response.data["data"]["data"];
        int lastPage = response.data["data"]["last_page"];
        List<ProductModel> products =
        productJson.map((json) => ProductModel.fromJson(json)).toList();
        print("✅ Fetched ${products.length} products for page $page, search: $searchQuery");
        return (products, lastPage);
      } else {
        throw Exception("Failed to fetch products: Status ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching products: $e");
      throw Exception("Error: $e");
    }
  }
}