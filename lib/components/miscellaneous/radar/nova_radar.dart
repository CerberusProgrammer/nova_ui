import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';

/// A retro-futuristic radar display component
class NovaRadar extends StatefulWidget {
  /// The size of the radar display
  final double size;

  /// Number of circles in the radar
  final int circleCount;

  /// Whether to show the scanning line animation
  final bool showScanLine;

  /// Whether to show the grid lines
  final bool showGridLines;

  /// Whether to show blips/dots in the radar
  final bool showBlips;

  /// Color of the radar (uses theme accent if null)
  final Color? radarColor;

  /// Animation style controlling intensity
  final NovaAnimationStyle animationStyle;

  /// Animation speed multiplier (1.0 = normal)
  final double animationSpeed;

  /// Glow intensity for the radar elements (0.0 to 1.0)
  final double glowIntensity;

  /// Opacity of the background circles (0.0 to 1.0)
  final double circleOpacity;

  /// Whether to show scan text around the radar
  final bool showRadarText;

  /// Optional data points to show on the radar
  final List<Offset>? dataPoints;

  const NovaRadar({
    super.key,
    this.size = 200.0,
    this.circleCount = 3,
    this.showScanLine = true,
    this.showGridLines = true,
    this.showBlips = true,
    this.radarColor,
    this.animationStyle = NovaAnimationStyle.standard,
    this.animationSpeed = 1.0,
    this.glowIntensity = 0.6,
    this.circleOpacity = 0.5,
    this.showRadarText = true,
    this.dataPoints,
  });

  @override
  State<NovaRadar> createState() => _NovaRadarState();
}

class _NovaRadarState extends State<NovaRadar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_RadarBlip> _blips = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (3000 / widget.animationSpeed).round()),
    );
    _controller.repeat();
    if (widget.showBlips) {
      _generateBlips();
    }
  }

  void _generateBlips() {
    _blips.clear();
    if (widget.dataPoints != null && widget.dataPoints!.isNotEmpty) {
      for (final point in widget.dataPoints!) {
        _blips.add(
          _RadarBlip(
            position: point,
            strength: 0.5 + _random.nextDouble() * 0.5,
            firstSeen: _random.nextDouble(),
          ),
        );
      }
    } else {
      final blipCount = 3 + _random.nextInt(6);

      for (int i = 0; i < blipCount; i++) {
        final angle = _random.nextDouble() * 2 * math.pi;
        final distance = 0.2 + _random.nextDouble() * 0.6;

        _blips.add(
          _RadarBlip(
            position: Offset(
              math.cos(angle) * distance,
              math.sin(angle) * distance,
            ),
            strength: 0.5 + _random.nextDouble() * 0.5,
            firstSeen: _random.nextDouble(),
          ),
        );
      }
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
    final radarColor = widget.radarColor ?? theme.accent;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.background,
        boxShadow: [
          BoxShadow(
            color: radarColor.withOpacity(widget.glowIntensity * 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: radarColor.withOpacity(0.7), width: 2.0),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RadarPainter(
              circleCount: widget.circleCount,
              scanAngle: _controller.value * 2 * math.pi,
              showScanLine: widget.showScanLine,
              showGridLines: widget.showGridLines,
              radarColor: radarColor,
              blips: widget.showBlips ? _blips : [],
              glowIntensity: widget.glowIntensity,
              circleOpacity: widget.circleOpacity,
              showRadarText: widget.showRadarText,
              animationValue: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _RadarBlip {
  final Offset position;
  final double strength;
  final double firstSeen;

  _RadarBlip({
    required this.position,
    required this.strength,
    required this.firstSeen,
  });
}

class _RadarPainter extends CustomPainter {
  final int circleCount;
  final double scanAngle;
  final bool showScanLine;
  final bool showGridLines;
  final Color radarColor;
  final List<_RadarBlip> blips;
  final double glowIntensity;
  final double circleOpacity;
  final bool showRadarText;
  final double animationValue;

  _RadarPainter({
    required this.circleCount,
    required this.scanAngle,
    required this.showScanLine,
    required this.showGridLines,
    required this.radarColor,
    required this.blips,
    required this.glowIntensity,
    required this.circleOpacity,
    required this.showRadarText,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circles
    final circlePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = radarColor.withOpacity(0.3 * circleOpacity);

    for (int i = 1; i <= circleCount; i++) {
      final circleRadius = radius * (i / circleCount);
      canvas.drawCircle(center, circleRadius, circlePaint);
    }

    // Draw grid lines if enabled
    if (showGridLines) {
      final gridPaint =
          Paint()
            ..style = PaintingStyle.stroke
            ..color = radarColor.withOpacity(0.2 * circleOpacity);

      // Draw cross lines
      canvas.drawLine(
        Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius),
        gridPaint,
      );

      canvas.drawLine(
        Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy),
        gridPaint,
      );

      // Draw diagonal lines
      canvas.drawLine(
        Offset(center.dx - radius * 0.7, center.dy - radius * 0.7),
        Offset(center.dx + radius * 0.7, center.dy + radius * 0.7),
        gridPaint,
      );

      canvas.drawLine(
        Offset(center.dx - radius * 0.7, center.dy + radius * 0.7),
        Offset(center.dx + radius * 0.7, center.dy - radius * 0.7),
        gridPaint,
      );
    }

    // Draw radar scan line if enabled
    if (showScanLine) {
      final scanPaint =
          Paint()
            ..style = PaintingStyle.fill
            ..shader = SweepGradient(
              center: Alignment.center,
              startAngle: scanAngle - 0.2,
              endAngle: scanAngle + 0.5,
              colors: [
                radarColor.withOpacity(0.0),
                radarColor.withOpacity(0.5 * glowIntensity),
                radarColor.withOpacity(0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: GradientRotation(scanAngle - math.pi / 2),
            ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawCircle(center, radius, scanPaint);

      // Draw the scan line
      final linePaint =
          Paint()
            ..style = PaintingStyle.stroke
            ..color = radarColor
            ..strokeWidth = 2.0;

      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * math.cos(scanAngle),
          center.dy + radius * math.sin(scanAngle),
        ),
        linePaint,
      );
    }

    // Draw blips
    for (final blip in blips) {
      // Check if blip is visible (depends on scan angle)
      final blipAngle = math.atan2(blip.position.dy, blip.position.dx);

      // Normalize blip angle to 0..2π
      final normalizedBlipAngle =
          blipAngle < 0 ? blipAngle + 2 * math.pi : blipAngle;

      // Normalize scan angle to 0..2π
      final normalizedScanAngle = scanAngle % (2 * math.pi);

      // Calculate the angular difference
      final angleDiff =
          (normalizedScanAngle - normalizedBlipAngle + 2 * math.pi) %
          (2 * math.pi);

      // Blips are visible if they've been "scanned" but not faded out yet
      final isVisible = angleDiff < math.pi / 2;

      if (isVisible) {
        final blipOpacity = 1.0 - (angleDiff / (math.pi / 2));
        final blipPaint =
            Paint()
              ..style = PaintingStyle.fill
              ..color = radarColor.withOpacity(blipOpacity * blip.strength);

        final blipCenter = Offset(
          center.dx + radius * blip.position.dx,
          center.dy + radius * blip.position.dy,
        );

        // Draw the blip with glow
        canvas.drawCircle(
          blipCenter,
          3.0 + blip.strength * 2,
          Paint()
            ..color = radarColor.withOpacity(
              blipOpacity * blip.strength * 0.3 * glowIntensity,
            )
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );

        canvas.drawCircle(blipCenter, 2.0 + blip.strength * 1.5, blipPaint);
      }
    }

    // Draw radar text decorations if enabled
    if (showRadarText) {
      final textPainter = TextPainter(textDirection: TextDirection.ltr);

      final coordinates = ['N', 'E', 'S', 'W'];
      final coords = [
        Offset(center.dx, center.dy - radius + 15), // North
        Offset(center.dx + radius - 15, center.dy), // East
        Offset(center.dx, center.dy + radius - 15), // South
        Offset(center.dx - radius + 15, center.dy), // West
      ];

      for (int i = 0; i < 4; i++) {
        textPainter.text = TextSpan(
          text: coordinates[i],
          style: TextStyle(color: radarColor.withOpacity(0.7), fontSize: 12),
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          coords[i].translate(-textPainter.width / 2, -textPainter.height / 2),
        );
      }
    }

    // Draw center dot
    canvas.drawCircle(center, 3.0, Paint()..color = radarColor);
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) =>
      oldDelegate.scanAngle != scanAngle ||
      oldDelegate.animationValue != animationValue;
}
