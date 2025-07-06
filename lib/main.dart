import 'package:flutter/material.dart';
import 'package:ProductDemoApp/screens/login_screen.dart';
import 'package:ProductDemoApp/widgets/product_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen()
    );
  }
}