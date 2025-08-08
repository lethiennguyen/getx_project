import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:getx_statemanagement/data/core/api_client.dart';
import 'package:getx_statemanagement/data/repositories/users_repositories.dart';
import 'package:getx_statemanagement/views/home/home_page.dart';
import 'package:getx_statemanagement/views/login/login.dart';
import 'package:getx_statemanagement/views/product/detail_product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox(HiveBoxNames.auth);
  final box = Hive.box(HiveBoxNames.auth);
  final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
  final authRepo = AuthRepository(dio);
  runApp(MyApp(authRepo, initialRoute: isLoggedIn ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp(AuthRepository authRepo, {super.key, required this.initialRoute});

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
      ],
      initialRoute: initialRoute,
    );
  }
}
