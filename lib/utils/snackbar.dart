import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';

class SnackbarService {
  static void showSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 5), // Default 5 seconds
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 15, color: Colors.white),
        ),
        duration: duration, // Use dynamic duration
        backgroundColor: AppColors.secondaryColor,
      ),
    );
  }
}
