import 'package:dio/dio.dart';

import 'access_token_interceptor.dart';

class ApiClient {
  final Dio dio = Dio();

  ApiClient() {
    dio.interceptors.add(AccessTokenInterceptor());
  }
}
