import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_client.dart';
import '../widgets/custom_app_bar.dart';
import 'add_product_form.dart';
import 'package:ProductDemoApp/global.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductClient _productClient = ProductClient(apiClient: ApiClient());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool useMock = true;

  List<ProductModel> _products = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;
  bool _hasError = false;
  String? _searchQuery;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts({bool reset = false}) async {
    if (_isLoading || _currentPage > _lastPage) return;

    if (reset) {
      _products.clear();
      _currentPage = 1;
      _lastPage = 1;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      List<ProductModel> newProducts;
      int lastPage;

      if (useMock) {
        final mockJson = await MockService().loadMockJson("products.json");
        final List<dynamic> data = mockJson['data']['data'];
        newProducts = data.map((e) => ProductModel.fromJson(e)).toList();
        lastPage = mockJson['last_page'] ?? 1;
      } else {
        final (apiProducts, apiLastPage) = await _productClient.fetchProducts(
          page: _currentPage,
          searchQuery: _searchQuery,
        );
        newProducts = apiProducts;
        lastPage = apiLastPage;
      }

      setState(() {
        _products.addAll(newProducts);
        _lastPage = lastPage;
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      _fetchProducts();
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query != _searchQuery) {
        setState(() {
          _searchQuery = query.isEmpty ? null : query;
        });
        _fetchProducts(reset: true);
      }
    });
  }

  double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Future<void> _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductForm(productClient: _productClient),
      ),
    );

    if (result == true) {
      setState(() {
        _products.clear();
        _currentPage = 1;
        _lastPage = 1;
        _searchQuery = null;
        _searchController.clear();
      });
      _fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 400;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Products',
        borderRadius: 20.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: isSmallDevice ? 26 : 32, color: Colors.white),
            onPressed: _navigateToAddProduct,
            tooltip: 'Add Product',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFFAD1A7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Responsive Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: isSmallDevice ? 14 : 16),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = null;
                          });
                          _fetchProducts(reset: true);
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    ),
                  ),
                ),
              ),

              // Product List
              Expanded(
                child: _products.isEmpty && _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _products.isEmpty
                    ? Center(child: Text(_hasError ? "❌ Error loading products" : "No products found."))
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _products.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _products.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final product = _products[index];
                    return ProductCard(
                      product: ProductCardModel(
                        imageUrl: product.default_image_url,
                        name: product.name,
                        brand: product.brand,
                        quantity: _parseInt(product.quantity),
                        amount: _parseDouble(product.sale_price),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
