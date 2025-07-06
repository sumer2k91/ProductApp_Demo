import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';

import 'app_text_styles.dart';

class AppInputTheme {
  static const double cornerRadius = 8.0;

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    labelStyle: AppTextStyles.labelStyle,
  );
}
