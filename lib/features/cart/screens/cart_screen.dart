import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/features/products/providers/product_provider.dart';
import 'package:ecommerce_app/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app/shared/widgets/neon_button.dart';
import 'package:ecommerce_app/shared/widgets/glassmorphism_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.cyan,
            shadows: [
              Shadow(
                color: AppColors.cyan.withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
      body: Consumer2<CartProvider, ProductProvider>(
        builder: (context, cartProvider, productProvider, _) {
          final items = cartProvider.items;
          
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Your cart is empty',
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  NeonButton(
                    text: 'START SHOPPING',
                    onPressed: () {
                      // We can just rely on bottom nav for this
                    },
                  ),
                ],
              ),
            );
          }

          // Calculate total
          double total = 0;
          final cartProducts = items.entries.map((entry) {
            final product = productProvider.products.firstWhere(
              (p) => p.id == entry.key,
            );
            total += product.price * entry.value;
            return {'product': product, 'quantity': entry.value};
          }).toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    final item = cartProducts[index];
                    final product = item['product'] as dynamic;
                    final quantity = item['quantity'] as int;

                    return GlassmorphismCard(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Row(
                        children: [
                          if (product.imageUrl.isEmpty)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.cyan.withValues(alpha: 0.2),
                                    AppColors.neonPurple.withValues(alpha: 0.2),
                                  ],
                                ),
                                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5)),
                              ),
                              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.cyan, size: 32),
                            )
                          else
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              child: Image.network(
                                product.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.cyan.withValues(alpha: 0.2),
                                        AppColors.neonPurple.withValues(alpha: 0.2),
                                      ],
                                    ),
                                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5)),
                                  ),
                                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.cyan, size: 32),
                                ),
                              ),
                            ),
                          const SizedBox(width: AppSpacing.md),
                          
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.cyan,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Quantity Controls
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: AppColors.textSecondary),
                                onPressed: () => cartProvider.removeFromCart(product.id),
                              ),
                              Text(
                                '$quantity',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: AppColors.cyan),
                                onPressed: () => cartProvider.addToCart(product.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Checkout Bar
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundLight,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                  boxShadow: AppColors.neonGlow(AppColors.electricBlue, intensity: 0.2),
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      NeonButton(
                        text: 'CHECKOUT',
                        onPressed: () {
                          // Implement checkout logic
                          cartProvider.clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Checkout successful!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
