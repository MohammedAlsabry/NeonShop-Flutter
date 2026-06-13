import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/features/products/models/product_model.dart';

// Firebase operations for products
class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _productsRef =>
      _firestore.collection(AppConstants.productsCollection);

  // Stream all products
  Stream<List<Product>> getProducts() {
    return _productsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromDoc(doc)).toList();
    });
  }

}
