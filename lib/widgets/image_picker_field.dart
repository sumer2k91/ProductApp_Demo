import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerField extends StatelessWidget {
  final String label;
  final File? imageFile;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const ImagePickerField({
    super.key,
    required this.label,
    required this.imageFile,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 6),
        ElevatedButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.upload_file, size: 16),
          label: const Text("Upload", style: TextStyle(fontSize: 13)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        if (imageFile != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  imageFile!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              )
            ],
          )
        ]
      ],
    );
  }
}
