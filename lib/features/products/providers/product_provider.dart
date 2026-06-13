import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/features/products/models/product_model.dart';
import 'package:ecommerce_app/features/products/services/product_service.dart';

// State management for products
class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  StreamSubscription<List<Product>>? _subscription;

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void init() {
    _subscription?.cancel();

    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = _productService.getProducts().listen(
      (products) {
        _products = products;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
        debugPrint('ProductProvider stream error: $error');
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}
