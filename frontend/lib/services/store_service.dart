import 'package:flutter/foundation.dart';
import 'package:shared_preferences.dart';
import '../models/store.dart';
import 'api_service.dart';

class StoreService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SharedPreferences? _prefs;
  
  List<Store> _stores = [];
  Store? _selectedStore;
  bool _isLoading = false;
  
  static const String _selectedStoreKey = 'selected_store_id';

  StoreService([this._prefs]);

  List<Store> get stores => _stores;
  Store? get selectedStore => _selectedStore;
  bool get isLoading => _isLoading;

  // Initialize the service and load previously selected store
  Future<void> init() async {
    await loadStores();
    await loadSelectedStore();
  }

  // Load all stores from the API
  Future<void> loadStores() async {
    _isLoading = true;
    notifyListeners();

    try {
      final stores = await _apiService.getStores();
      _stores = stores;
      
      // If we have a stored store ID but no selected store, try to select it
      if (_selectedStore == null && _prefs != null) {
        final storedId = _prefs!.getString(_selectedStoreKey);
        if (storedId != null) {
          final store = _stores.firstWhere(
            (store) => store.id == storedId,
            orElse: () => _stores.first,
          );
          await setSelectedStore(store);
        }
      }
    } catch (e) {
      print('Error loading stores: $e');
      _stores = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load the previously selected store from SharedPreferences
  Future<void> loadSelectedStore() async {
    if (_prefs == null) return;

    final storedId = _prefs!.getString(_selectedStoreKey);
    if (storedId != null && _stores.isNotEmpty) {
      final store = _stores.firstWhere(
        (store) => store.id == storedId,
        orElse: () => _stores.first,
      );
      _selectedStore = store;
      notifyListeners();
    }
  }

  // Set the selected store and save it to SharedPreferences
  Future<void> setSelectedStore(Store store) async {
    _selectedStore = store;
    
    if (_prefs != null) {
      await _prefs!.setString(_selectedStoreKey, store.id);
    }
    
    notifyListeners();
  }

  // Search stores by name or address
  List<Store> searchStores(String query) {
    if (query.isEmpty) return _stores;
    
    final lowercaseQuery = query.toLowerCase();
    return _stores.where((store) {
      return store.name.toLowerCase().contains(lowercaseQuery) ||
          store.address.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get nearest stores based on location (placeholder implementation)
  List<Store> getNearestStores(double latitude, double longitude) {
    // In a real implementation, you would:
    // 1. Calculate distances between user location and store locations
    // 2. Sort stores by distance
    // 3. Return the sorted list
    return _stores;
  }

  // Clear selected store
  Future<void> clearSelectedStore() async {
    _selectedStore = null;
    if (_prefs != null) {
      await _prefs!.remove(_selectedStoreKey);
    }
    notifyListeners();
  }
} 