import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce_app/core/constants.dart';

// Custom text field with neon focus glow
class NeonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const NeonTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  State<NeonTextField> createState() => _NeonTextFieldState();
}

class _NeonTextFieldState extends State<NeonTextField> {
  // Track password visibility state internally
  bool _obscureText = true;

  // Track focus state for neon glow effect
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.fast,
      // Apply neon glow shadow when field is focused
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: _isFocused
            ? AppColors.subtleGlow(AppColors.electricBlue)
            : [],
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() => _isFocused = hasFocus);
        },
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
          cursorColor: AppColors.electricBlue,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            // Prefix icon with neon tint when focused
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _isFocused
                        ? AppColors.electricBlue
                        : AppColors.textMuted,
                    size: 20,
                  )
                : null,
            // Password visibility toggle suffix icon
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _isFocused
                          ? AppColors.electricBlue
                          : AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
