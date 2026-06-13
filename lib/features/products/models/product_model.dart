import 'package:cloud_firestore/cloud_firestore.dart';

/// ============================================
/// PRODUCT MODEL
/// Represents a product document from Firestore
/// Includes serialization methods for Firebase
/// ============================================
class Product {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final String imageUrl;
  final String description;
  final int stock;
  final bool isAvailable;
  final DateTime? createdAt;

  /// Constructor
  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.stock,
    required this.isAvailable,
    this.createdAt,
  });

  /// Factory constructor to create a Product from a Firestore document snapshot.
  factory Product.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      categoryId: data['categoryId'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      stock: data['stock'] ?? 0,
      isAvailable: data['isAvailable'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Converts the Product instance to a Map for storing in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'stock': stock,
      'isAvailable': isAvailable,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
