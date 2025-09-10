import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import '../dio/dio.dart';

abstract class BaseRepository {
  String get token {
    final box = Hive.box(HiveBoxNames.auth);
    return box.get(HiveKeys.token) ?? '';
  }
}
