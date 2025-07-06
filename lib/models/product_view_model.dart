import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_client.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductClient productClient;

  ProductViewModel({required this.productClient});

  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _lastPage = 1;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts({bool reset = false}) async {
    if (_isLoading || _currentPage > _lastPage) return;

    if (reset) {
      _products.clear();
      _currentPage = 1;
      _lastPage = 1;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final (newProducts, lastPage) = await productClient.fetchProducts(page: _currentPage);
      _products.addAll(newProducts);
      _lastPage = lastPage;
      _currentPage++;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}