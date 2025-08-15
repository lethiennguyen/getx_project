import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/getx/controllers/shopping_cart_controller.dart';
import 'package:hive/hive.dart';

import '../../constans/hive_constants.dart';
import '../../data/dio/dio.dart';
import '../../data/repositories/users_repositories.dart';

class AppController extends GetxController {
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    final authBox = await Hive.openBox(HiveBoxNames.auth);
    isLoggedIn.value = authBox.get('isLoggedIn', defaultValue: false) as bool;
    final authRepo = AuthRepository(dio);
    await dotenv.load(fileName: '.env');
    Get.put<AuthRepository>(authRepo, permanent: true);

    Get.put<CartController>(CartController(), permanent: true);
  }

  Future<void> setLoggedIn(bool value) async {
    final authBox = Hive.box(HiveBoxNames.auth);
    await authBox.put('isLoggedIn', value);
    isLoggedIn.value = value;
  }
}
