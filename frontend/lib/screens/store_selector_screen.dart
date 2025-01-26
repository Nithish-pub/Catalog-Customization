import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_catalog/screens/product_listing_screen.dart';
import 'package:store_catalog/services/store_service.dart';

class StoreSelectorScreen extends StatelessWidget {
  const StoreSelectorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Store'),
      ),
      body: Consumer<StoreService>(
        builder: (context, storeService, _) {
          if (storeService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              // Search bar for store filtering
              Padding(
                padding: EdgeInsets.all(16),
                child: SearchBar(
                  onChanged: storeService.filterStores,
                ),
              ),
              // Store list with location info
              Expanded(
                child: ListView.builder(
                  itemCount: storeService.filteredStores.length,
                  itemBuilder: (context, index) {
                    final store = storeService.filteredStores[index];
                    return StoreListTile(
                      store: store,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductListingScreen(store: store),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 