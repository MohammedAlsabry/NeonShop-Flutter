import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:ecommerce_app/core/theme.dart';
import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app/features/products/providers/product_provider.dart';
import 'package:ecommerce_app/features/favorites/providers/favorites_provider.dart';
import 'package:ecommerce_app/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app/features/products/providers/category_provider.dart';
import 'package:ecommerce_app/features/auth/screens/splash_screen.dart';

// Main application entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.deepBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const NeonShopApp());
}

// Root application widget
class NeonShopApp extends StatelessWidget {
  const NeonShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        builder: (context, child) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child,
          );
        },
      ),
    );
  }
}
