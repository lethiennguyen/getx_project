import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/constans/shopping_cart/hive_shopping_cart.dart';
import 'package:getx_statemanagement/getx/controllers/list_poduct_controller.dart';
import 'package:getx_statemanagement/views/common/size_box.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../common/base_asset.dart';
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
      body: _formProductList(controller.products),
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
      child: Obx(
        () => CustomScrollView(
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
              sliver: Obx(() {
                if (controller.isLoading.value) {
                  return SliverSkeletonizer(
                    enabled: true,
                    child: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildProductSkeleton(),
                        childCount: 6,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 3 / 4.5,
                      ),
                    ),
                  );
                }
                // No Data sẽ hiện khi load xong mà k có data
                if (controller.products.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: kBrandOrange,
                            ),
                            Text(
                              'Không có sản phẩm nào',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBoxCustom.h16,
                            ElevatedButton(
                              onPressed: controller.refreshPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBrandOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Text(
                                'Tải lại',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // loafd sản phẩm khi có data
                  return SliverGrid(
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
                  );
                }
              }),
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
      ),
    );
  }

  // TODO:sử dụng pull_to_refresh_flutterv3
  // Widget _formProductList(List<Product> product) {
  //   return SmartRefresher(
  //     controller: controller.refreshController,
  //     enablePullDown: true,
  //     enablePullUp: true,
  //     header: const WaterDropHeader(),
  //     onRefresh: controller.refreshPage,
  //     onLoading: controller.loadMorePage,
  //     child: CustomScrollView(
  //       slivers: [
  //         SliverToBoxAdapter(child: SizedBox(height: 10)),
  //         SliverToBoxAdapter(child: typeProduct()),
  //         SliverPadding(
  //           padding: const EdgeInsets.all(8),
  //           sliver: Obx(() {
  //             if (controller.isLoading.value) {
  //               return SliverGrid(
  //                 delegate: SliverChildBuilderDelegate(
  //                   (context, index) => _buildProductSkeleton(),
  //                   childCount: 6,
  //                 ),
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 2,
  //                   crossAxisSpacing: 5,
  //                   mainAxisSpacing: 5,
  //                   childAspectRatio: 3 / 4.5,
  //                 ),
  //               );
  //             }
  //             return SliverGrid(
  //               delegate: SliverChildBuilderDelegate(
  //                 (context, index) =>
  //                     ProductItem(product: controller.products[index]),
  //                 childCount: controller.products.length,
  //               ),
  //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2,
  //                 crossAxisSpacing: 5,
  //                 mainAxisSpacing: 5,
  //                 childAspectRatio: 3 / 4.5,
  //               ),
  //             );
  //           }),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          child: InkWell(
            splashColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.grey.withOpacity(0.1),

            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 100));
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
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xffEBEBEB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 160,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffEBEBEB), width: 1),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(product.cover, fit: BoxFit.contain),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBoxCustom.h2,
                          Text(
                            product.name,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
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
                                    color: kBrandOrange,
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Đã thêm vào giỏ hàng!',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: kBrandOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 15,
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
        ),
      ),
    );
  }

  Widget _buildProductSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xffEBEBEB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 160,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffEBEBEB), width: 1),
                  ),
                ),
                child: Skeletonizer(
                  enabled: true,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Colors.grey[300],
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 8),
                      Skeletonizer(
                        enabled: true,
                        child: Container(
                          height: 16,
                          width: double.infinity,
                          color: Colors.grey[300],
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
                            Skeletonizer(
                              enabled: true,
                              child: Container(
                                height: 14,
                                width: 60,
                                color: Colors.grey[300],
                              ),
                            ),
                            Skeletonizer(
                              enabled: true,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 15,
                                  color: Colors.transparent,
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
