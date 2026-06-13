import 'package:flutter/material.dart';

// Central configuration for the Cyber Neon app
class AppConstants {
  static const String appName = 'NeonShop';
  static const String appVersion = '1.0.0';

  static const String productsCollection = 'products';
  static const String usersCollection = 'users';
  static const String favoritesCollection = 'favorites';
}

// Cyber Neon futuristic color palette
class AppColors {
  static const Color electricBlue = Color(0xFF00D4FF);
  static const Color neonPurple = Color(0xFFA855F7);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color neonPink = Color(0xFFFF006E);
  static const Color neonGreen = Color(0xFF39FF14);

  static const Color deepBlack = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF12121A);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color cardBackgroundLight = Color(0xFF16213E);

  static const Color textPrimary = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [electricBlue, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF7C3AED), Color(0xFFA855F7)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0x2000D4FF),
      Color(0x10A855F7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Generate neon glow box shadows for a given color
  static List<BoxShadow> neonGlow(Color color, {double intensity = 0.6}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity * 0.4),
        blurRadius: 12,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: color.withValues(alpha: intensity * 0.2),
        blurRadius: 24,
        spreadRadius: 2,
      ),
    ];
  }

  // Generate subtle glow box shadows
  static List<BoxShadow> subtleGlow(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.15),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    ];
  }
}

// Consistent spacing throughout the app
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
}

// Border radius constants
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 100.0;
}

// Animation duration constants
class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration splash = Duration(milliseconds: 2500);
}
