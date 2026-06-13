import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecommerce_app/core/constants.dart';
import 'package:ecommerce_app/core/routes.dart';
import 'package:ecommerce_app/shared/widgets/particle_background.dart';
import 'package:ecommerce_app/features/auth/screens/login_screen.dart';
import 'package:ecommerce_app/features/home/screens/main_screen.dart';

// Animated loading screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _shimmerController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _pulseAnimation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _shimmerPosition;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // =========================================================================
    // PULSE GLOW ANIMATION SETUP
    // Repeating animation for a subtle breathing/pulsing glow
    // =========================================================================
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // =========================================================================
    // APP NAME TEXT ANIMATION SETUP
    // Slides up from below while fading in
    // =========================================================================
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    // =========================================================================
    // TAGLINE ANIMATION SETUP
    // Similar to text but with a delayed start for staggered effect
    // =========================================================================
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _taglineController,
        curve: Curves.easeOut,
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _taglineController,
        curve: Curves.easeOut,
      ),
    );

    // =========================================================================
    // SHIMMER GRADIENT ANIMATION SETUP
    // Continuously sweeps a highlight across the app name text
    // =========================================================================
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _shimmerPosition = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );

    // =========================================================================
    // START THE ANIMATION SEQUENCE
    // =========================================================================
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Step 1: Start the logo entrance animation
    _logoController.forward();

    // Step 2: After 600ms, begin the pulsing glow effect
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _pulseController.repeat(reverse: true);

    // Step 3: After another 200ms (800ms total), animate the app name
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _textController.forward();

    // Step 4: After another 400ms (1200ms total), animate the tagline
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _taglineController.forward();

    // Step 5: After another 200ms (1400ms total), start shimmer
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _shimmerController.repeat();

    // Step 6: Wait remaining time (2500ms total), then navigate
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    _navigateBasedOnAuth();
  }

  void _navigateBasedOnAuth() {
    // Check if a user is currently signed in
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // User is logged in → Navigate to MainScreen
      Navigator.pushAndRemoveUntil(
        context,
        FadeRoute(page: const MainScreen()),
        (route) => false, // Remove all previous routes
      );
    } else {
      // User is not logged in → Navigate to LoginScreen
      Navigator.pushAndRemoveUntil(
        context,
        FadeRoute(page: const LoginScreen()),
        (route) => false, // Remove all previous routes
      );
    }
  }

  @override
  void dispose() {
    // Always dispose animation controllers to prevent memory leaks
    _logoController.dispose();
    _pulseController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Deep black background for maximum neon contrast
      backgroundColor: AppColors.deepBlack,
      body: ParticleBackground(
        // Particle effect layer behind all content
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_logoController, _pulseController]),
                builder: (context, child) {
                  return Transform.scale(
                    // Combine entrance scale with pulse scale for a
                    // smooth transition from entrance → idle pulsing
                    scale: _logoScale.value * _pulseAnimation.value,
                    child: Opacity(
                      opacity: _logoOpacity.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          // Circular shape for the icon container
                          shape: BoxShape.circle,
                          // Multiple layered box shadows create the
                          // characteristic neon glow effect
                          boxShadow: [
                            // Inner glow — tight, bright cyan
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.6),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                            // Mid glow — medium spread, slightly dimmer
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.3),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                            // Outer glow — wide, subtle ambient light
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.1),
                              blurRadius: 80,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // Gradient background for the icon circle
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.cyan.withValues(alpha: 0.2),
                                AppColors.neonPurple.withValues(alpha: 0.2),
                              ],
                            ),
                            // Neon border ring around the icon circle
                            border: Border.all(
                              color: AppColors.cyan.withValues(alpha: 0.8),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_rounded,
                            size: 56,
                            color: AppColors.cyan,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return ShaderMask(
                        // Shimmer effect: a moving gradient overlay that
                        // creates a glint/sweep effect across the text
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              AppColors.cyan,
                              AppColors.neonPurple,
                              Colors.white,
                              AppColors.cyan,
                            ],
                            // Clamp stops to [0.0, 1.0] range to avoid
                            // rendering errors at animation boundaries
                            stops: [
                              0.0,
                              (_shimmerPosition.value - 0.3).clamp(0.0, 1.0),
                              _shimmerPosition.value.clamp(0.0, 1.0),
                              (_shimmerPosition.value + 0.3).clamp(0.0, 1.0),
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          'NeonShop',
                          style: GoogleFonts.orbitron(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            // Neon text glow via text shadows
                            shadows: [
                              Shadow(
                                color: AppColors.cyan.withValues(alpha: 0.8),
                                blurRadius: 20,
                              ),
                              Shadow(
                                color: AppColors.neonPurple.withValues(alpha: 0.5),
                                blurRadius: 40,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              SlideTransition(
                position: _taglineSlide,
                child: FadeTransition(
                  opacity: _taglineOpacity,
                  child: Text(
                    'FUTURE OF SHOPPING',
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 6,
                      color: AppColors.cyan.withValues(alpha: 0.6),
                      shadows: [
                        Shadow(
                          color: AppColors.cyan.withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
