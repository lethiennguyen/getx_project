import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/data/dio/dio.dart';
import 'package:getx_statemanagement/data/model/product.dart';
import 'package:getx_statemanagement/data/repositories/product_reponsitories.dart';
import 'package:getx_statemanagement/data/request/product_request.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../constans/hive_constants.dart';
import '../../constans/shopping_cart/hive_shopping_cart.dart';

class ListProductController extends GetxController {
  var isLoading = true.obs;
  var isPullToRefresh = false.obs;
  var isLoadingMore = false.obs;
  final page = 1.obs;
  final size = 10.obs;

  //final listProduct = ProductRepository(dio);
  final listProduct = ProductRepository();

  final scroll = ScrollController();
  var products = <Product>[].obs;

  late final Box<CartItem> _box;

  final RxList<CartItem> items = <CartItem>[].obs;

  final currencyFormatter = NumberFormat('#,##0', 'vi_VN');

  @override
  void onInit() {
    super.onInit();
    loadFistPage();
    _box = Hive.box<CartItem>(HiveBoxNames.cartbox);
    scroll.addListener(() {
      if (scroll.position.pixels >= scroll.position.maxScrollExtent - 100) {
        loadMorePage();
      }
    });
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  Future<void> addItem(CartItem item) async {
    await _box.add(item);
    items.add(item);
  }

  Future<void> loadFistPage() async {
    try {
      isLoading.value = true;
      final request = ProductListRequest(page: page.value, size: size.value);
      final result = await listProduct.getProductList(request);
      products.value = result;
    } on Exception catch (e) {
      print('Lỗi refresh: $e');
    } finally {
      await Future.delayed(const Duration(milliseconds: 1000));
      isLoading.value = false;
    }
  }

  Future<void> refreshPage() async {
    try {
      isPullToRefresh.value = true;
      page.value = 1;
      final request = ProductListRequest(page: page.value, size: size.value);
      final result = await listProduct.getProductList(request);
      products.value = result;
    } catch (e) {
      print('Lỗi refresh: $e');
    } finally {
      isPullToRefresh.value = false;
    }
  }

  Future<void> loadMorePage() async {
    if (isLoadingMore.value) return;
    try {
      isLoadingMore.value = true;
      final request = ProductListRequest(
        page: page.value+ 1,
        size: size.value,
      );
      final result = await listProduct.getProductList(request);
      products.addAll(result);
    } catch (e) {
      print('Lỗi loadMore: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  String formatPrice(num price) {
    String formatted = currencyFormatter.format(price);

    String onlyDigits = formatted.replaceAll(RegExp(r'\D'), '');
    if (onlyDigits.length > 9) {
      return '${formatted.substring(0, 9)}... VNĐ';
    }

    return '$formatted VNĐ';
  }
}
