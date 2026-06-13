import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/features/products/models/product_model.dart';
import 'package:ecommerce_app/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app/features/favorites/providers/favorites_provider.dart';
import 'package:ecommerce_app/features/auth/providers/auth_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (product.imageUrl.isEmpty)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.cardBackground,
                            AppColors.electricBlue.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.cyan,
                          size: 40,
                        ),
                      ),
                    )
                  else
                    Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.cardBackground,
                              AppColors.electricBlue.withValues(alpha: 0.2),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColors.cyan,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  // Glassmorphism effect overlay slightly if needed, but standard is clean
                ],
              ),
            ),
          ),
          
          // Content
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Title
                  Text(
                    product.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),

                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.cyan,
                    ),
                  ),

                  const Spacer(),

                  // Bottom Row: Heart and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Heart button
                      GestureDetector(
                        onTap: () {
                          final userId = context.read<AuthProvider>().user?.uid;
                          if (userId != null) {
                            context.read<FavoritesProvider>().toggleFavorite(userId, product.id);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? AppColors.error : AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),

                      // Add to Cart button
                      GestureDetector(
                        onTap: () {
                          context.read<CartProvider>().addToCart(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              backgroundColor: AppColors.cyan,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cyan,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.shopping_cart_outlined, color: AppColors.deepBlack, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Add',
                                style: GoogleFonts.inter(
                                  color: AppColors.deepBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
