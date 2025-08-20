import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:getx_statemanagement/constans/shopping_cart/hive_shopping_cart.dart';
import 'package:hive/hive.dart';

class CartController extends GetxController {
  late final Box<CartItem> _box;

  final RxList<CartItem> items = <CartItem>[].obs;
  final RxList<bool> checked =<bool>[].obs;
  final RxBool checkAll = false.obs;
  final RxDouble sumItem = 0.0.obs;
  final isIncrease = false.obs;
  final isDecrease = false.obs;
  @override
  void onInit() {
    super.onInit();
    _box = Hive.box<CartItem>(HiveBoxNames.cartbox);
    items.assignAll(_box.values.toList());
    checked.assignAll(List<bool>.filled(items.length, false));
    checkAll.value = false;
    sumItem.value = 0.0;
    sum();

  }
  @override
  void onClose() {
    checked.clear();
    checkAll.value = false;
    sumItem.value = 0.0;
    super.onClose();
  }

  List<CartItem> get selectedItems => [
    for (int i = 0; i < items.length; i++)
      if (checked[i]) items[i],
  ];

  // xóa theo id
  Future<void> removeById(int? id) async {
    final index = items.indexWhere((item) => item.id == id);
    items.removeAt(index);
    checked.removeAt(index);
    _box.deleteAt(index);
    sum();
  }

  // thêm sản phẩm vào giỏ hàng
  Future<void> addItem(CartItem item) async {
    final exists = items.any((e) => e.id == item.id);
    if (exists) {
      return;
    }
    await _box.add(item);
    items.add(item);
    checked.add(false);
  }

  // tính tổng tiền
  void sum() {
    sumItem.value = 0;
    for (int i = 0; i < items.length; i++) {
      if (checked[i] || checkAll.value) {
        sumItem.value += items[i].price * items[i].quantity;
      }
    }
  }

  // tăng giảm số lượng
  void quantityChange(int index, bool isIncrease) {
    if (isIncrease) {
      ++items[index].quantity;
      isIncrease = true;
    } else {
      if (items[index].quantity > 1) {
        --items[index].quantity;
        isDecrease.value = true;
      }
    }
    items.refresh();
    _box.putAt(index, items[index]);
    sum();
  }

  // chọn theo index
  void select(int index, bool value) {
    checked[index] = value;
    sum();
  }

  // chọn tất cả
  void selectAll(bool value) {
    checkAll.value = value;
    checked.assignAll(List<bool>.filled(items.length, value));
    sum();
  }

  // xóa theo index
  Future<void> removeAt(int index) async {
    if (!checked[index]) return;
    final key = _box.keyAt(index);
    await _box.delete(key);
    items.removeAt(index);
    checked.removeAt(index);
    sum();
  }

  // xóa theo từng mục đã chọn
  Future<void> removeSelected() async {
    for (int i = items.length - 1; i >= 0; i--) {
      if (checked[i]) {
        final key = _box.keyAt(i);
        await _box.delete(key);
        items.removeAt(i);
        checked.removeAt(i);
      }
    }
    checkAll.value = false;
    sum();
  }
}
