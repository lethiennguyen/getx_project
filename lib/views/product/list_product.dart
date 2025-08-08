import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/getx/controllers/list_poduct_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../base/asset/base_asset.dart';
import '../../data/model/product.dart';
import '../../enums/product_type.dart';
import '../common/app_colors.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductListScreen();
  }
}

class ProductListScreen extends State<ProductList> {
  Category _category = Category.all;
  final currencyFormatter = NumberFormat('#,##0', 'vi_VN');
  final controller = Get.put(ListProductController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: SvgPicture.asset(Pictures.logo, width: 158, height: 37),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/shopping_cart');
              },
              icon: SvgPicture.asset(IconsAssets.shopping_cart),
              tooltip: 'Giỏ hàng',
            ),
            SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(color: Color(0xfffffffe), height: 1),
          ),
        ),
        body: _formProductList(controller.products),
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
          SliverToBoxAdapter(
            child: SizedBox(
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
                        side: BorderSide(
                          color: selected ? kBrandOrange : Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(category.label),
                    ),
                  );
                },
              ),
            ),
          ),
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

  Widget ProductItem({required Product product}) {
    return GestureDetector(
      onTap: () async {
        final result = await Get.toNamed(
          '/thongtinsanpham',
          arguments: product.id,
        );
        print('>>> Kết quả trả về: $result');
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
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
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
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff232323), width: 0.5),
                  ),
                  child: Image.network(
                    product.cover,
                    fit: BoxFit.cover,
                    height: 180,
                  ),
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
                            '${currencyFormatter.format(product.price)} VNĐ',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã thêm vào giỏ hàng!'),
                                ),
                              );
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
    );
  }
}
