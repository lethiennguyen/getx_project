import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/base/asset/base_asset.dart';
import 'package:getx_statemanagement/enums/login_field.dart';
import 'package:getx_statemanagement/getx/controllers/login_controller.dart';
import 'package:getx_statemanagement/views/common/app_colors.dart';
import 'package:getx_statemanagement/views/common/dialog.dart';
import 'package:getx_statemanagement/views/common/size_box.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../common/input_field.dart';

class MyHomeLogin extends StatefulWidget {
  @override
  State<MyHomeLogin> createState() => _MyHomeLoginState();
}

class _MyHomeLoginState extends State<MyHomeLogin> {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => SingleChildScrollView(child: SafeArea(child: _formLogin())),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 21),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _bottomNavigator(
                asset: IconsAssets.headphone,
                textButton: 'Trợ giúp',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _bottomNavigator(
                asset: IconsAssets.Social_link,
                textButton: 'Group',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _bottomNavigator(
                asset: IconsAssets.search_normal,
                textButton: 'Tra cứu',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formLogin() {
    return Stack(
      children: [
        SizedBoxCustom.h76,
        SvgPicture.asset(Pictures.logo, width: 158, height: 37),
        SizedBoxCustom.h61,
        SingleChildScrollView(
          padding: EdgeInsets.only(top: 137, right: 16, left: 16),
          child: Form(
            key: controller.formKey,
            autovalidateMode:
                controller.submitted.value
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
            child: Column(
              children: [
                AppInputField(
                  label: LoginField.tax_code.lable,
                  hint: LoginField.tax_code.hint,
                  controller: controller.tax_code_controller,
                  focusNode: controller.tax_code_focus,
                  keyboardType: LoginField.tax_code.keyboardType,
                  validator: LoginField.tax_code.validate,
                  errorText: controller.errorTax_code.value,
                  onChanged: () {
                    controller.validateField(LoginField.tax_code);
                  },
                ),

                AppInputField(
                  label: LoginField.user_name.lable,
                  hint: LoginField.user_name.hint,
                  controller: controller.user_name_controller,
                  focusNode: controller.user_name_focus,
                  keyboardType: LoginField.user_name.keyboardType,
                  validator: LoginField.user_name.validate,
                  errorText: controller.errorUser_name.value,
                  onChanged: () {
                    controller.validateField(LoginField.user_name);
                  },
                ),

                AppInputField(
                  label: LoginField.password.lable,
                  hint: LoginField.password.hint,
                  controller: controller.password_controller,
                  focusNode: controller.password_focus,
                  keyboardType: LoginField.password.keyboardType,
                  validator: LoginField.password.validate,
                  isPassword: LoginField.password.isPassword,
                  errorText: controller.errorPassword.value,
                  onChanged: () {
                    controller.validateField(LoginField.password);
                  },
                ),

                SizedBox(height: 20),
                _buttonLogin(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonLogin() {
    return Obx(() {
      return Container(
        width: 343,
        height: 54,
        decoration: BoxDecoration(color: kBrandOrange),
        child: ElevatedButton(
          onPressed:
              controller.isSubmitting.value
                  ? null
                  : () => controller.login(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: kBrandOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child:
              controller.isSubmitting.value
                  ? Lottie.asset(Lotteri.loading, width: 50, height: 50)
                  : Text(
                    'Đăng nhập',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
        ),
      );
    });
  }

  Widget _bottomNavigator({required String asset, required String textButton}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(width: 1, color: Color(0xffEBECED)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(asset, width: 20, height: 20),
            SizedBoxCustom.h8,
            Text(
              textButton,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDialogLogin(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => const CustomAlertDialog(
            title: 'Thông báo',
            message: 'Thông tin đăng nhập không hợp lệ',
          ),
    );
  }
}
