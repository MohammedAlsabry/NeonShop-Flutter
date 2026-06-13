import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Map<String, int>> getCart(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) {
      final map = <String, int>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        map[doc.id] = data['quantity'] as int? ?? 1;
      }
      return map;
    });
  }

  Future<void> updateCartQuantity(String userId, String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(userId, productId);
      return;
    }
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .set({
      'productId': productId,
      'quantity': quantity,
      'addedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromCart(String userId, String productId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  Future<void> clearCart(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
