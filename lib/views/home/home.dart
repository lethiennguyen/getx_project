import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:hive/hive.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  Future<void> _onLogout(BuildContext context) async {
    final box = Hive.box(HiveBoxNames.auth);
    box.put('isLoggedIn', false);
    await box.delete(HiveKeys.token);
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Trang chính')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _onLogout(context),
          label: const Text('Đăng xuất', style: TextStyle(color: Colors.black)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
