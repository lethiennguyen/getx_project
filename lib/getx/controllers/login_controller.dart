import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:getx_statemanagement/data/dio/dio.dart';
import 'package:getx_statemanagement/data/repositories/users_repositories.dart';
import 'package:getx_statemanagement/enums/login_field.dart';
import 'package:hive/hive.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final Map<LoginField, TextEditingController> controllers = {
    for (var field in LoginField.values) field: TextEditingController(),
  };

  final Map<LoginField, FocusNode> focusNodes = {
    for (var field in LoginField.values) field: FocusNode(),
  };

  final fieldErrors = <LoginField, RxnString>{
    for (var field in LoginField.values) field: RxnString(),
  };

  String _getText(LoginField field) => controllers[field]?.text ?? '';

  late final Map<LoginField, RxString> texts = {
    for (var field in LoginField.values) field: _getText(field).obs,
  };

  final RxBool isPasswordVisible = false.obs;
  final isSubmitting = false.obs;
  final submitted = false.obs;
  final isClearing = false.obs;
  final authRepository = AuthRepository(dio);

  @override
  void onInit() {
    super.onInit();
    _restoreFromHive();
  }

  void validateField(LoginField field) {
    fieldErrors[field]!.value = field.validate(controllers[field]!.text);
  }

  Future<void> login() async {
    submitted.value = true;
    bool hasError = false;

    for (var field in LoginField.values) {
      validateField(field);
      if (fieldErrors[field]!.value != null) hasError = true;
    }
    if (hasError) return;
    isSubmitting.value = true;
    try {
      final tax_code = controllers[LoginField.tax_code];
      final uses_name = controllers[LoginField.user_name];
      final password = controllers[LoginField.password];
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
    } catch (e) {
    } finally {
      isSubmitting.value = false;
    }
  }

  // điền thông tin sa khi dăng nhập
  void _restoreFromHive() {
    final tax_code = controllers[LoginField.tax_code];
    final uses_name = controllers[LoginField.user_name];
    final password = controllers[LoginField.password];
    if (tax_code == null || uses_name == null || password == null) {
      return;
    }
    final box = Hive.box(HiveBoxNames.auth);
    tax_code.text = box.get(HiveKeys.tax_code, defaultValue: '').toString();
    uses_name.text = box.get(HiveKeys.user_name, defaultValue: '');
    password.text = box.get(HiveKeys.password, defaultValue: '');
  }

  @override
  void onClose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    for (var f in focusNodes.values) {
      f.dispose();
    }
    super.onClose();
  }
}
