import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// gọi hàm [showDialogLogin] dùng cho khi đăng nhập
class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onConfirm;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.nunitoSans(
                color: const Color(0xffF24E1E),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.nunitoSans(
                color: const Color(0xff000000),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onConfirm ?? () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 30),
                backgroundColor: const Color(0xffF24E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialogDeleteProduct extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  const CustomAlertDialogDeleteProduct({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.nunitoSans(
                color: const Color(0xffF24E1E),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.nunitoSans(
                color: const Color(0xff000000),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onCancel ?? () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 40),
                    backgroundColor: const Color(0xffF24E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 40),
                    backgroundColor: const Color(0xffF24E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
