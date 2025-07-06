import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';

class ProductCardModel {
  final String? imageUrl;
  final String? name;
  final String? brand;
  final int? quantity;
  final double? amount;

  ProductCardModel({
    this.imageUrl,
    this.name,
    this.brand,
    this.quantity,
    this.amount,
  });
}

class ProductCard extends StatelessWidget {
  final ProductCardModel product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(screenWidth),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductInfo(screenWidth),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      _buildActionButtons(context, screenWidth),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(double screenWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: product.imageUrl != null && product.imageUrl!.isNotEmpty
          ? Image.network(
        product.imageUrl!,
        width: screenWidth * 0.2,
        height: screenWidth * 0.2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(screenWidth),
      )
          : _buildPlaceholderImage(screenWidth),
    );
  }

  Widget _buildPlaceholderImage(double screenWidth) {
    return Container(
      width: screenWidth * 0.2,
      height: screenWidth * 0.2,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.shade400,
        size: screenWidth * 0.08,
      ),
    );
  }

  Widget _buildProductInfo(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(
          Icons.label,
          product.name ?? "Unnamed Product",
          AppColors.primaryColor,
          isProductName: true,
          screenWidth: screenWidth,
        ),
        _buildRow(
          Icons.branding_watermark,
          product.brand ?? "No Brand",
          Colors.black87,
          screenWidth: screenWidth,
        ),
        _buildRow(
          Icons.production_quantity_limits,
          (product.quantity ?? 0).toString(),
          Colors.grey.shade700,
          screenWidth: screenWidth,
        ),
        _buildRow(
          Icons.currency_rupee,
          product.amount != null ? product.amount!.toStringAsFixed(2) : '0.00',
          Colors.grey.shade700,
          screenWidth: screenWidth,
        ),
      ],
    );
  }

  Widget _buildRow(
      IconData icon,
      String text,
      Color color, {
        required double screenWidth,
        bool isProductName = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: screenWidth * 0.05),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isProductName ? screenWidth * 0.045 : screenWidth * 0.038,
                fontWeight: isProductName ? FontWeight.w700 : FontWeight.w500,
                color: color,
                letterSpacing: isProductName ? 0.2 : 0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, double screenWidth) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {}, // Empty for later implementation
          icon: Icon(Icons.edit, color: AppColors.primaryColor, size: screenWidth * 0.05),
          label: const Text("Edit"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.whiteColor,
            foregroundColor: AppColors.primaryColor,
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.036,
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {}, // Empty for later implementation
          icon: Icon(Icons.copy, color: AppColors.primaryColor, size: screenWidth * 0.05),
          label: const Text("Copy"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.whiteColor,
            foregroundColor: AppColors.primaryColor,
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.036,
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}