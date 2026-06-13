import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/features/favorites/services/favorites_service.dart';

// State management for user favorites
class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();

  StreamSubscription<List<String>>? _subscription;

  Set<String> _favoriteIds = {};
  bool _isLoading = false;

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  // Subscribe to real-time favorites stream
  Future<void> init(String userId) async {
    _subscription?.cancel();

    _isLoading = true;
    notifyListeners();

    _subscription = _favoritesService.getFavorites(userId).listen(
      (favoriteIds) {
        _favoriteIds = favoriteIds.toSet();
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        notifyListeners();
        debugPrint('FavoritesProvider stream error: $error');
      },
    );
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String userId, String productId) async {
    try {
      if (isFavorite(productId)) {
        _favoriteIds = Set<String>.from(_favoriteIds)..remove(productId);
        notifyListeners();
        await _favoritesService.removeFavorite(userId, productId);
      } else {
        _favoriteIds = Set<String>.from(_favoriteIds)..add(productId);
        notifyListeners();
        await _favoritesService.addFavorite(userId, productId);
      }
    } catch (e) {
      debugPrint('FavoritesProvider toggleFavorite error: $e');
    }
  }

  void clearLocalState() {
    _subscription?.cancel();
    _favoriteIds.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}
