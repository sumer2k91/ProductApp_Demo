import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ProductDemoApp/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ProductDemoApp/data/repositories/merchant_repository.dart';
import 'package:ProductDemoApp/widgets/image_picker.dart';
import 'map_picker_screen.dart';

class AddMerchantForm extends StatefulWidget {
  final MerchantRepository repository;

  const AddMerchantForm({super.key, required this.repository});

  @override
  State<AddMerchantForm> createState() => _AddMerchantFormState();
}

class _AddMerchantFormState extends State<AddMerchantForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'Owner Name': TextEditingController(),
    'Company Name': TextEditingController(),
    'Email': TextEditingController(),
    'Mobile Number': TextEditingController(),
    'Address': TextEditingController(),
  };

  File? shopPhoto;
  File? licensePhoto;

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleImagePick({required bool isShop}) async {
    final cameraStatus = await Permission.camera.request();
    final photoStatus = await Permission.photos.request();

    if (!cameraStatus.isGranted || !photoStatus.isGranted) {
      SnackbarService.showSnackbar(context, "Camera and photo access permissions are required.");
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () async {
                Navigator.pop(context);
                final pickedImage = await ImagePickerService.pickImage(fromCamera: true);
                if (pickedImage != null) {
                  setState(() {
                    if (isShop) {
                      shopPhoto = pickedImage;
                    } else {
                      licensePhoto = pickedImage;
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                Navigator.pop(context);
                final pickedImage = await ImagePickerService.pickImage(fromCamera: false);
                if (pickedImage != null) {
                  setState(() {
                    if (isShop) {
                      shopPhoto = pickedImage;
                    } else {
                      licensePhoto = pickedImage;
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage(bool isShop) {
    setState(() {
      if (isShop) {
        shopPhoto = null;
      } else {
        licensePhoto = null;
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (shopPhoto == null || licensePhoto == null) {
        SnackbarService.showSnackbar(context, "Please upload both photos.");
        return;
      }

      try {
        final message = await widget.repository.addMerchant(
          fullName: controllers['Owner Name']!.text.trim(),
          emailAddress: controllers['Email']!.text.trim(),
          mobileCountryId: "91",
          mobileNumber: controllers['Mobile Number']!.text.trim(),
          companyName: controllers['Company Name']!.text.trim(),
          city: "Mumbai",
          postcode: "400083",
          address: controllers['Address']!.text.trim(),
          longitude: "68.3343",
          latitude: "-153.6000",
          files: [shopPhoto!, licensePhoto!],
        );

        SnackbarService.showSnackbar(context, message);
      } catch (e) {
        SnackbarService.showSnackbar(context, "❌ Error: ${e.toString()}");
      }
    }
  }

  Widget _buildUploadCard({
    required String label,
    required File? imageFile,
    required VoidCallback onPick,
    required VoidCallback onRemove,
  }) {
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
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (imageFile != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    imageFile,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: onRemove,
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
              onPressed: onPick,
              icon: const Icon(Icons.upload, size: 18),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyProfile(
                    controller: controllers['Owner Name']!,
                    name: "Owner Name",
                    prefixIcon: Icons.person,
                    inputType: TextInputType.name,
                  ),
                  MyProfile(
                    controller: controllers['Company Name']!,
                    name: "Company/Shop Name",
                    prefixIcon: Icons.store,
                    inputType: TextInputType.name,
                  ),
                  MyProfile(
                    controller: controllers['Email']!,
                    name: "Email Address",
                    prefixIcon: Icons.email,
                    inputType: TextInputType.emailAddress,
                  ),
                  MyProfile(
                    controller: controllers['Mobile Number']!,
                    name: "Mobile Number",
                    prefixIcon: Icons.phone,
                    inputType: TextInputType.phone,
                    countryCode: "+91 ",
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapPickerScreen(),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          controllers['Address']!.text = result['address'];
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: MyProfile(
                        controller: controllers['Address']!,
                        name: "Address",
                        prefixIcon: Icons.location_on,
                        inputType: TextInputType.streetAddress,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Upload Documents",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUploadCard(
                          label: "Shop Photo",
                          imageFile: shopPhoto,
                          onPick: () => _handleImagePick(isShop: true),
                          onRemove: () => _removeImage(true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildUploadCard(
                          label: "License Photo",
                          imageFile: licensePhoto,
                          onPick: () => _handleImagePick(isShop: false),
                          onRemove: () => _removeImage(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.secondaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade100,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Submit Merchant",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
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
  }
}
