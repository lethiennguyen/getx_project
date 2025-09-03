import 'package:flutter/cupertino.dart';

enum LoginField { tax_code, user_name, password }

extension AuthUserExtentsion on LoginField {
  String? validate(String? value) {
    switch (this) {
      case LoginField.tax_code:
        value = (value ?? '').trim();
        if (value.length != 10) return "Mã số thuế phải đúng 10 ký tự";
        return null;
      case LoginField.user_name:
        if ((value ?? '').trim().isEmpty)
          return "Tài khoản không được để trống";
        return null;
      case LoginField.password:
        value = (value ?? '').trim();
        if (value.length < 6 || value.length > 50)
          return "Mật khẩu từ 6 đến 50 ký tự";
        return null;
    }
  }

  String get lable {
    switch (this) {
      case LoginField.tax_code:
        return "Mã số thuế";
      case LoginField.user_name:
        return "Tài khoản";
      case LoginField.password:
        return "Mật khẩu";
    }
  }

  String get hint {
    switch (this) {
      case LoginField.tax_code:
        return "000012";
      case LoginField.user_name:
        return "Tài khoản";
      case LoginField.password:
        return "Mật khẩu";
    }
  }

  TextInputType get keyboardType {
    switch (this) {
      case LoginField.tax_code:
        return TextInputType.number;
      case LoginField.user_name:
      case LoginField.password:
        return TextInputType.text;
    }
  }

  bool get isPassword => this == LoginField.password;
}
