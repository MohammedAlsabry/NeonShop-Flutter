import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/shared/widgets/neon_button.dart';
import 'package:ecommerce_app/shared/widgets/neon_text_field.dart';
import 'package:ecommerce_app/shared/widgets/glassmorphism_card.dart';
import 'package:ecommerce_app/shared/widgets/neon_snackbar.dart';
import 'package:ecommerce_app/shared/widgets/loading_overlay.dart';
import 'package:ecommerce_app/shared/widgets/particle_background.dart';
import 'package:ecommerce_app/features/auth/providers/auth_provider.dart';

// Cyber-neon themed account creation screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animationController;

  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;

  late Animation<double> _nameOpacity;
  late Animation<Offset> _nameSlide;

  late Animation<double> _emailOpacity;
  late Animation<Offset> _emailSlide;

  late Animation<double> _passwordOpacity;
  late Animation<Offset> _passwordSlide;

  late Animation<double> _confirmOpacity;
  late Animation<Offset> _confirmSlide;

  late Animation<double> _buttonOpacity;
  late Animation<Offset> _buttonSlide;

  late Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );

    // --- Name field animations ---
    _nameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.10, 0.35, curve: Curves.easeOut),
      ),
    );
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.10, 0.35, curve: Curves.easeOut),
      ),
    );

    // --- Email field animations ---
    _emailOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.20, 0.45, curve: Curves.easeOut),
      ),
    );
    _emailSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.20, 0.45, curve: Curves.easeOut),
      ),
    );

    // --- Password field animations ---
    _passwordOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.30, 0.55, curve: Curves.easeOut),
      ),
    );
    _passwordSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.30, 0.55, curve: Curves.easeOut),
      ),
    );

    // --- Confirm password field animations ---
    _confirmOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.40, 0.65, curve: Curves.easeOut),
      ),
    );
    _confirmSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.40, 0.65, curve: Curves.easeOut),
      ),
    );

    // --- Button animations ---
    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.50, 0.75, curve: Curves.easeOut),
      ),
    );
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.50, 0.75, curve: Curves.easeOut),
      ),
    );

    // --- Footer animation ---
    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start the cascading entrance animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Handle account registration
  Future<void> _handleRegister() async {
    // Validate all form fields
    if (!_formKey.currentState!.validate()) return;

    // Access the auth provider
    final authProvider = context.read<AuthProvider>();

    // Attempt registration
    final success = await authProvider.register(
      fullName: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Guard: check if widget is still mounted before using context
    if (!mounted) return;

    if (success) {
      // Show the animated success dialog
      await _showSuccessDialog();
    } else {
      // Show error snackbar
      NeonSnackbar.showError(
        context,
        authProvider.error ?? 'Registration failed. Please try again.',
      );
    }
  }

  // Animated success dialog
  Future<void> _showSuccessDialog() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Success Dialog',
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 400),

      // Custom transition: combined fade + scale for a polished feel
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Scale from 80% to 100% with elastic overshoot
        final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
        );

        // Fade from transparent to opaque
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },

      // Dialog content
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: GlassmorphismCard(
                borderColor: AppColors.cyan.withValues(alpha: 0.4),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // =========================================================
                    // SUCCESS ICON
                    // Large check icon with neon glow effect
                    // =========================================================
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Neon glow shadows
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.5),
                            blurRadius: 25,
                            spreadRadius: 3,
                          ),
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.2),
                            blurRadius: 50,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.cyan.withValues(alpha: 0.3),
                              AppColors.neonPurple.withValues(alpha: 0.3),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.cyan.withValues(alpha: 0.7),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 44,
                          color: AppColors.cyan,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // =========================================================
                    // SUCCESS TITLE
                    // =========================================================
                    Text(
                      'Account Created!',
                      style: GoogleFonts.orbitron(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: AppColors.cyan.withValues(alpha: 0.5),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // =========================================================
                    // SUCCESS MESSAGE
                    // =========================================================
                    Text(
                      'Welcome aboard! Your account has been\nsuccessfully created.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // =========================================================
                    // CONTINUE BUTTON
                    // Pops the dialog, then pops back to LoginScreen
                    // =========================================================
                    NeonButton(
                      text: 'CONTINUE TO LOGIN',
                      onPressed: () {
                        // Close the dialog
                        Navigator.pop(context);
                        // Pop back to LoginScreen
                        Navigator.pop(context);
                      },
                      isLoading: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.deepBlack,
          body: LoadingOverlay(
            // Show loading overlay when registration is in progress
            isLoading: authProvider.isLoading,
            message: 'Creating account...',
            child: ParticleBackground(
              child: GestureDetector(
                // Dismiss keyboard when tapping outside form fields
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                  child: SingleChildScrollView(
                    // Ensure form is scrollable on smaller screens / keyboards
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: _AnimatedFormBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppSpacing.xl),

                            SlideTransition(
                              position: _headerSlide,
                              child: FadeTransition(
                                opacity: _headerOpacity,
                                child: Column(
                                  children: [
                                    // 'Create Account' title
                                    Text(
                                      'Create Account',
                                      style: GoogleFonts.orbitron(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: AppColors.cyan
                                                .withValues(alpha: 0.5),
                                            blurRadius: 15,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.xs),

                                    // Subtitle
                                    Text(
                                      'Join the future of shopping',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.white54,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            GlassmorphismCard(
                              borderColor:
                                  AppColors.cyan.withValues(alpha: 0.3),
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // --- Full Name Field ---
                                    SlideTransition(
                                      position: _nameSlide,
                                      child: FadeTransition(
                                        opacity: _nameOpacity,
                                        child: NeonTextField(
                                          controller: _nameController,
                                          label: 'Full Name',
                                          hint: 'Enter your full name',
                                          prefixIcon: Icons.person_outline,
                                          textInputAction: TextInputAction.next,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please enter your full name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.md),

                                    // --- Email Field ---
                                    SlideTransition(
                                      position: _emailSlide,
                                      child: FadeTransition(
                                        opacity: _emailOpacity,
                                        child: NeonTextField(
                                          controller: _emailController,
                                          label: 'Email',
                                          hint: 'Enter your email',
                                          prefixIcon: Icons.email_outlined,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            if (!value.contains('@')) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.md),

                                    // --- Password Field ---
                                    SlideTransition(
                                      position: _passwordSlide,
                                      child: FadeTransition(
                                        opacity: _passwordOpacity,
                                        child: NeonTextField(
                                          controller: _passwordController,
                                          label: 'Password',
                                          hint: 'Create a password',
                                          prefixIcon: Icons.lock_outline,
                                          isPassword: true,
                                          textInputAction: TextInputAction.next,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please enter a password';
                                            }
                                            if (value.length < 6) {
                                              return 'Password must be at least 6 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.md),

                                    // --- Confirm Password Field ---
                                    SlideTransition(
                                      position: _confirmSlide,
                                      child: FadeTransition(
                                        opacity: _confirmOpacity,
                                        child: NeonTextField(
                                          controller:
                                              _confirmPasswordController,
                                          label: 'Confirm Password',
                                          hint: 'Re-enter your password',
                                          prefixIcon: Icons.lock_outline,
                                          isPassword: true,
                                          textInputAction: TextInputAction.done,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please confirm your password';
                                            }
                                            if (value !=
                                                _passwordController.text) {
                                              return 'Passwords do not match';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.xl),

                                    // --- Create Account Button ---
                                    SlideTransition(
                                      position: _buttonSlide,
                                      child: FadeTransition(
                                        opacity: _buttonOpacity,
                                        child: NeonButton(
                                          text: 'CREATE ACCOUNT',
                                          onPressed: _handleRegister,
                                          isLoading: authProvider.isLoading,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            FadeTransition(
                              opacity: _footerOpacity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Pop back to the login screen
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Sign In',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.cyan,
                                        shadows: [
                                          Shadow(
                                            color: AppColors.cyan
                                                .withValues(alpha: 0.5),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xxl),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A helper widget that rebuilds whenever the provided [Listenable] changes.
///
/// This is used to wrap the entire form column so it rebuilds when the
/// animation controller ticks, driving all staggered animations together.
class _AnimatedFormBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const _AnimatedFormBuilder({
    required Listenable animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
