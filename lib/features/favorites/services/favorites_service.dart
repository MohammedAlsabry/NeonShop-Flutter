import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/constants.dart';

// Favorites service for Firestore
class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _favoritesRef(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.favoritesCollection);
  }

  // Stream user's favorite product IDs
  Stream<List<String>> getFavorites(String userId) {
    return _favoritesRef(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc['productId'] as String).toList();
    });
  }

  // Add favorite
  Future<void> addFavorite(String userId, String productId) async {
    await _favoritesRef(userId).doc(productId).set({
      'productId': productId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove favorite
  Future<void> removeFavorite(String userId, String productId) async {
    await _favoritesRef(userId).doc(productId).delete();
  }
}
