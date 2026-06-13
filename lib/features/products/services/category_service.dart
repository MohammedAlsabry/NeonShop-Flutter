import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/features/products/models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection('categories')
        .orderBy('id')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc))
            .toList());
  }
}
