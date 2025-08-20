import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:getx_statemanagement/views/common/input_field.dart';
import 'package:hive/hive.dart';

import '../../enums/discount.dart';

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
      body: customImformation(),
      bottomNavigationBar: ElevatedButton.icon(
        onPressed: () => _onLogout(context),
        label: const Text('Đăng xuất', style: TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget customImformation() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Thông tin người dùng',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text('Tên người dùng: John Doe'),
          Text('Email:'),
          Text('Số điện thoại: 123-456-7890'),
        ],
      ),
    );
  }

  // Widget disountAll() {
  //   return Container(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         ModernDropdownField<Discount>(
  //           label: 'Giảm giá',
  //           items: Discount.values,
  //           value: ,
  //           itemLabel: (d) => d.label,
  //           onChanged: (value) {
  //             if (value != null) {
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
