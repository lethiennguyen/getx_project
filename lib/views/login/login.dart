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
                _buildInputField(field: LoginField.tax_code),
                _buildInputField(field: LoginField.user_name),
                _buildInputField(field: LoginField.password, isPassword: true),
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
              controller.isSubmitting.value ? null : () => controller.login(),
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

  Widget _buildInputField({
    required LoginField field,
    bool isPassword = false,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.lable,
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xff242E37),
            ),
          ),
          TextFormField(
            onChanged: (value) {
              controller.validateField(field);
              setState(() {});
            },
            validator: (value) {
              final msg = field.validate(value);
              return msg;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: controller.focusNodes[field],
            keyboardType: field.keyboardType,
            obscureText:
                isPassword ? !controller.isPasswordVisible.value : false,
            controller: controller.controllers[field],
            cursorColor: Color(0xffF24E1E),
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                height: 0,
                fontSize: 0,
                color: Colors.transparent,
              ),
              errorText: null,
              contentPadding: EdgeInsets.all(16),
              hintText: field.hint,
              suffixIcon:
                  isPassword
                      ? GestureDetector(
                        onTap: () {
                          controller.isPasswordVisible.toggle();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            controller.isPasswordVisible.value
                                ? IconsAssets.eye_slash
                                : IconsAssets.eye,
                            width: 12,
                            height: 12,
                          ),
                        ),
                      )
                      : controller.controllers[field]!.text.isNotEmpty
                      ? GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.isClearing.value = true;
                            controller.controllers[field]!.clear();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            IconsAssets.clear,
                            width: 10,
                            height: 10,
                          ),
                        ),
                      )
                      : null,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kBrandOrange2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 16),
            height: 16,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                controller.fieldErrors[field]!.value ?? '',
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xffFF0000),
                ),
              ),
            ),
          ),
          SizedBoxCustom.h4,
        ],
      );
    });
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
