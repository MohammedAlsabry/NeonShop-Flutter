import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/features/products/providers/product_provider.dart';
import 'package:ecommerce_app/features/favorites/providers/favorites_provider.dart';
import 'package:ecommerce_app/features/products/widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Favorites',
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.neonPink,
            shadows: [
              Shadow(
                color: AppColors.neonPink.withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
      body: Consumer2<FavoritesProvider, ProductProvider>(
        builder: (context, favoritesProvider, productProvider, _) {
          final favoriteIds = favoritesProvider.favoriteIds;
          
          if (favoritesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.neonPink),
            );
          }

          if (favoriteIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 80,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'No favorites yet',
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Items you like will appear here',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          // Filter products to only include favorites
          final favoriteProducts = productProvider.products
              .where((p) => favoriteIds.contains(p.id))
              .toList();

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
              return ProductCard(
                product: product,
                isFavorite: true,
              );
            },
          );
        },
      ),
    );
  }
}
