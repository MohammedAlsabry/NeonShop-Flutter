import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce_app/core/constants.dart';

// Gradient button with neon glow effect
class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final LinearGradient? gradient;
  final IconData? icon;

  const NeonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the button should be in a disabled state
    final bool isDisabled = isLoading || onPressed == null;
    final effectiveGradient = gradient ?? AppColors.buttonGradient;

    return AnimatedOpacity(
      duration: AppDurations.fast,
      opacity: isDisabled ? 0.6 : 1.0,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: effectiveGradient,
          // Neon glow shadow effect around the button
          boxShadow: isDisabled
              ? []
              : AppColors.neonGlow(AppColors.electricBlue, intensity: 0.4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            splashColor: Colors.white.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          text,
                          style: GoogleFonts.orbitron(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
