import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/shopping_cart/hive_shopping_cart.dart';
import 'package:getx_statemanagement/getx/controllers/list_poduct_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../base/asset/base_asset.dart';
import '../../data/model/product.dart';
import '../../enums/product_type.dart';
import '../../getx/controllers/shopping_cart_controller.dart';
import '../common/app_colors.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProductListScreen();
  }
}

class ProductListScreen extends State<ProductList> {
  Category _category = Category.all;
  final controller = Get.put(ListProductController());
  final cart = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Obx(() => _formProductList(controller.products)),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: SvgPicture.asset(Pictures.logo, width: 158, height: 37),
      backgroundColor: Colors.white,
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
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(color: Color(0xfffffffe), height: 1),
      ),
    );
  }

  Widget _formProductList(List<Product> products) {
    return RefreshIndicator(
      onRefresh: () async => controller.refreshPage(),
      child: CustomScrollView(
        controller: controller.scroll,
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 10)),

          SliverToBoxAdapter(child: typeProduct()),

          if (controller.isPullToRefresh.value)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),

          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    ProductItem(product: controller.products[index]),
                childCount: controller.products.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 3 / 4.5,
              ),
            ),
          ),

          if (controller.isLoadingMore.value)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget typeProduct() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Category.values.length,
        itemBuilder: (context, index) {
          final category = Category.values[index];
          final selected = category == _category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ElevatedButton(
              onPressed: () => setState(() => _category = category),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(40, 20),
                backgroundColor: selected ? kBrandOrange : Colors.white,
                foregroundColor: selected ? Colors.white : Colors.black,
                side: BorderSide(color: selected ? kBrandOrange : Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(category.label),
            ),
          );
        },
      ),
    );
  }

  Widget ProductItem({required Product product}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () async {
          final result = await Get.toNamed(
            '/thongtinsanpham',
            arguments: product.id,
          );
          if (result != null || result == 'deleted') {
            controller.refreshPage();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: textGray),
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    product.cover,
                    fit: BoxFit.cover,
                    height: 160,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                          top: 8,
                          right: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${controller.formatPrice(product.price)}',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Đã thêm vào giỏ hàng!'),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: kBrandOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
