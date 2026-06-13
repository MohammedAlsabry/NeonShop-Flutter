import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/shared/widgets/glassmorphism_card.dart';
import 'package:ecommerce_app/features/products/providers/category_provider.dart';
import 'package:ecommerce_app/features/home/screens/main_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Categories',
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, _) {
          if (categoryProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.cyan),
            );
          }

          if (categoryProvider.error != null) {
            return Center(
              child: Text(
                categoryProvider.error!,
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          final categories = categoryProvider.categories;

          if (categories.isEmpty) {
            return const Center(
              child: Text('No categories found', style: TextStyle(color: AppColors.textSecondary)),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              
              // Map names to specific icons for the cyber neon feel
              IconData iconData = Icons.category_rounded;
              if (category.name.toLowerCase().contains('electronic')) iconData = Icons.electrical_services_rounded;
              else if (category.name.toLowerCase().contains('access')) iconData = Icons.headphones_rounded;
              else if (category.name.toLowerCase().contains('office')) iconData = Icons.chair_rounded;
              else if (category.name.toLowerCase().contains('gaming')) iconData = Icons.sports_esports_rounded;

              return GlassmorphismCard(
                child: InkWell(
                  onTap: () {
                    // Select category and switch to Home tab
                    context.read<CategoryProvider>().setCategory(category.name);
                    context.findAncestorStateOfType<MainScreenState>()?.switchTab(0);
                  },
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconData,
                        size: 48,
                        color: AppColors.electricBlue,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        category.name,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
