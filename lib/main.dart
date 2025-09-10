import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/views/home/home_page.dart';
import 'package:getx_statemanagement/views/login/login.dart';
import 'package:getx_statemanagement/views/product/create_product_view.dart';
import 'package:getx_statemanagement/views/product/detail_product_view.dart';
import 'package:getx_statemanagement/views/shopping_cart/payment_view.dart';
import 'package:getx_statemanagement/views/shopping_cart/shopping_cart_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import 'constans/hive_constants.dart';
import 'constans/shopping_cart/hive_shopping_cart.dart';
import 'data/dio/dio.dart';
import 'getx/controllers/app_controller.dart';
import 'getx/controllers/shopping_cart_controller.dart';
import 'getx/service/network_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox(HiveBoxNames.auth);
  await Hive.openBox<CartItem>(HiveBoxNames.cartbox);
  final appController = Get.put<AppController>(
    AppController(),
    permanent: true,
  );
  await Get.putAsync(() => NetworkService().init());
  runApp(MyApp(appController: appController));
}

class MyApp extends StatelessWidget {
  final AppController appController;

  const MyApp({super.key, required this.appController});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: const Color(0xff5C6771),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: CircleBorder(),
          backgroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark(),
      getPages: [
        GetPage(name: '/login', page: () => MyHomeLogin()),
        GetPage(name: '/home', page: () => LogoutPage()),
        GetPage(name: '/thongtinsanpham', page: () => ProductInformation()),
        GetPage(name: '/add_product', page: () => CreateProduct()),
        GetPage(name: '/shopping_cart', page: () => ShoppingCart()),
        GetPage(name: '/payment', page: () => PayMentView()),
      ],
      initialRoute: appController.isLoggedIn.value ? '/home' : '/login',
      initialBinding: BindingsBuilder(() {
        Get.put<CartController>(CartController(), permanent: true);
      }),
    );
  }
}
