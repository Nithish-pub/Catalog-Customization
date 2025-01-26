import 'package:flutter/foundation.dart';
import '../models/product.dart';
import 'api_service.dart';

class AvailabilityService extends ChangeNotifier {
  final ApiService _apiService;
  final Map<String, ProductAvailability> _availabilityCache = {};

  AvailabilityService(this._apiService);

  Future<ProductAvailability> checkAvailability(
    String productId,
    String storeId,
  ) async {
    final cacheKey = '$productId-$storeId';
    if (_availabilityCache.containsKey(cacheKey)) {
      return _availabilityCache[cacheKey]!;
    }

    try {
      final response = await _apiService.checkProductAvailability(
        productId,
        storeId,
      );
      
      final availability = ProductAvailability.fromJson(response);
      _availabilityCache[cacheKey] = availability;
      
      return availability;
    } catch (e) {
      print('Error checking availability: $e');
      rethrow;
    }
  }

  void clearCache() {
    _availabilityCache.clear();
    notifyListeners();
  }
}

class ProductAvailability {
  final bool isAvailable;
  final int stockLevel;
  final DateTime? nextRestockDate;
  final bool isDiscontinued;
  final String? alternativeProductId;

  ProductAvailability({
    required this.isAvailable,
    required this.stockLevel,
    this.nextRestockDate,
    this.isDiscontinued = false,
    this.alternativeProductId,
  });

  factory ProductAvailability.fromJson(Map<String, dynamic> json) {
    return ProductAvailability(
      isAvailable: json['isAvailable'] as bool,
      stockLevel: json['stockLevel'] as int,
      nextRestockDate: json['nextRestockDate'] != null
          ? DateTime.parse(json['nextRestockDate'] as String)
          : null,
      isDiscontinued: json['isDiscontinued'] as bool? ?? false,
      alternativeProductId: json['alternativeProductId'] as String?,
    );
  }
} 