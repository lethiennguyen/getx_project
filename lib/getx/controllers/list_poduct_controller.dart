import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/data/dio/dio.dart';
import 'package:getx_statemanagement/data/model/product.dart';
import 'package:getx_statemanagement/data/repositories/product_reponsitories.dart';
import 'package:getx_statemanagement/data/request/product_request.dart';

class ListProductController extends GetxController {
  var isLoading = true.obs;
  var isPullToRefresh = false.obs;
  var isLoadingMore = false.obs;
  final page = 1.obs;
  final size = 10.obs;

  final listProdcut = ProductRepository(dio);
  final scroll = ScrollController();
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFistPage();
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

  Future<void> loadFistPage() async {
    try {
      isLoading.value = true;
      final request = ProductListRequest(page: page.value, size: size.value);
      final result = await listProdcut.getProductList(request);
      products.value = result;
    } on Exception catch (e) {
      print('Lỗi refresh: $e');
    }
  }

  Future<void> refreshPage() async {
    try {
      isPullToRefresh.value = true;
      page.value = 1;
      final request = ProductListRequest(page: page.value, size: size.value);
      final result = await listProdcut.getProductList(request);
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
      ++page.value;
      final request = ProductListRequest(page: page.value, size: size.value);
      final result = await listProdcut.getProductList(request);
      products.addAll(result);
    } catch (e) {
      print('Lỗi loadMore: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }
}
