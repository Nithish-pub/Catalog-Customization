import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/store_service.dart';
import '../models/store.dart';

class StoreSelectorWidget extends StatefulWidget {
  const StoreSelectorWidget({Key? key}) : super(key: key);

  @override
  _StoreSelectorWidgetState createState() => _StoreSelectorWidgetState();
}

class _StoreSelectorWidgetState extends State<StoreSelectorWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Store> _filteredStores = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final storeService = context.read<StoreService>();
    setState(() {
      _filteredStores = storeService.searchStores(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreService>(
      builder: (context, storeService, child) {
        if (storeService.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final stores = _searchController.text.isEmpty
            ? storeService.stores
            : _filteredStores;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Stores',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  final isSelected = store.id == storeService.selectedStore?.id;

                  return ListTile(
                    title: Text(store.name),
                    subtitle: Text(store.address),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    selected: isSelected,
                    onTap: () async {
                      await storeService.setSelectedStore(store);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
} 