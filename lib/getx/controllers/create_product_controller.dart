import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/model/product.dart';
import '../../data/repositories/product_reponsitories.dart';
import '../../data/upload_image/image_picker_service.dart';
import '../../enums/discount.dart';

class CreateProductController extends GetxController {
  final name = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();
  final cover = ''.obs;

  //final respon = CreateProductRepository(dio);
  final respon = CreateProductRepository();
  final imageService = ImagePickerService();
  var product = Rx<Product?>(null);

  final formKey = GlobalKey<FormState>();

  final isSubmitting = false.obs;
  final autovalidateMode = AutovalidateMode.disabled.obs;
  var isUploading = false.obs;

  var selectedTax = Tax.none.obs;

  // Lấy danh sách discount từ enum
  List<Tax> get discounts => Tax.values;
  final totalPrice = 0.0.obs;

  void calculateDiscount() {
    final double basePrice = double.tryParse(price.text) ?? 0.0;
    final taxPercent = selectedTax.value.value; // % từ enum
    totalPrice.value = basePrice * (1 + taxPercent / 100);
  }

  Future<bool> createProduct({
    required TextEditingController name,
    required TextEditingController priceCtrl,
    required TextEditingController quantityCtrl,
    required RxString cover,
  }) async {
    autovalidateMode.value = AutovalidateMode.always;
    isSubmitting.value = true;
    try {
      final result = await respon.postCreateProdcut(
        name: name.text.trim(),
        price: int.parse(priceCtrl.text),
        quantity: int.parse(quantityCtrl.text),
        cover: cover.value,
      );
      return result != null;
    } catch (e) {
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  void revalidateOnChange() {
    if (autovalidateMode.value == AutovalidateMode.always) {
      formKey.currentState?.validate();
    }
  }

  @override
  void onClose() {
    name.dispose();
    super.onClose();
  }

  Future<void> pickAndUploadImage() async {
    try {
      final image = await imageService.pickImage(ImageSource.gallery);
      if (image == null) return;
      final url = await imageService.uploadToCloudinary(image);
      if (url != null) {
        cover.value = url;
      }
    } catch (e) {
      // print('Lỗi upload ảnh: $e');
    }
  }
}
