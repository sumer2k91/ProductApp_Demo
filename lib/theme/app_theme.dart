import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    inputDecorationTheme: AppInputTheme.inputDecorationTheme,
  );
}
