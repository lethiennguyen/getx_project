import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getx_statemanagement/getx/controllers/shopping_cart_controller.dart';
import 'package:getx_statemanagement/views/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../common/size_box.dart';

class PayMentView extends StatefulWidget {
  const PayMentView({Key? key}) : super(key: key);

  @override
  State<PayMentView> createState() => _PayMentViewState();
}

class _PayMentViewState extends State<PayMentView> {
  final cart = Get.find<CartController>();
  final currencyFormatter = NumberFormat('#,##0', 'vi_VN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán")),
      body: formPayment(),
    );
  }

  Widget formPayment() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [formProduct()]),
      ),
    );
  }

  Widget formProduct() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            formPaymentItem(),
            SizedBoxCustom.h10,
            bottomNavigator(),
            SizedBoxCustom.h10,
          ],
        ),
      ),
    );
  }

  Widget formPaymentItem() {
    return ListView.builder(
      itemCount: cart.selectedItems.length,
      itemBuilder: (context, index) {
        final item = cart.selectedItems[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: itemProductShoppingCart(
            productId: item.id,
            name: item.name,
            price: item.price,
            quantity: item.quantity,
            cover: item.cover,
            context: context,
            index: index,
          ),
        );
      },
    );
  }

  Widget itemProductShoppingCart({
    required int productId,
    required String name,
    required int price,
    required int quantity,
    required String cover,
    required BuildContext context,
    required int index,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SizedBoxCustom.h10,
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
                  SizedBoxCustom.h8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${currencyFormatter.format(price)}đ',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kBrandOrange,
                        ),
                      ),
                      Text(
                        'X $quantity',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff6B6B6B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget bottomNavigator() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('Tồng tiền', style: TextStyle(color: Colors.grey)),
              Text(
                '1.000.000đ',
                style: TextStyle(
                  color: kBrandOrange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Thanh toán thành công!')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kBrandOrange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: Text('Thanh toán', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
