import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkService extends GetxService {
  final hasInternet = true.obs;
  bool _dialogShown = false;

  Future<NetworkService> init() async {
    InternetConnectionChecker().onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        hasInternet.value = false;
        _showNoInternetDialog();
      } else {
        hasInternet.value = true;
        _closeDialogIfOpen();
      }
    });
    return this;
  }

  void _showNoInternetDialog() {
    if (!_dialogShown) {
      _dialogShown = true;
      Get.dialog(
        AlertDialog(
          title: const Text("Không có kết nối mạng"),
          content: const Text(
            "Vui lòng kiểm tra lại Wi-Fi hoặc dữ liệu di động.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                _dialogShown = false;
                Get.back();
              },
              child: const Text("Đóng"),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  void _closeDialogIfOpen() {
    if (_dialogShown) {
      _dialogShown = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }
}
