import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/getx/controllers/detail_product_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/upload_image/upload_image_network.dart';
import '../../enums/product_field.dart';
import '../common/input_field.dart';

class ShowPopUp {
  static Widget bottomSheet(
    BuildContext context,
    DetailProductController controller,
  ) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(
            child: _customItemProduct(context, controller),
          ),
        );
      },
    );
  }

  static Widget _imagePicker(DetailProductController controller) {
    return Obx(
      () => ImagePickerWidget(
        label: 'Ảnh sản phẩm',
        width: 200,
        height: 200,
        imageUrl:
            controller.imageUrl.value.isNotEmpty
                ? controller.imageUrl.value
                : controller.cover.text,
        isLoading: controller.isUploading.value,
        progress: 0,
        onTap: () {
          controller.pickAndUploadImage();
        },
        placeholder: const Icon(Icons.person, size: 60),
      ),
    );
  }

  static Widget _customItemProduct(
    BuildContext context,
    DetailProductController controller,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _imagePicker(controller),
          const SizedBox(height: 16),
          ModernInputField(
            label: ProductField.name.lable ,
            hintText: ProductField.name.hint,
            controller: controller.name,
            focusNode: controller.nameFocus,
            validator: ProductField.name.validate,
            keyboardType: TextInputType.text,
          ),
          ModernInputField(
            label: 'Giá',
            hintText: 'Nhập giá sản phẩm',
            label: ProductField.price.lable,
            hintText: ProductField.price.hint,
            controller: controller.price,
            focusNode: controller.priceFocus,
            validator: ProductField.price.validate,
            keyboardType: TextInputType.number,
          ),
          ModernInputField(
            label: ProductField.quantity.lable,
            hintText: ProductField.quantity.hint,
            validator: ProductField.quantity.validate,
            controller: controller.quantity,
            focusNode: controller.quantityFocus,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: () {
              Get.back(
                result: {
                  'name': controller.name.text,
                  'price': controller.price.text,
                  'quantity': controller.quantity.text,
                  'cover': controller.cover.text ?? controller.imageUrl,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 50),
              backgroundColor: const Color(0xffF24E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Update',
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
