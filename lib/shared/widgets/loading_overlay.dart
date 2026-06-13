import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/constants.dart';

// Full-screen loading overlay
class LoadingOverlay extends StatelessWidget {
  /// Whether the loading overlay is visible
  final bool isLoading;

  /// The child widget to display behind the overlay
  final Widget child;

  /// Optional message to display below the spinner
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content always visible
        child,

        // Overlay shown only when loading
        if (isLoading)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: AppColors.deepBlack.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Neon-styled circular progress indicator
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.electricBlue,
                          ),
                          backgroundColor:
                              AppColors.neonPurple.withValues(alpha: 0.2),
                        ),
                      ),
                      // Optional loading message
                      if (message != null) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          message!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
