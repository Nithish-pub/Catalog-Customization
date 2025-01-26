import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:store_catalog/widgets/product_card.dart';
import 'package:store_catalog/models/product.dart';

void main() {
  testWidgets('ProductCard displays product information correctly',
      (WidgetTester tester) async {
    final product = Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      category: 'Electronics',
      stores: [
        StoreProduct(
          storeId: 'store_1',
          price: 100,
          isDeliveryAvailable: true,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(product: product),
        ),
      ),
    );

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('\$100.00'), findsOneWidget);
    expect(find.text('Delivery Available'), findsOneWidget);
  });
} 