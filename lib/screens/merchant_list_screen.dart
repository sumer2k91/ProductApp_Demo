import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';


import '../services/mock_merchant_service.dart';

class MerchantListScreen extends StatefulWidget {
  const MerchantListScreen({super.key});

  @override
  _MerchantListScreenState createState() => _MerchantListScreenState();
}

class _MerchantListScreenState extends State<MerchantListScreen> {
  List<MerchantListModel> merchants = [];
  bool isLoading = true;
  bool isFetchingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  final bool useMock = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadMerchants();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !isFetchingMore &&
        hasMore) {
      fetchMoreMerchants();
    }
  }

  Future<void> loadMerchants({int page = 1}) async {
    setState(() => isLoading = true);

    try {
      final result = useMock
          ? await MockMerchantService().fetchMockMerchants(page: page)
          : await MerchantClient(apiClient: ApiClient()).fetchMerchants(page: page);

      setState(() {
        merchants = result["merchants"];
        currentPage = page;
        hasMore = result["hasMore"];
        isLoading = false;
      });

      print("✅ Fetched ${merchants.length} merchants!");
    } catch (e) {
      print("❌ Error loading merchants: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchMoreMerchants() async {
    setState(() => isFetchingMore = true);

    try {
      final nextPage = currentPage + 1;
      final result = useMock
          ? await MockMerchantService().fetchMockMerchants(page: nextPage)
          : await MerchantClient(apiClient: ApiClient()).fetchMerchants(page: nextPage);

      setState(() {
        merchants.addAll(result["merchants"]);
        currentPage = nextPage;
        hasMore = result["hasMore"];
        isFetchingMore = false;
      });
    } catch (e) {
      print("❌ Error fetching more merchants: $e");
      setState(() => isFetchingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (merchants.isEmpty) {
      return const Center(child: Text("No merchants available"));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: merchants.length + (isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < merchants.length) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: MerchantCard(merchant: merchants[index]),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
