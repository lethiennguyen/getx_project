import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/enums/discount.dart';
import 'package:getx_statemanagement/getx/controllers/create_product_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/product.dart';
import '../../data/upload_image/upload_image_network.dart';
import '../../enums/product_field.dart';
import '../common/app_colors.dart';
import '../common/input_field.dart';

class CreateProduct extends StatelessWidget {
  final controller = Get.put(CreateProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: formAddProduct(controller.product.value),
      bottomNavigationBar: bottomNavigator(controller.product.value),
    );
  }

  Widget formAddProduct(Product? product) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: controller.formKey,
          autovalidateMode: controller.autovalidateMode.value,
          child: Column(
            children: [
              Obx(
                () => ImagePickerWidget(
                  label: ProductField.cover.lable,
                  width: 200,
                  height: 200,
                  imageUrl: controller.cover.value,
                  isLoading: controller.isUploading.value,
                  onTap: controller.pickAndUploadImage,
                  placeholder: const Icon(Icons.person, size: 60),
                ),
              ),

              ModernInputField(
                label: ProductField.name.lable,
                hintText: ProductField.name.hint,
                controller: controller.name,
                focusNode: controller.nameFocus,
                validator: ProductField.name.validate,
                keyboardType: TextInputType.text,
              ),

              Obx(() => formPriceProduct(product)),

              ModernInputField(
                label: ProductField.quantity.lable,
                hintText: ProductField.quantity.hint,
                controller: controller.quantity,
                focusNode: controller.quantityFocus,
                keyboardType: TextInputType.number,
                validator: ProductField.quantity.validate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formPriceProduct(Product? product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ModernInputField(
                label: ProductField.price.lable,
                hintText: ProductField.price.hint,
                controller: controller.price,
                focusNode: controller.priceFocus,
                keyboardType: TextInputType.number,
                validator: ProductField.price.validate,
                onChanged: (value) {
                  controller.calculateDiscount();
                },
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: ModernDropdownField<Tax>(
                label: 'Thuế',
                items: Tax.values,
                value: controller.selectedTax.value,
                itemLabel: (d) => d.label,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedTax.value = value;
                    controller.calculateDiscount();
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ModernInputField(
          label: "Thành tiền",
          controller: TextEditingController(
            text: controller.totalPrice.value.toStringAsFixed(0),
          ),
          hintText: "0 đ",
          readOnly: true,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget bottomNavigator(Product? product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () async {
          final cuccess = await controller.createProduct(
            name: controller.name,
            priceCtrl: TextEditingController(
              text: controller.totalPrice.value.toStringAsFixed(0),
            ),
            quantityCtrl: controller.quantity,
            cover: controller.cover,
          );
          if (cuccess) {
            Get.offAllNamed('/home');
          } else {
            Get.snackbar(
              'Thất bại',
              'Không thể tạo sản phẩm',
              snackPosition: SnackPosition.TOP,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kBrandOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Thêm sản phẩm',
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
