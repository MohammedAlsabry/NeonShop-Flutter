import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/constants.dart';

// Frosted glass card with neon border glow
class GlassmorphismCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassmorphismCard({
    super.key,
    required this.child,
    this.borderColor = AppColors.electricBlue,
    this.borderWidth = 0.5,
    this.borderRadius = AppRadius.lg,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      // Outer glow shadow for the neon border effect
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppColors.subtleGlow(borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        // Backdrop blur creates the frosted glass effect
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              // Semi-transparent dark background
              color: AppColors.cardBackground.withValues(alpha: opacity + 0.6),
              borderRadius: BorderRadius.circular(borderRadius),
              // Neon border with low opacity for subtlety
              border: Border.all(
                color: borderColor.withValues(alpha: 0.3),
                width: borderWidth,
              ),
              // Gradient overlay for depth
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.05),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
