class ComparisonService extends ChangeNotifier {
  final List<Product> _comparedProducts = [];
  final int maxComparisons = 4;

  List<Product> get comparedProducts => _comparedProducts;

  void addToComparison(Product product) {
    if (_comparedProducts.length < maxComparisons) {
      _comparedProducts.add(product);
      notifyListeners();
    }
  }

  void removeFromComparison(Product product) {
    _comparedProducts.remove(product);
    notifyListeners();
  }

  void clearComparison() {
    _comparedProducts.clear();
    notifyListeners();
  }
} 