import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/constants.dart';

// Animated floating particles background
class _Particle {
  double x;
  double y;
  final double vx;
  final double vy;
  final double radius;
  final Color color;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
    required this.opacity,
  });
}

// Wrap child with animated particle layer
class ParticleBackground extends StatefulWidget {
  /// The main content widget to display on top of
  /// the particle animation layer.
  final Widget child;

  /// Number of particles to render. More particles
  /// create a denser effect but may impact performance
  /// on low-end devices. Defaults to 50.
  final int particleCount;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 50,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  /// The animation controller that drives the particle motion.
  /// It runs on an infinite loop, ticking at the display's
  /// refresh rate (typically 60fps).
  late AnimationController _controller;

  /// List of all particles in the scene.
  /// Generated once during initialization with random properties.
  late List<_Particle> _particles;

  /// Random number generator for particle initialization.
  final Random _random = Random();

  /// Available neon colors for particles.
  /// These are drawn from the app's color palette to maintain
  /// visual consistency with the Cyber Neon theme.
  static const List<Color> _particleColors = [
    AppColors.electricBlue,
    AppColors.neonPurple,
    AppColors.cyan,
  ];

  @override
  void initState() {
    super.initState();

    // Create the animation controller with a 10-second duration.
    // The actual duration doesn't matter much since we're repeating
    // forever — it just defines the granularity of the animation value.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Start repeating immediately

    // Generate particles with random properties.
    // We use a placeholder size (1000x1000) for initial positions;
    // the actual screen size is applied during the first paint.
    _particles = _generateParticles(widget.particleCount);

    // Listen to animation ticks to update particle positions.
    // Each tick moves every particle by its velocity vector.
    _controller.addListener(_updateParticles);
  }

  /// Generates a list of particles with randomized properties.
  /// Each particle gets:
  /// - A random starting position across the screen
  /// - A random velocity (speed and direction) for drifting
  /// - A random size between 1-3 pixels
  /// - A random color from the neon palette
  /// - A random opacity between 0.2-0.5 (subtle, not distracting)
  List<_Particle> _generateParticles(int count) {
    return List.generate(count, (_) {
      return _Particle(
        // Random starting position — will be constrained to
        // actual screen dimensions during rendering
        x: _random.nextDouble() * 1000,
        y: _random.nextDouble() * 1000,
        // Velocity: small values for slow, ambient drift
        // Range: -0.3 to +0.3 pixels per frame
        vx: (_random.nextDouble() - 0.5) * 0.6,
        vy: (_random.nextDouble() - 0.5) * 0.6,
        // Small radius for subtle dot effect
        radius: 1.0 + _random.nextDouble() * 2.0,
        // Pick a random neon color
        color: _particleColors[_random.nextInt(_particleColors.length)],
        // Low opacity so particles don't overpower content
        opacity: 0.2 + _random.nextDouble() * 0.3,
      );
    });
  }

  /// Updates all particle positions on each animation frame.
  /// Called by the AnimationController listener at ~60fps.
  ///
  /// Movement logic:
  /// - Each particle advances by its velocity (vx, vy)
  /// - Screen wrapping is applied so particles that exit one
  ///   edge reappear on the opposite edge seamlessly
  void _updateParticles() {
    // Get the current render box size for boundary wrapping
    final size = context.size;
    if (size == null) return;

    for (final particle in _particles) {
      // Advance position by velocity
      particle.x += particle.vx;
      particle.y += particle.vy;

      // Wrap horizontally — if a particle goes off the right edge,
      // it reappears on the left, and vice versa
      if (particle.x > size.width) {
        particle.x = 0;
      } else if (particle.x < 0) {
        particle.x = size.width;
      }

      // Wrap vertically — same logic for top/bottom edges
      if (particle.y > size.height) {
        particle.y = 0;
      } else if (particle.y < 0) {
        particle.y = size.height;
      }
    }

    // Trigger a repaint of the CustomPainter with updated positions
    // Note: setState is needed because we're modifying particle data
    // that the painter reads. In a production app, you might use a
    // ValueNotifier or Listenable for more efficient repaints.
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Clean up the animation controller to prevent memory leaks
    // and unnecessary frame callbacks
    _controller.removeListener(_updateParticles);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: The particle animation canvas
        // Positioned.fill ensures it covers the entire parent area
        Positioned.fill(
          child: CustomPaint(
            painter: _ParticlePainter(particles: _particles),
          ),
        ),

        // Layer 2: The actual content on top of particles
        widget.child,
      ],
    );
  }
}

// Efficiently renders particles on a single canvas
class _ParticlePainter extends CustomPainter {
  /// Reference to the list of particles to draw.
  final List<_Particle> particles;

  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    // Reusable paint object — we modify its color for each particle
    // rather than creating new Paint instances (better for GC)
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Set the particle's color with its individual opacity
      paint.color = particle.color.withValues(alpha: particle.opacity);

      // Draw a filled circle at the particle's current position
      canvas.drawCircle(
        Offset(particle.x % size.width, particle.y % size.height),
        particle.radius,
        paint,
      );
    }
  }

  /// Always repaint — we rely on the animation controller to
  /// drive repaints at the appropriate frame rate. Since particle
  /// positions change every frame, we always need to redraw.
  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
