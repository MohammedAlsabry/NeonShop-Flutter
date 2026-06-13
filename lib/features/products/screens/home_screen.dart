import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/features/products/providers/product_provider.dart';
import 'package:ecommerce_app/features/products/widgets/product_card.dart';
import 'package:ecommerce_app/features/favorites/providers/favorites_provider.dart';
import 'package:ecommerce_app/features/products/providers/category_provider.dart';
import 'package:ecommerce_app/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app/features/auth/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });
  }

  void _initializeProviders() {
    context.read<ProductProvider>().init();
    context.read<CategoryProvider>().init();
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.uid;
    if (userId != null) {
      context.read<FavoritesProvider>().init(userId);
      context.read<CartProvider>().init(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildCategories(),
            Expanded(
              child: Consumer3<ProductProvider, FavoritesProvider, CategoryProvider>(
                builder: (context, productProvider, favoritesProvider, categoryProvider, _) {
                  if (productProvider.isLoading || categoryProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.cyan),
                    );
                  }

                  if (productProvider.error != null) {
                    return Center(
                      child: Text(
                        productProvider.error!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }

                  if (productProvider.products.isEmpty) {
                    return const Center(
                      child: Text('No products available', style: TextStyle(color: AppColors.textSecondary)),
                    );
                  }

                  // Find selected category ID
                  String? selectedCatId;
                  if (categoryProvider.selectedCategory != 'All') {
                    final cats = categoryProvider.categories;
                    try {
                      selectedCatId = cats.firstWhere((c) => c.name == categoryProvider.selectedCategory).id;
                    } catch (e) {
                      selectedCatId = null;
                    }
                  }

                  // Filter products based on selected category ID
                  final filteredProducts = selectedCatId == null
                      ? productProvider.products
                      : productProvider.products.where((p) => p.categoryId == selectedCatId).toList();

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductProvider>().init();
                      context.read<CategoryProvider>().init();
                    },
                    color: AppColors.cyan,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65, // Adjust this to match the reference image card height
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          isFavorite: favoritesProvider.isFavorite(product.id),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Shop',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Browse our collection',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Elegant Logout Button
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neonPink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: AppColors.neonPink.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonPink.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      color: AppColors.neonPink,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.logout_rounded,
                    color: AppColors.neonPink,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stylish Logout Dialog
  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Logout',
      barrierColor: Colors.black54,
      transitionDuration: AppDurations.normal,
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.neonPink.withValues(alpha: 0.5)),
                boxShadow: AppColors.neonGlow(AppColors.neonPink, intensity: 0.3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.logout_rounded, color: AppColors.neonPink, size: 48),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Sign Out',
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Are you sure you want to exit?',
                    style: GoogleFonts.inter(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.textSecondary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neonPink,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Logout', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      context.read<CartProvider>().clearLocalState();
      context.read<FavoritesProvider>().clearLocalState();
      await context.read<AuthProvider>().signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  Widget _buildCategories() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        if (categoryProvider.isLoading) {
          return const SizedBox(height: 60);
        }
        
        final cats = categoryProvider.categories.map((c) => c.name).toList();
        final categories = ['All', ...cats];
        
        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = categoryProvider.selectedCategory == category;

              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () {
                    categoryProvider.setCategory(category);
                  },
                  child: AnimatedContainer(
                    duration: AppDurations.fast,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.cyan : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isSelected ? AppColors.cyan : AppColors.textSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
