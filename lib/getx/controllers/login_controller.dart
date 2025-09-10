import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:getx_statemanagement/data/dio/dio.dart';
import 'package:getx_statemanagement/data/repositories/users_repositories.dart';
import 'package:getx_statemanagement/enums/login_field.dart';
import 'package:hive/hive.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController tax_code_controller = TextEditingController();
  final TextEditingController user_name_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();

  final FocusNode tax_code_focus = FocusNode();
  final FocusNode user_name_focus = FocusNode();
  final FocusNode password_focus = FocusNode();

  final errorTax_code = RxString('');
  final errorUser_name = RxString('');
  final errorPassword = RxString('');

  final RxBool isPasswordVisible = false.obs;
  final isSubmitting = false.obs;
  final submitted = false.obs;

  final authRepository = AuthRepository();

  @override
  void onInit() {
    super.onInit();
    _restoreFromHive();
  }

  void validateField(LoginField field) {
    switch (field) {
      case LoginField.tax_code:
        errorTax_code.value =
            LoginField.tax_code.validate(tax_code_controller.text) ?? '';
        break;
      case LoginField.user_name:
        errorUser_name.value =
            LoginField.user_name.validate(user_name_controller.text) ?? '';
        break;
      case LoginField.password:
        errorPassword.value =
            LoginField.password.validate(password_controller.text) ?? '';
        break;
    }
  }

  /// Validate tất cả các field
  bool _validateAllFields() {
    bool hasError = false;
    for (var field in LoginField.values) {
      validateField(field);
      switch (field) {
        case LoginField.tax_code:
          if (errorTax_code.value.isNotEmpty) hasError = true;
          break;
        case LoginField.user_name:
          if (errorUser_name.value.isNotEmpty) hasError = true;
          break;
        case LoginField.password:
          if (errorPassword.value.isNotEmpty) hasError = true;
          break;
      }
    }
    return !hasError;
  }

  Future<void> login() async {
    submitted.value = true;
    isSubmitting.value = true;
    if (!_validateAllFields()) {
      isSubmitting.value = false;
      return;
    }
    try {
      final tax_code = tax_code_controller;
      final uses_name = user_name_controller;
      final password = password_controller;
      if (tax_code == null || uses_name == null || password == null) {
        return;
      }
      final result = await authRepository.postUserProviders(
        tax_code: int.parse(tax_code.text),
        users_name: uses_name.text,
        password: password.text,
      );
      if (result != null) {
        final box = Hive.box(HiveBoxNames.auth);
        box.put('isLoggedIn', true);

        Get.offAllNamed('/home');
      }
    }
    /*catch (e) {
      print('Login error: $e');
    }*/
    finally {
      isSubmitting.value = false;
    }
  }

  // điền thông tin sa khi dăng nhập
  void _restoreFromHive() {
    final tax_code = tax_code_controller;
    final uses_name = user_name_controller;
    final password = password_controller;
    if (tax_code == null || uses_name == null || password == null) {
      return;
    }
    final box = Hive.box(HiveBoxNames.auth);
    tax_code.text = box.get(HiveKeys.tax_code, defaultValue: '').toString();
    uses_name.text = box.get(HiveKeys.user_name, defaultValue: '');
    password.text = box.get(HiveKeys.password, defaultValue: '');
  }
}
