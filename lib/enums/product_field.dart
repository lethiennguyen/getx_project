import 'package:flutter/cupertino.dart';

enum ProductField { name, price, quantity, cover }

extension ProductFieldExtentsion on ProductField {
  String get lable {
    switch (this) {
      case ProductField.cover:
        return "Ảnh sản phẩm";
      case ProductField.name:
        return "Tên sản phẩm";
      case ProductField.price:
        return "Giá";
      case ProductField.quantity:
        return "Số lượng tồn kho";
    }
  }

  String get hint {
    switch (this) {
      case ProductField.name:
        return "Tên sản phẩm";
      case ProductField.price:
        return "Giá";
      case ProductField.quantity:
        return "Số lượng tồn kho";
      case ProductField.cover:
        return "Chọn ảnh sản phẩm";
    }
  }

  TextInputType get keyboardType {
    switch (this) {
      case ProductField.price:
      case ProductField.quantity:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  String? validate(String? value) {
    switch (this) {
      case ProductField.cover:
        if (value == null || value.isEmpty)
          return "Ảnh sản phẩm không được để trống";
        return null;
      case ProductField.price:
        value = (value ?? '').trim();
        if (value.length == 0) return "Giá không được để trống";
        if (int.tryParse(value) == null || int.parse(value) <= 0)
          return "Giá phải là số dương";
        return null;
      case ProductField.quantity:
        if (value == null || value.isEmpty)
          return "Số lượng không được để trống";
        if (int.tryParse(value ?? '') == null || int.parse(value ?? '') <= 0)
          return "Số lượng phải là số dương";
        return null;
      case ProductField.name:
        value = (value ?? '').trim();
        if (value.isEmpty) return "Tên sản phẩm không được để trống";
        return null;
    }
  }
}
