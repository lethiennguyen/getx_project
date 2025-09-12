import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';

import '../../constans/hive_constants.dart';

class AccessTokenInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      // Xử lý khi token hết hạn
      await _handleTokenExpired();
    }
    return handler.next(error);
  }

  Future<void> _handleTokenExpired() async {
    final box = await Hive.openBox(HiveBoxNames.auth);
    await box.delete(HiveKeys.token);
    Get.offAllNamed('/login');
  }
}
