import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';

class CustomInputTheme {
  static InputDecoration customInputDecoration({
    required String labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    String? prefixText,
    Color? borderColor,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.primaryColor) : null,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.primaryColor) : null,
      prefixText: prefixText ?? '',
      isDense: true,
      counterText: "",
      labelStyle: const TextStyle(color: AppColors.greyColor),
      border: _outlineInputBorder(borderColor ?? AppColors.primaryColor),
      focusedBorder: _outlineInputBorder(borderColor ?? AppColors.primaryColor),
      enabledBorder: _outlineInputBorder(borderColor ?? AppColors.primaryColor),
    );
  }

  // ✅ Extract border logic to a separate method
  static OutlineInputBorder _outlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    );
  }
}
