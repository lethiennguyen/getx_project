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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Không có kết nối mạng",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
            "Vui lòng kiểm tra lại Wi-Fi hoặc dữ liệu di động.",
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _dialogShown = false;
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
