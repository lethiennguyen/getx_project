import 'package:dio/dio.dart';
import 'package:getx_statemanagement/constans/hive_constants.dart';
import 'package:getx_statemanagement/data/core/base_reponsitory.dart';
import 'package:getx_statemanagement/data/core/constants.dart';
import 'package:getx_statemanagement/data/model/product.dart';
import 'package:getx_statemanagement/data/request/product_request.dart';
import 'package:getx_statemanagement/data/response/product_respone.dart';
import 'package:getx_statemanagement/data/dio/dio.dart';
import 'package:hive/hive.dart';

class ProductRepository extends BaseRepository {
  ProductRepository(dio);

  Future<List<Product>> getProductList(ProductListRequest request) async {
    try {
      final response = await dio.get(
        ApiConfig.listProduct,
        queryParameters: request.toQueryParams(),
        options: Options(headers: {'Authorization': token}),
      );
      final apiResponse = ApiListResponse<Product>.fromJson(
        response.data,
        (json) => Product.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data;
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode}');
      print('Response body: ${e.response?.data}');
      rethrow;
    }
  }
}

class ProductDetailRepository extends BaseRepository {
  ProductDetailRepository(dio);

  Future<Product> getProductDetail(int id) async {
    try {
      final response = await dio.get(
        '${ApiConfig.productDetial}${id}',
        options: Options(headers: {'Authorization': token}),
      );
      final apiRes = ApiSingleResponse<Product>.fromJson(
        response.data,
        (json) => Product.fromJson(json as Map<String, dynamic>),
      );
      return apiRes.data;
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode}');
      print('Response body: ${e.response?.data}');
      rethrow;
    }
  }

  Future<bool> deleteProduct(int id) async {
    final response = await dio.delete(
      '${ApiConfig.productDelete}${id}',
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
      final response = await dio.put(
        '${ApiConfig.productUpdate}${id}',
        data: {
          'name': name,
          'price': price,
          'quantity': quantity,
          'cover': cover,
        },
        options: Options(headers: {'Authorization': token}),
      );
      return Product.fromJson(response.data['data']);
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode}');
      print('Response body: ${e.response?.data}');
      rethrow;
    }
  }
}

class CreateProductRepository extends BaseRepository {
  CreateProductRepository(dio);

  Future<Product?> postCreateProdcut({
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConfig.productCreate}',
        data: {
          'name': name,
          'price': price,
          'quantity': quantity,
          'cover': cover,
        },
        options: Options(headers: {'Authorization': token}),
      );
      return Product.fromJson(response.data['data']);
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode}');
      print('Response body: ${e.response?.data}');
      rethrow;
    }
  }
}
