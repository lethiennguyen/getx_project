import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../base/asset/base_asset.dart';
import '../../getx/controllers/shopping_cart_controller.dart';
import '../common/app_colors.dart';

class ShoppingCart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FromShoppingCart();
  }
}

class FromShoppingCart extends State<ShoppingCart> {
  final currencyFormatter = NumberFormat('#,##0', 'vi_VN');
  final cart = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFEFEF),
      appBar: appBar(),
      body: bodyShoppingCart(),
      bottomNavigationBar: bottomNavigatorBar(),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.delete<CartController>();
          Get.back();
        },
        icon: Icon(Icons.arrow_back_ios_new),
      ),
      backgroundColor: Colors.white,
      title: Text(
        'Gio Hang',
        style: GoogleFonts.nunitoSans(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(color: Colors.black26, height: 0.5),
      ),
      actions: [
        IconButton(onPressed: () {cart.removeSelected();}, icon: Image.asset(IconsAssets.trash_can)),
        SizedBox(width: 8),
      ],
    );
  }

  Widget bodyShoppingCart() {
    return Obx(() {
      final items = cart.items;
      if (items.isEmpty) {
        return const Center(child: Text('Giỏ hàng trống'));
      }
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = cart.items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: itemProductShoppingCart(
              productId: item.id,
              name: item.name,
              price: item.price,
              quantity: item.quantity,
              cover: item.cover,
              onDelete: () {
                cart.removeAt(index);
              },
              context: context,
              index: index
            ),
          );
        },
      );
    });
  }

  Widget itemProductShoppingCart({
    required int productId,
    required String name,
    required int price,
    required int quantity,
    required String cover,
    required VoidCallback? onDelete,
    required BuildContext context,
    required int index,
  }) {
    return Slidable(
      key: Key(productId.toString()),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (context) => onDelete?.call(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Obx(
              ()=> Checkbox(
                value: cart.checked[index],
                onChanged: (v) => cart.select(index,v ??false ),
                activeColor: kBrandOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '$cover',
                  width: 80,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 16, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$name',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff6B6B6B),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${currencyFormatter.format(price)}đ',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kBrandOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            increaseOrDecreaseSalary(index,quantity),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget increaseOrDecreaseSalary(int index, int quantity) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sửa',
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColorGray,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: textColorGray.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      cart.quantityChange(index, false);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        color: Colors.transparent,
                      ),
                      child: Icon(Icons.remove, size: 18, color: textColorGray),
                    ),
                  ),
                  Container(
                    width: 25,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: textColorGray, width: 1),
                        right: BorderSide(color: textColorGray, width: 1),
                      ),
                    ),
                    child: Center(
                      child:  Text(
                            '$quantity',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textColorGray,
                            ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      cart.quantityChange(index, true);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        color: Colors.transparent,
                      ),
                      child: Icon(Icons.add, size: 18, color: textColorGray),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomNavigatorBar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xffF7F7F7), width: 1)),
      ),
      child: Row(
        children: [
          // Checkbox section
          Expanded(
            flex: 2,
            child: Row(
              children: [
                 Transform.scale(
                  scale: 1.2,
                  child: Obx(
                    ()=> Checkbox(
                      value:cart.checkAll.value,
                      onChanged:(value){
                        cart.selectAll(value ?? false);
                      },
                      activeColor: kBrandOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "Tất cả",
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Total price section
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng tiền:',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    '${currencyFormatter.format(cart.sumItem.value)} ₫',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kBrandOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Buy button section
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                // Handle buy action
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kBrandOrange,
                  boxShadow: [
                    BoxShadow(
                      color: kBrandOrange.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Mua Hàng',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
