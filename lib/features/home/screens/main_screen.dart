import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/features/products/screens/home_screen.dart';
import 'package:ecommerce_app/features/favorites/screens/favorites_screen.dart';
import 'package:ecommerce_app/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_app/features/products/screens/categories_screen.dart';

// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // The four main views
  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const CategoriesScreen(),
  ];

  void switchTab(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          border: Border(
            top: BorderSide(
              color: AppColors.electricBlue.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.electricBlue.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedItemColor: AppColors.electricBlue,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Categories',
            ),
          ],
        ),
      ),
    );
  }
}
