import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';

/// A retro-futuristic power core visualization component
class NovaPowerCore extends StatefulWidget {
  /// The size of the power core
  final double size;

  /// Color of the core (uses theme accent if null)
  final Color? coreColor;

  /// Secondary color for effects (uses theme primary if null)
  final Color? secondaryColor;

  /// Animation style controlling intensity
  final NovaAnimationStyle animationStyle;

  /// Animation speed multiplier (1.0 = normal)
  final double animationSpeed;

  /// Glow intensity (0.0 to 1.0)
  final double glowIntensity;

  /// Number of rings around the core
  final int ringCount;

  /// Number of energy particles
  final int particleCount;

  /// Power level (0.0 to 1.0)
  final double powerLevel;

  /// Whether to show power level indicator
  final bool showPowerLevel;

  const NovaPowerCore({
    super.key,
    this.size = 200.0,
    this.coreColor,
    this.secondaryColor,
    this.animationStyle = NovaAnimationStyle.standard,
    this.animationSpeed = 1.0,
    this.glowIntensity = 0.8,
    this.ringCount = 3,
    this.particleCount = 20,
    this.powerLevel = 0.7,
    this.showPowerLevel = true,
  });

  @override
  State<NovaPowerCore> createState() => _NovaPowerCoreState();
}

class _NovaPowerCoreState extends State<NovaPowerCore>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_EnergyParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (6000 / widget.animationSpeed).round()),
    );
    _controller.repeat();
    _generateParticles();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(
        _EnergyParticle(
          angle: _random.nextDouble() * 2 * math.pi,
          speed: 0.2 + _random.nextDouble() * 0.8,
          size: 1.0 + _random.nextDouble() * 2.0,
          distance: 0.1 + _random.nextDouble() * 0.2,
          opacity: 0.3 + _random.nextDouble() * 0.7,
          lifespan: 0.5 + _random.nextDouble() * 0.5,
          birthTime: _random.nextDouble(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;
    final coreColor = widget.coreColor ?? theme.accent;
    final secondaryColor = widget.secondaryColor ?? theme.primary;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.surface,
        boxShadow: [
          BoxShadow(
            color: coreColor.withOpacity(widget.glowIntensity * 0.4),
            blurRadius: widget.size / 8,
            spreadRadius: widget.size / 20,
          ),
        ],
        border: Border.all(color: secondaryColor.withOpacity(0.6), width: 1.0),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _PowerCorePainter(
              animationValue: _controller.value,
              coreColor: coreColor,
              secondaryColor: secondaryColor,
              glowIntensity: widget.glowIntensity,
              particles: _particles,
              ringCount: widget.ringCount,
              powerLevel: widget.powerLevel,
              showPowerLevel: widget.showPowerLevel,
              animationStyle: widget.animationStyle,
            ),
          );
        },
      ),
    );
  }
}

class _EnergyParticle {
  final double angle;
  final double speed;
  final double size;
  double distance;
  double opacity;
  final double lifespan;
  final double birthTime;

  _EnergyParticle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.distance,
    required this.opacity,
    required this.lifespan,
    required this.birthTime,
  });
}

class _PowerCorePainter extends CustomPainter {
  final double animationValue;
  final Color coreColor;
  final Color secondaryColor;
  final double glowIntensity;
  final List<_EnergyParticle> particles;
  final int ringCount;
  final double powerLevel;
  final bool showPowerLevel;
  final NovaAnimationStyle animationStyle;

  _PowerCorePainter({
    required this.animationValue,
    required this.coreColor,
    required this.secondaryColor,
    required this.glowIntensity,
    required this.particles,
    required this.ringCount,
    required this.powerLevel,
    required this.showPowerLevel,
    required this.animationStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final coreRadius = radius * 0.35;

    // Update particle positions
    _updateParticles(animationValue, radius);

    // Draw outer rings
    _drawRings(canvas, center, radius, coreRadius);

    // Draw energy particles
    _drawParticles(canvas, center, radius);

    // Draw core
    _drawCore(canvas, center, coreRadius);

    // Draw power level indicator
    if (showPowerLevel) {
      _drawPowerLevel(canvas, center, radius, coreRadius);
    }
  }

  void _updateParticles(double animValue, double maxRadius) {
    for (final particle in particles) {
      final age = (animValue + particle.birthTime) % 1.0;

      if (age < particle.lifespan) {
        final lifeProgress = age / particle.lifespan;
        particle.distance = 0.2 + lifeProgress * 0.8;
        particle.opacity = 1.0 - lifeProgress;
      } else {
        particle.distance = 0.2;
        particle.opacity = 1.0;
      }
    }
  }

  void _drawRings(
    Canvas canvas,
    Offset center,
    double radius,
    double coreRadius,
  ) {
    for (int i = 0; i < ringCount; i++) {
      final ringRadius =
          coreRadius + (radius - coreRadius) * (i + 1) / (ringCount + 1);

      // Calculate rotation angle for this ring (each rotates at different speed)
      final direction = i % 2 == 0 ? 1 : -1;
      final speed = 0.5 + (i / ringCount) * 0.5;
      final rotationAngle = (animationValue * speed * math.pi * 2) * direction;

      // Draw dashed ring
      final ringPaint =
          Paint()
            ..style = PaintingStyle.stroke
            ..color = secondaryColor.withOpacity(0.5 + (i / ringCount) * 0.5)
            ..strokeWidth = 1.0;

      final dashCount = 12 + i * 4;

      for (int j = 0; j < dashCount; j++) {
        final startAngle = (j / dashCount) * math.pi * 2 + rotationAngle;
        final arc = math.pi / dashCount;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: ringRadius),
          startAngle,
          arc,
          false,
          ringPaint,
        );
      }

      // Draw glow
      if (glowIntensity > 0) {
        canvas.drawCircle(
          center,
          ringRadius,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = secondaryColor.withOpacity(0.15 * glowIntensity)
            ..strokeWidth = 2.0
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
      }
    }
  }

  void _drawParticles(Canvas canvas, Offset center, double radius) {
    for (final particle in particles) {
      final particleX =
          center.dx + math.cos(particle.angle) * radius * particle.distance;
      final particleY =
          center.dy + math.sin(particle.angle) * radius * particle.distance;
      final particlePos = Offset(particleX, particleY);

      // Draw glow
      if (glowIntensity > 0) {
        canvas.drawCircle(
          particlePos,
          particle.size * 2.5,
          Paint()
            ..color = coreColor.withOpacity(
              particle.opacity * 0.3 * glowIntensity,
            )
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }

      // Draw particle
      canvas.drawCircle(
        particlePos,
        particle.size,
        Paint()..color = coreColor.withOpacity(particle.opacity),
      );
    }
  }

  void _drawCore(Canvas canvas, Offset center, double coreRadius) {
    // Get pulse effect based on animation
    final pulseEffect = math.sin(animationValue * math.pi * 4) * 0.1 + 0.9;
    final pulsatingRadius = coreRadius * pulseEffect;

    // Draw core glow
    if (glowIntensity > 0) {
      canvas.drawCircle(
        center,
        pulsatingRadius * 1.5,
        Paint()
          ..style = PaintingStyle.fill
          ..color = coreColor.withOpacity(0.3 * glowIntensity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );
    }

    // Draw core
    final coreGradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        coreColor.withOpacity(1.0),
        coreColor.withOpacity(0.7),
        coreColor.withOpacity(0.0),
      ],
      stops: const [0.0, 0.7, 1.0],
    );

    canvas.drawCircle(
      center,
      pulsatingRadius,
      Paint()
        ..shader = coreGradient.createShader(
          Rect.fromCircle(center: center, radius: pulsatingRadius),
        ),
    );

    // Draw core rings
    canvas.drawCircle(
      center,
      pulsatingRadius * 0.8,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white.withOpacity(0.6)
        ..strokeWidth = 1.0,
    );

    canvas.drawCircle(
      center,
      pulsatingRadius * 0.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white.withOpacity(0.8)
        ..strokeWidth = 0.5,
    );
  }

  void _drawPowerLevel(
    Canvas canvas,
    Offset center,
    double radius,
    double coreRadius,
  ) {
    final textStyle = TextStyle(
      color: coreColor,
      fontSize: radius / 10,
      fontWeight: FontWeight.bold,
    );

    // Draw power level text
    final powerText = "POWER: ${(powerLevel * 100).toInt()}%";
    final textSpan = TextSpan(text: powerText, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy + radius * 0.6),
    );

    // Draw power bar
    final barWidth = radius * 1.2;
    final barHeight = radius / 15;
    final barLeft = center.dx - barWidth / 2;
    final barTop = center.dy + radius * 0.7;

    // Draw bar background
    canvas.drawRect(
      Rect.fromLTWH(barLeft, barTop, barWidth, barHeight),
      Paint()
        ..color = secondaryColor.withOpacity(0.3)
        ..style = PaintingStyle.fill,
    );

    // Draw bar fill
    canvas.drawRect(
      Rect.fromLTWH(barLeft, barTop, barWidth * powerLevel, barHeight),
      Paint()
        ..color = coreColor
        ..style = PaintingStyle.fill,
    );

    // Draw bar border
    canvas.drawRect(
      Rect.fromLTWH(barLeft, barTop, barWidth, barHeight),
      Paint()
        ..color = secondaryColor.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Draw tick marks
    for (int i = 0; i <= 10; i++) {
      final tickX = barLeft + (barWidth * i / 10);
      canvas.drawLine(
        Offset(tickX, barTop),
        Offset(tickX, barTop + barHeight),
        Paint()
          ..color = secondaryColor.withOpacity(0.5)
          ..strokeWidth = i % 5 == 0 ? 1.0 : 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PowerCorePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.powerLevel != powerLevel;
}
