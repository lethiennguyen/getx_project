enum Category {
  all,
  dongHo,
  dienThoai,
  tuiXach,
  laptop,
}
extension CategoryExtension on Category {
  String get label {
    switch (this) {
      case Category.all:
        return 'Tất cả';
      case Category.dongHo:
        return 'Đồng hồ';
      case Category.dienThoai:
        return 'Điện thoại';
      case Category.tuiXach:
        return 'Túi xách';
      case Category.laptop:
        return 'Laptop';
    }
  }
}
