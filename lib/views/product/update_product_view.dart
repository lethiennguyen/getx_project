import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/getx/controllers/detail_product_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/upload_image/upload_image_network.dart';
import '../../enums/discount.dart';
import '../../enums/product_field.dart';
import '../common/input_field.dart';
import '../common/size_box.dart';

class ShowPopUp {
  static Widget bottomSheet(
    BuildContext context,
    DetailProductController controller,
  ) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
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
          SizedBoxCustom.h16,
          ModernInputField(
            label: ProductField.name.lable,
            hintText: ProductField.name.hint,
            controller: controller.name,
            focusNode: controller.nameFocus,
            validator: ProductField.name.validate,
            keyboardType: TextInputType.text,
          ),
          Obx(() => _formPriceProduct(controller)),
          ModernInputField(
            label: ProductField.quantity.lable,
            hintText: ProductField.quantity.hint,
            validator: ProductField.quantity.validate,
            controller: controller.quantity,
            focusNode: controller.quantityFocus,
            keyboardType: TextInputType.number,
          ),
          SizedBoxCustom.h80,
          ElevatedButton(
            onPressed: () {
              Get.back(
                result: {
                  'name': controller.name.text,
                  'price': controller.totalPrice.value.toStringAsFixed(0),
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

  static Widget _formPriceProduct(DetailProductController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ModernInputField(
                isboderRadius: false,
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
            SizedBoxCustom.h12,
            Expanded(
              flex: 1,
              child: ModernDropdownField<Discount>(
                label: 'Giảm giá',
                items: Discount.values,
                value: controller.selectedDiscount.value,
                itemLabel: (d) => d.label,
                focusNode: controller.priceFocus,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedDiscount.value = value;
                    controller.calculateDiscount();
                  }
                },
              ),
            ),
          ],
        ),
        SizedBoxCustom.h8,
        ModernInputField(
          label: "Thành tiền",
          controller: TextEditingController(
            text: controller.totalPrice.value.toStringAsFixed(0),
          ),
          hintText: "0 đ",
          readOnly: true,
        ),
        SizedBoxCustom.h16,
      ],
    );
  }
}
