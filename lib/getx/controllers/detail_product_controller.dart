import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/data/model/product.dart';
import 'package:getx_statemanagement/data/repositories/product_reponsitories.dart';
import 'package:getx_statemanagement/data/upload_image/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import '../../enums/discount.dart';

class DetailProductController extends GetxController {
  //final respon = ProductDetailRepository(dio);
  final respon = ProductDetailRepository();
  final product = Rx<Product?>(null);
  final name = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final cover = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();

  final formKey = GlobalKey<FormState>();
  final imageService = ImagePickerService();

  final autovalidateMode = AutovalidateMode.disabled.obs;
  final isSubmitting = false.obs;
  final isUploading = false.obs;
  final imageUrl = ''.obs;

  final isLoading = true.obs;

  // Lấy danh sách discount từ enum
  List<Discount> get discounts => Discount.values;
  final totalPrice = 0.0.obs;
  final selectedDiscount = Discount.none.obs;

  void calculateDiscount() {
    final double basePrice = double.tryParse(price.text) ?? 0.0;
    final discountPercent = selectedDiscount.value.value;
    totalPrice.value = basePrice * (1 - discountPercent / 100);

    String baseName = name.text.split(" - Giảm").first.trim();
    if (discountPercent > 0) {
      name.text = "$baseName - Giảm $discountPercent%";
    } else {
      name.text = baseName;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as int;

    fetchDetailProduct(id);
  }

  Future<void> fetchDetailProduct(id) async {
    try {
      isLoading.value = true;
      final result = await respon.getProductDetail(id);
      product.value = result;
      name.text = result.name;
      price.text = result.price.toString();
      quantity.text = result.quantity.toString();
      cover.text = result.cover;
    } catch (e) {
      //print('Lỗi fetch chi tiết sản phẩm: $e');
    } finally {
      await Future.delayed(const Duration(milliseconds: 1000));
      isLoading.value = false;
    }
  }

  Future<bool> deleteProduct(id) async {
    final isSucssec = await respon.deleteProduct(id);
    if (isSucssec) {
      Get.snackbar(
        'Thành công',
        'Đã xoá sản phẩm',
        snackPosition: SnackPosition.TOP,
      );
      return true;
    } else {
      Get.snackbar(
        'Lỗi',
        'Đã xảy ra lỗi khi xoá sản phẩm',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }

  Future<bool> upDateProduct(
    id, {
    required String name,
    required int price,
    required int quantity,
    required String coverUrl,
  }) async {
    autovalidateMode.value = AutovalidateMode.always;

    final hasCover = coverUrl.isNotEmpty;
    if (!hasCover) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng chọn ảnh sản phẩm',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    isSubmitting.value = true;
    try {
      final result = await respon.putProductUpdate(
        id,
        name: name.trim(),
        price: price,
        quantity: quantity,
        cover: coverUrl,
      );
      product.value = result;
      return result != null;
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể lưu. Vui lòng thử lại.',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String?> pickAndUploadImage() async {
    try {
      final image = await imageService.pickImage(ImageSource.gallery);
      if (image == null) return null;
      final url = await imageService.uploadToCloudinary(image);
      if (url != null && url.isNotEmpty) {
        imageUrl.value = url;
        cover.text = url;
      }
      return url;
    } catch (e) {
      return null;
    }
  }
}
