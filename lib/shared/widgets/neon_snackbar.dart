import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/constants.dart';

// Styled snackbars for notifications
class NeonSnackbar {
  /// Show a success snackbar with green accent
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.success, Icons.check_circle_outline);
  }

  /// Show an error snackbar with red accent
  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.error, Icons.error_outline);
  }

  /// Show an info snackbar with blue accent
  static void showInfo(BuildContext context, String message) {
    _show(context, message, AppColors.electricBlue, Icons.info_outline);
  }

  /// Show a warning snackbar with amber accent
  static void showWarning(BuildContext context, String message) {
    _show(context, message, AppColors.warning, Icons.warning_amber_outlined);
  }

  /// Internal method that builds and displays the snackbar
  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    // Clear any existing snackbars to prevent stacking
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: color.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        margin: const EdgeInsets.all(AppSpacing.lg),
        elevation: 8,
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
