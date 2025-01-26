import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final String? selectedCategory;
  final RangeValues priceRange;
  final Function(String?) onCategoryChanged;
  final Function(RangeValues) onPriceRangeChanged;
  final Function() onApplyFilters;

  const FilterWidget({
    Key? key,
    this.selectedCategory,
    required this.priceRange,
    required this.onCategoryChanged,
    required this.onPriceRangeChanged,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late String? _selectedCategory;
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _priceRange = widget.priceRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Products',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('All Categories')),
              ...['Electronics', 'Furniture', 'Groceries', 'Clothing']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
            ],
            onChanged: (value) {
              setState(() => _selectedCategory = value);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Price Range',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 20,
            labels: RangeLabels(
              '\$${_priceRange.start.round()}',
              '\$${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() => _priceRange = values);
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onCategoryChanged(_selectedCategory);
                widget.onPriceRangeChanged(_priceRange);
                widget.onApplyFilters();
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
} 