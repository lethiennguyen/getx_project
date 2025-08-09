import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/data/model/product.dart';
import 'package:getx_statemanagement/data/repositories/product_reponsitories.dart';
import 'package:getx_statemanagement/data/upload_image/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/dio/dio.dart';

class DetailProductController extends GetxController {
  final respon = ProductDetailRepository(dio);
  final product = Rx<Product?>(null);
  final name = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final cover = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final imageService = ImagePickerService();
  final isUploading = false.obs;
  final imageUrl = ''.obs;
  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as int;

    fetchDetailProduct(id);
  }

  Future<void> fetchDetailProduct(id) async {
    final result = await respon.getProductDetail(id);
    product.value = result;
    name.text = result.name;
    price.text = result.price.toString();
    quantity.text = result.quantity.toString();
    cover.text = result.cover;
  }

  Future<bool> deleteProduct(id) async {
    final isSucssec = await respon.deleteProduct(id);
    if (isSucssec) {
      Get.snackbar(
        'Thành công',
        'Đã xoá sản phẩm',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else {
      Get.snackbar(
        'Lỗi',
        'Đã xảy ra lỗi khi xoá sản phẩm',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<void> upDateProduct(
    id, {
    required name,
    required int price,
    required int quantity,
    required cover,
  }) async {
    final result = await respon.putProductUpdate(
      id,
      name: name,
      price: price,
      quantity: quantity,
      cover: cover,
    );
    product.value = result;
  }

  Future<String?> pickAndUploadImage() async {
    try {
      final image = await imageService.pickImage(ImageSource.gallery);
      if (image == null) return null;
      final url = await imageService.uploadToCloudinary(image);
      print("url : $url");
      if (url != null && url.isNotEmpty) {
        imageUrl.value = url;
        cover.text = url;
      }
      return url;
    } catch (e) {
      rethrow;
    }
  }
}
