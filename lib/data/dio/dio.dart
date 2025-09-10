import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:hive/hive.dart';

class ApiClient {
  final Dio dio = Dio();

  ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioError error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            // Xử lý khi token hết hạn
            await _handleTokenExpired();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _handleTokenExpired() async {
    final box = await Hive.openBox(HiveBoxNames.auth);
    await box.delete(HiveKeys.token);
    Get.offAllNamed('/login');
  }
}
