import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<StoreProduct> stores;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.stores,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class StoreProduct {
  final String storeId;
  final double price;
  final bool isDeliveryAvailable;

  StoreProduct({
    required this.storeId,
    required this.price,
    required this.isDeliveryAvailable,
  });

  factory StoreProduct.fromJson(Map<String, dynamic> json) => _$StoreProductFromJson(json);
  Map<String, dynamic> toJson() => _$StoreProductToJson(this);
} 