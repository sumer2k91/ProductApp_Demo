import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MerchantTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;

  const MerchantTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.inputType,
    this.inputFormatters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.isEmpty ? '$label is required' : null,
    );
  }
}
