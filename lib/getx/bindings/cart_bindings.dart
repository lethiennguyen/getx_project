import 'package:get/get.dart';
import 'package:getx_statemanagement/getx/controllers/shopping_cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController());
}
}