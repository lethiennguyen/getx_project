import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/dio/dio.dart';
import '../../data/model/product.dart';
import '../../data/repositories/product_reponsitories.dart';
import '../../data/upload_image/image_picker_service.dart';

class CreateProductController extends GetxController {
  final name = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final cover = ''.obs;

  final respon = CreateProductRepository(dio);
  final imageService = ImagePickerService();
  var product = Rx<Product?>(null);

  var isUploading = false.obs;

  Future<bool> createProduct({
    required name,
    required int price,
    required int quantity,
    required cover,
  }) async {
    final result = await respon.postCreateProdcut(
      name: name.text,
      price: price,
      quantity: quantity,
      cover: cover.value.isEmpty ? null : cover.value,
    );
    return result != null;
  }

  Future<void> pickAndUploadImage() async {
    try {
      final image = await imageService.pickImage(ImageSource.gallery);
      if (image == null) return;
      final url = await imageService.uploadToCloudinary(image);
      print("url : $url");
      if (url != null) {
        cover.value = url;
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }
}
