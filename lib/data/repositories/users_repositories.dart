import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:getx_statemanagement/data/core/constants.dart';
import 'package:getx_statemanagement/data/dio/dio.dart';
import 'package:getx_statemanagement/data/response/users_respon.dart';
import 'package:hive/hive.dart';

class AuthRepository {
  AuthRepository(dio);

  Future<LoginResponse> postUserProviders({
    required int tax_code,
    required String users_name,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        ApiConfig.login,
        data: {
          'tax_code': tax_code,
          'user_name': users_name,
          'password': password,
        },
      );
      dev.log(ApiConfig.login);
      final result = LoginResponse.fromJson(res.data);
      if (!result.success || result.token.isEmpty) {
        throw Exception(result.message);
      }
      dev.log('$result');
      final box = Hive.box(HiveBoxNames.auth);
      box.put(HiveKeys.token, result.token);
      box.put(HiveKeys.tax_code, tax_code.toString());
      box.put(HiveKeys.user_name, users_name);
      return result;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
