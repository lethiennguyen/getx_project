import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:getx_statemanagement/data/core/constants.dart';
import 'package:getx_statemanagement/data/dio/dio.dart';
import 'package:getx_statemanagement/data/response/users_respon.dart';
import 'package:hive/hive.dart';

class AuthRepository {
  Future<LoginResponse> postUserProviders({
    required int tax_code,
    required String users_name,
    required String password,
  }) async {
    try {
      final res = await ApiClient().dio.post(
        ApiConfig.login,
        data: {
          'tax_code': tax_code,
          'user_name': users_name,
          'password': password,
        },
      );

      final result = LoginResponse.fromJson(res.data);

      final box = Hive.box(HiveBoxNames.auth);
      box.put(HiveKeys.token, result.token);
      box.put(HiveKeys.tax_code, tax_code.toString());
      box.put(HiveKeys.user_name, users_name);

      return result;
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      return LoginResponse(success: false, message: 'Lỗi đăng nhập', token: '');
    }
  }
}
