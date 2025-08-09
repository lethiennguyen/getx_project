import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:getx_statemanagement/constans/shopping_cart/hive_shopping_cart.dart';
import 'package:hive/hive.dart';

class CartController extends GetxController {
  late final Box<CartItem> _box;

  final RxList<CartItem> items = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box<CartItem>(HiveBoxNames.cartbox);
    items.assignAll(_box.values.toList());
  }

  Future<void> addItem(CartItem item) async {
    final exists = items.any((e) => e.id == item.id);
    if (exists) {
      Get.snackbar(
        'Thông báo',
        'Sản phẩm đã có trong giỏ',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    await _box.add(item);
    items.add(item);
  }

  Future<void> removeAt(int index) async {
    final key = _box.keyAt(index);
    await _box.delete(key);
    items.removeAt(index);
  }
}
