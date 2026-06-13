import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/core/routes.dart';
import 'package:ecommerce_app/shared/widgets/neon_button.dart';
import 'package:ecommerce_app/shared/widgets/neon_text_field.dart';
import 'package:ecommerce_app/shared/widgets/glassmorphism_card.dart';
import 'package:ecommerce_app/shared/widgets/neon_snackbar.dart';
import 'package:ecommerce_app/shared/widgets/loading_overlay.dart';
import 'package:ecommerce_app/shared/widgets/particle_background.dart';
import 'package:ecommerce_app/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app/features/auth/screens/register_screen.dart';
import 'package:ecommerce_app/features/home/screens/main_screen.dart';

// Cyber-neon themed sign-in screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // Master animation controller for staggered entrance animations.
  late AnimationController _animationController;
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;

  late Animation<double> _buttonOpacity;
  late Animation<Offset> _buttonSlide;

  late Animation<double> _footerOpacity;

  late Animation<double> _emailOpacity;
  late Animation<Offset> _emailSlide;

  late Animation<double> _passwordOpacity;
  late Animation<Offset> _passwordSlide;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _emailOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.15, 0.50, curve: Curves.easeOut),
      ),
    );
    _emailSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.15, 0.50, curve: Curves.easeOut),
      ),
    );

    _passwordOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOut),
      ),
    );
    _passwordSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOut),
      ),
    );

    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
      ),
    );
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
      ),
    );

    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.60, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle form submission and sign-in
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.signIn(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        FadeRoute(page: const MainScreen()),
        (route) => false,
      );
    } else {
      NeonSnackbar.showError(
        context,
        authProvider.error ?? 'Sign in failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.deepBlack,
          body: LoadingOverlay(
            isLoading: authProvider.isLoading,
            message: 'Signing in...',
            child: ParticleBackground(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                  child: SingleChildScrollView(
                    // Ensure form is scrollable on smaller screens
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppSpacing.xxl),

                            const SizedBox(height: AppSpacing.xxl),

                            SlideTransition(
                              position: _headerSlide,
                              child: FadeTransition(
                                opacity: _headerOpacity,
                                child: Column(
                                  children: [
                                    // Neon-glowing app icon in a circular container
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.cyan
                                                .withValues(alpha: 0.4),
                                            blurRadius: 25,
                                            spreadRadius: 3,
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
                                              AppColors.cyan
                                                  .withValues(alpha: 0.2),
                                              AppColors.neonPurple
                                                  .withValues(alpha: 0.2),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: AppColors.cyan
                                                .withValues(alpha: 0.6),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.shopping_bag_rounded,
                                          size: 36,
                                          color: AppColors.cyan,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.lg),

                                    // 'Welcome Back' title with neon glow shadow
                                    Text(
                                      'Welcome Back',
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

                                    // Subtitle text
                                    Text(
                                      'Sign in to continue',
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

                            const SizedBox(height: AppSpacing.xxl),

                            const SizedBox(height: AppSpacing.xxl),

                            GlassmorphismCard(
                              borderColor:
                                  AppColors.cyan.withValues(alpha: 0.3),
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // --- Email Field ---
                                    // Slides up and fades in second in sequence
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
                                          textInputAction:
                                              TextInputAction.next,
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
                                    // Slides up and fades in third in sequence
                                    SlideTransition(
                                      position: _passwordSlide,
                                      child: FadeTransition(
                                        opacity: _passwordOpacity,
                                        child: NeonTextField(
                                          controller: _passwordController,
                                          label: 'Password',
                                          hint: 'Enter your password',
                                          prefixIcon: Icons.lock_outline,
                                          isPassword: true,
                                          textInputAction:
                                              TextInputAction.done,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            if (value.length < 6) {
                                              return 'Password must be at least 6 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.xl),

                                    // --- Sign In Button ---
                                    // Slides up and fades in fourth in sequence
                                    SlideTransition(
                                      position: _buttonSlide,
                                      child: FadeTransition(
                                        opacity: _buttonOpacity,
                                        child: NeonButton(
                                          text: 'SIGN IN',
                                          onPressed: _handleSignIn,
                                          isLoading:
                                              authProvider.isLoading,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            const SizedBox(height: AppSpacing.xl),

                            FadeTransition(
                              opacity: _footerOpacity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to register screen with
                                      // a slide-right page transition
                                      Navigator.push(
                                        context,
                                        SlideRightRoute(
                                          page: const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Create Account',
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
