import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ProductDemoApp/services/product_client.dart';
import 'package:ProductDemoApp/theme/app_colors.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key, required productClient});
  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'Product Name': TextEditingController(),
    'Brand': TextEditingController(),
    'Keywords': TextEditingController(),
    'Description': TextEditingController(),
    'Category': TextEditingController(),
    'Sub-categories': TextEditingController(),
    'Regular Price': TextEditingController(),
    'Sale Price': TextEditingController(),
    'Quantity': TextEditingController(),
    'Units': TextEditingController(),
    'Currency': TextEditingController(),
    'Merchant': TextEditingController(),
  };

  File? productPhoto;

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleImagePick() async {
    final cameraStatus = await Permission.camera.request();
    final photoStatus = await Permission.photos.request();

    if (!cameraStatus.isGranted || !photoStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera and photo access permissions are required.")),
      );
      return;
    }

    // Simulate image pick
    // Replace this with your actual image picker
    setState(() => productPhoto = File('dummy_path'));
  }

  void _removeImage() {
    setState(() => productPhoto = null);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (productPhoto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload a product photo.")),
        );
        return;
      }

      // Simulate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Product submitted successfully!")),
      );

      // Optionally pop the screen after submission
      // Navigator.pop(context);
    }
  }

  Widget _buildUploadCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text("Product Photo", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (productPhoto != null)
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: const Center(child: Text("Dummy Image")),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: _removeImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          else
            OutlinedButton.icon(
              onPressed: _handleImagePick,
              icon: const Icon(Icons.upload),
              label: const Text("Upload"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product", style: TextStyle(color: AppColors.whiteColor),),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var key in controllers.keys)
                      MyProfile(
                        controller: controllers[key]!,
                        name: key,
                        prefixIcon: Icons.edit,
                        inputType: TextInputType.text,
                      ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildUploadCard(),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Submit Product",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyProfile extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final IconData prefixIcon;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? countryCode;

  const MyProfile({
    super.key,
    required this.controller,
    required this.name,
    required this.prefixIcon,
    required this.inputType,
    this.inputFormatters,
    this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$name is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: name,
          prefixIcon: Icon(prefixIcon),
          prefixText: countryCode,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }}