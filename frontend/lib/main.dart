import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_catalog/screens/store_selector_screen.dart';
import 'package:store_catalog/services/store_service.dart';
import 'package:store_catalog/services/product_service.dart';
import 'package:shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final storeService = StoreService(prefs);
  await storeService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: storeService),
        ChangeNotifierProvider(create: (_) => ProductService()),
      ],
      child: const StoreCatalogApp(),
    ),
  );
}

class StoreCatalogApp extends StatelessWidget {
  const StoreCatalogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StoreSelectorScreen(),
    );
  }
} 