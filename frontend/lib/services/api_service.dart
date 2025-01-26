import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/store.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000/api',
  ));

  Future<List<Store>> getStores() async {
    final response = await _dio.get('/stores');
    return (response.data as List)
        .map((json) => Store.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> getProducts({
    required String storeId,
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get('/products/search', queryParameters: {
      'storeId': storeId,
      if (query != null) 'query': query,
      if (category != null) 'category': category,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      'page': page,
      'limit': limit,
    });
    return response.data;
  }

  Future<Product> getProductDetails(String productId, String storeId) async {
    final response = await _dio.get('/products/$productId/store/$storeId');
    return Product.fromJson(response.data);
  }
} 