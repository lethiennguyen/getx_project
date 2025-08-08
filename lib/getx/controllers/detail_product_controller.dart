import 'package:get/get.dart';
import 'package:getx_statemanagement/data/model/product.dart';
import 'package:getx_statemanagement/data/repositories/product_reponsitories.dart';

import '../../data/dio/dio.dart';

class DetailProductController extends GetxController {
  final respon = ProductDetailRepository(dio);
  final product = Rx<Product?>(null);
  final name = ''.obs;
  final price = ''.obs;
  final quantity = ''.obs;
  final cover = ''.obs;
  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as int;
    fetchDetailProduct(id);
  }

  Future<void> fetchDetailProduct(id) async {
    final result = await respon.getProductDetail(id);
    product.value = result;
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

  Future<void> upDateProduct(id) async {
    final result = await respon.putProductUpdate(
      id,
      name: name.value,
      price: int.parse(price.value),
      quantity: int.parse(quantity.value),
      cover: cover.value,
    );
    product.value = result;
  }
}
