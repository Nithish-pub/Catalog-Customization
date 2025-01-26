import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductComparisonScreen extends StatelessWidget {
  final List<Product> products;

  const ProductComparisonScreen({Key? key, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Products'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Features')),
            DataColumn(label: Text('Product 1')),
            DataColumn(label: Text('Product 2')),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('Name')),
              DataCell(Text(products[0].name)),
              DataCell(Text(products[1].name)),
            ]),
            DataRow(cells: [
              const DataCell(Text('Price')),
              DataCell(Text('\$${products[0].stores.first.price}')),
              DataCell(Text('\$${products[1].stores.first.price}')),
            ]),
            DataRow(cells: [
              const DataCell(Text('Category')),
              DataCell(Text(products[0].category)),
              DataCell(Text(products[1].category)),
            ]),
            DataRow(cells: [
              const DataCell(Text('Delivery')),
              DataCell(Text(products[0].stores.first.isDeliveryAvailable
                  ? 'Available'
                  : 'Not Available')),
              DataCell(Text(products[1].stores.first.isDeliveryAvailable
                  ? 'Available'
                  : 'Not Available')),
            ]),
          ],
        ),
      ),
    );
  }
} 