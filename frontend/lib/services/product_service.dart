import 'package:flutter/foundation.dart';
import '../models/product.dart';
import 'api_service.dart';

class ProductService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;
  String? _selectedStoreId;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> loadProducts({
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool refresh = false,
  }) async {
    if (_selectedStoreId == null) return;
    
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _products = [];
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.getProducts(
        storeId: _selectedStoreId!,
        query: query,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: _currentPage,
      );

      final List<Product> newProducts = (result['products'] as List)
          .map((json) => Product.fromJson(json))
          .toList();

      _products.addAll(newProducts);
      _hasMore = newProducts.length == 20; // assuming page size is 20
      _currentPage++;
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedStore(String storeId) {
    _selectedStoreId = storeId;
    loadProducts(refresh: true);
  }
} 