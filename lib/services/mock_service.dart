import 'dart:convert';
import 'package:flutter/services.dart';

 class MockService {
   Future<Map<String, dynamic>> loadMockJson(String fileName) async {
     final jsonString = await rootBundle.loadString('assets/mocks/$fileName');
     return jsonDecode(jsonString);
   }
 }
