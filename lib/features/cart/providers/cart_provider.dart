import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/cart/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  StreamSubscription<Map<String, int>>? _subscription;

  String? _userId;
  Map<String, int> _items = {};
  bool _isLoading = false;
  String? _error;

  Map<String, int> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.values.fold(0, (sum, count) => sum + count);

  void init(String userId) {
    _userId = userId;
    _subscription?.cancel();
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription = _cartService.getCart(userId).listen(
      (items) {
        _items = items;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addToCart(String productId) async {
    if (_userId == null) return;
    final currentQty = _items[productId] ?? 0;
    
    // Optimistic update
    _items[productId] = currentQty + 1;
    notifyListeners();
    
    try {
      await _cartService.updateCartQuantity(_userId!, productId, currentQty + 1);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String productId) async {
    if (_userId == null) return;
    final currentQty = _items[productId] ?? 0;
    if (currentQty <= 0) return;

    // Optimistic update
    if (currentQty > 1) {
      _items[productId] = currentQty - 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    
    try {
      if (currentQty > 1) {
        await _cartService.updateCartQuantity(_userId!, productId, currentQty - 1);
      } else {
        await _cartService.removeFromCart(_userId!, productId);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> removeCompletely(String productId) async {
    if (_userId == null) return;
    
    // Optimistic update
    _items.remove(productId);
    notifyListeners();
    
    try {
      await _cartService.removeFromCart(_userId!, productId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    if (_userId == null) return;
    
    // Optimistic update
    _items.clear();
    notifyListeners();
    
    try {
      await _cartService.clearCart(_userId!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearLocalState() {
    _subscription?.cancel();
    _userId = null;
    _items.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
