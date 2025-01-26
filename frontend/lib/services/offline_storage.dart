import 'package:hive/hive.dart';
import '../models/product.dart';
import '../models/store.dart';

class OfflineStorage {
  static const String productsBox = 'products';
  static const String storesBox = 'stores';

  Future<void> init() async {
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(StoreAdapter());
    await Hive.openBox<Product>(productsBox);
    await Hive.openBox<Store>(storesBox);
  }

  Future<void> cacheProducts(List<Product> products) async {
    final box = Hive.box<Product>(productsBox);
    await box.clear();
    await box.addAll(products);
  }

  Future<List<Product>> getCachedProducts() async {
    final box = Hive.box<Product>(productsBox);
    return box.values.toList();
  }

  // Similar methods for stores...
} 