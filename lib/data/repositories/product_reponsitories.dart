import 'package:dio/dio.dart';
import 'package:getx_statemanagement/data/core/base_reponsitory.dart';
import 'package:getx_statemanagement/data/core/constants.dart';
import 'package:getx_statemanagement/data/model/product.dart';
import 'package:getx_statemanagement/data/request/product_request.dart';
import 'package:getx_statemanagement/data/dio/dio.dart';

class ProductRepository extends BaseRepository {
  Future<List<Product>> getProductList(ProductListRequest request) async {
    try {
      final response = await ApiClient().dio.get(
        ApiConfig.listProduct,
        queryParameters: request.toQueryParams(),
        options: Options(headers: {'Authorization': token}),
      );
      final apiRes =
          (response.data['data'] as List)
              .map((json) => Product.fromJson(json as Map<String, dynamic>))
              .toList();
      return apiRes;
    } catch (e) {
      return [];
    }
  }
}

class ProductDetailRepository extends BaseRepository {
  Future<Product> getProductDetail(int id) async {
    try {
      final response = await ApiClient().dio.get(
        '${ApiConfig.productDetial}$id',
        options: Options(headers: {'Authorization': token}),
      );
      final apiRes = Product.fromJson(response.data['data']);
      return apiRes;
    } catch (e) {
      // print('DioException: ${e.response?.statusCode}');
      // print('Response body: ${e.response?.data}');
      return Product(id: 0, name: '', price: 0, quantity: 0, cover: '');
    }
  }

  Future<bool> deleteProduct(int id) async {
    final response = await ApiClient().dio.delete(
      '${ApiConfig.productDelete}$id',
      options: Options(headers: {'Authorization': token}),
    );
    return response.statusCode == 200;
  }

  Future<Product?> putProductUpdate(
    int id, {
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    try {
      final response = await ApiClient().dio.put(
        '${ApiConfig.productUpdate}$id',
        data: {
          'name': name,
          'price': price,
          'quantity': quantity,
          'cover': cover,
        },
        options: Options(headers: {'Authorization': token}),
      );
      return Product.fromJson(response.data['data']);
    } catch (e) {
      // print('DioException: ${e.response?.statusCode}');
      // print('Response body: ${e.response?.data}');
    }
    return null;
  }
}

class CreateProductRepository extends BaseRepository {
  Future<Product?> postCreateProdcut({
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    try {
      final response = await ApiClient().dio.post(
        ApiConfig.productCreate,
        data: {
          'name': name,
          'price': price,
          'quantity': quantity,
          'cover': cover,
        },
        options: Options(headers: {'Authorization': token}),
      );
      return Product.fromJson(response.data['data']);
    } catch (e) {
      // print('DioException: ${e.response?.statusCode}');
      // print('Response body: ${e.response?.data}');
    }
    return null;
  }
}
