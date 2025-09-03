import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/getx/controllers/detail_product_controller.dart';
import 'package:getx_statemanagement/views/product/update_product_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../base/asset/base_asset.dart';
import '../../constans/shopping_cart/hive_shopping_cart.dart';
import '../../data/model/product.dart';
import '../../getx/controllers/shopping_cart_controller.dart';
import '../common/app_colors.dart';
import '../common/dialog.dart';
import '../common/size_box.dart';

class ProductInformation extends StatefulWidget {
  const ProductInformation({super.key});

  @override
  State<StatefulWidget> createState() {
    return FormProductInformation();
  }
}

class FormProductInformation extends State<ProductInformation> {
  final currencyFormatter = NumberFormat('#,##0', 'vi_VN');
  final controller = Get.put(DetailProductController());
  final cart = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Obx(() {
        final product = controller.product.value;
        if (product == null) {
          return Center(child: CircularProgressIndicator());
        }
        return _bodyformProduct(product: product);
      }),
      bottomNavigationBar: Obx(
        () => bottomNavigationBar(product: controller.product.value),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.offAllNamed('/home');
        },
        icon: Icon(Icons.arrow_back),
      ),
      backgroundColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(color: boderAppbar, height: 1),
      ),
      elevation: 0,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16),
          child: Stack(
            children: [
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();

                  Get.toNamed('/shopping_cart');
                },
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    IconsAssets.shopping_cart,
                    width: 24,
                    height: 24,
                  ),
                ),
                tooltip: 'Giỏ hàng',
              ),
              // Cart badge
              Obx(
                () =>
                    cart.items.isNotEmpty
                        ? Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: kBrandOrange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: kBrandOrange.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cart.items.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bodyformProduct({required Product product}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: boderAppbar, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xffF3F3F3), width: 1),
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(product.cover, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              '${currencyFormatter.format(product.price)} đ',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: informationCart,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 6, top: 16),
            child: Text(
              product.name,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 6,
              top: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Số lượng :',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${product.quantity}',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textGray,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(IconsAssets.start),
                    Text(
                      ' 5/5',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigationBar({required Product? product}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 16, 2, 21),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffE0E0E0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _bottomCartShopping(product),
          SizedBoxCustom.w3,
          _bottomDelete(product),
          SizedBoxCustom.w3,
          _bottomUpDate(product),
        ],
      ),
    );
  }

  Widget _bottomCartShopping(Product? product) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (product != null) {
            final id = product.id;
            if (id != null) {
              final item = CartItem(
                id: id,
                name: product.name,
                price: product.price,
                quantity: 1,
                cover: product.cover,
              );
              cart.addItem(item);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Đã thêm vào giỏ hàng!')));
            }
          }
        },
        child: Container(
          height: 54,
          decoration: BoxDecoration(color: Color(0xff29AA98)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(IconsAssets.shopping_cart, color: Colors.white),
              Text(
                'Thêm vào giỏ hàng',
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomDelete(Product? product) {
    return Expanded(
      child: _customBottom(
        onTap: () async {
          if (product != null) {
            final result = await showDialogProductDelete();
            if (result == true) {
              final resultDelete = await controller.deleteProduct(product.id);
              if (await cart.isItemInCart(product.id)) {
                await cart.removeById(product.id);
              }
              if (resultDelete == true) {
                await Future.delayed(Duration(milliseconds: 100));
                Get.offAllNamed('/home');
              }
            }
          }
        },
        icon: Icons.clear_outlined,
        textButton: 'Delete',
      ),
    );
  }

  Widget _bottomUpDate(Product? product) {
    return Expanded(
      child: _customBottom(
        onTap: () async {
          if (controller.product != null) {
            final result = await Get.bottomSheet(
              ShowPopUp.bottomSheet(context, controller),
              isScrollControlled: true,
            );
            if (result != null) {
              controller.upDateProduct(
                controller.product.value?.id,
                name: result['name'],
                price: int.parse(result['price']),
                quantity: int.parse(result['quantity']),
                coverUrl: result['cover'],
              );
            }
          }
        },
        icon: Icons.shopping_cart,
        textButton: 'Update',
      ),
    );
  }

  Widget _customBottom({
    required IconData icon,
    required String textButton,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 108,
        height: 54,
        decoration: BoxDecoration(color: informationCart),
        // onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              textButton,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> showDialogProductDelete() async {
    return await Get.dialog<bool>(
      CustomAlertDialogDeleteProduct(
        title: 'Thông báo',
        message: 'Bạn có chắc chắn xóa sản phẩm',
        onConfirm: () {
          Get.back(result: true);
        },
        onCancel: () {
          Get.back(result: false);
        },
      ),
    );
  }
}
