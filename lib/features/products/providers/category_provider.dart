import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/features/products/models/category_model.dart';
import 'package:ecommerce_app/features/products/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  StreamSubscription<List<CategoryModel>>? _subscription;

  List<CategoryModel> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void init() {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = _categoryService.getCategories().listen(
      (categories) {
        _categories = categories;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
        debugPrint('CategoryProvider stream error: $error');
      },
    );
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}
