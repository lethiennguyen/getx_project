import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? selectedImage;
  final String? imageUrl;
  final bool isLoading;
  final double? progress;
  final String? label;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final VoidCallback onTap;

  const ImagePickerWidget({
    Key? key,
    this.selectedImage,
    this.imageUrl,
    this.isLoading = false,
    this.progress,
    this.label,
    this.width,
    this.height,
    this.placeholder,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: width ?? 150,
                height: height ?? 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: _buildContent(),
              ),
              if (isLoading && progress != null)
                CircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white,
                ),
              if (isLoading && progress == null) CircularProgressIndicator(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const SizedBox();
    } else if (selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(selectedImage!, fit: BoxFit.cover),
      );
    } else if (imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(imageUrl!, fit: BoxFit.cover),
      );
    } else {
      return placeholder ?? _buildDefaultPlaceholder();
    }
  }

  Widget _buildDefaultPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text('Chọn ảnh', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
