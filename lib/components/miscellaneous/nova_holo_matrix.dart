import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';

/// A cyberpunk-style holographic matrix visualization
class NovaHologramMatrix extends StatefulWidget {
  /// Width of the hologram
  final double width;

  /// Height of the hologram
  final double height;

  /// Primary color for the hologram (uses theme accent if null)
  final Color? hologramColor;

  /// Animation style controlling intensity
  final NovaAnimationStyle animationStyle;

  /// Animation speed multiplier (1.0 = normal)
  final double animationSpeed;

  /// Glow intensity (0.0 to 1.0)
  final double glowIntensity;

  /// Distortion amount (0.0 to 1.0)
  final double distortion;

  /// Whether to show scan lines
  final bool showScanLines;

  /// Whether to show data points
  final bool showDataLabels;

  /// Whether to show the wireframe structure
  final bool showWireframe;

  const NovaHologramMatrix({
    super.key,
    this.width = 300.0,
    this.height = 240.0,
    this.hologramColor,
    this.animationStyle = NovaAnimationStyle.standard,
    this.animationSpeed = 1.0,
    this.glowIntensity = 0.8,
    this.distortion = 0.6,
    this.showScanLines = true,
    this.showDataLabels = true,
    this.showWireframe = true,
  });

  @override
  State<NovaHologramMatrix> createState() => _NovaHologramMatrixState();
}

class _NovaHologramMatrixState extends State<NovaHologramMatrix>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_HologramPoint3D> _points;
  late List<_HologramLine> _lines;
  late List<_HologramGlitch> _glitches;
  final math.Random _random = math.Random();
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _rotationZ = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (10000 / widget.animationSpeed).round()),
    );
    _controller.repeat();

    // Initial rotation angles
    _rotationX = _random.nextDouble() * math.pi / 4;
    _rotationY = _random.nextDouble() * math.pi;
    _rotationZ = _random.nextDouble() * math.pi / 6;

    _generateHologram();
  }

  void _generateHologram() {
    // Create a 3D grid of points for the hologram
    _points = [];

    // Generate a cube-like structure with density based on animation style
    int density =
        widget.animationStyle == NovaAnimationStyle.dramatic
            ? 5
            : widget.animationStyle == NovaAnimationStyle.subtle
            ? 3
            : 4;

    // Create points in a 3D grid
    for (int x = -density; x <= density; x++) {
      for (int y = -density; y <= density; y++) {
        for (int z = -density; z <= density; z++) {
          // Skip some internal points to make it less dense
          if (x != -density &&
              x != density &&
              y != -density &&
              y != density &&
              z != -density &&
              z != density &&
              _random.nextDouble() > 0.3) {
            continue;
          }

          // Position within -1.0 to 1.0 range
          final point = _HologramPoint3D(
            position: Vector3(
              x / density.toDouble(),
              y / density.toDouble(),
              z / density.toDouble(),
            ),
            size: 1.5 + _random.nextDouble() * 2.0,
            intensity: 0.3 + _random.nextDouble() * 0.7,
            dataValue: (_random.nextInt(999) + 100).toString(),
          );

          _points.add(point);
        }
      }
    }

    // Create connecting lines between nearby points
    _lines = [];
    for (int i = 0; i < _points.length; i++) {
      for (int j = i + 1; j < _points.length; j++) {
        final distance = (_points[i].position - _points[j].position).length;

        // Only connect relatively close points
        if (distance < 0.7) {
          _lines.add(
            _HologramLine(
              startPointIndex: i,
              endPointIndex: j,
              intensity: math.max(0.0, 1.0 - distance),
            ),
          );
        }
      }
    }

    // Generate glitch effects
    _glitches = List.generate(
      3 + _random.nextInt(4),
      (index) => _HologramGlitch(
        startTime: _random.nextDouble(),
        duration: 0.05 + _random.nextDouble() * 0.1,
        yPos: _random.nextDouble(),
        height: 0.05 + _random.nextDouble() * 0.1,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;
    final hologramColor = widget.hologramColor ?? theme.accent;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: hologramColor.withOpacity(0.6), width: 1),
        boxShadow: [
          BoxShadow(
            color: hologramColor.withOpacity(0.2 * widget.glowIntensity),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Update rotation
          final animDelta = _controller.value * math.pi * 2;
          _rotationX = 0.2 * math.sin(animDelta * 0.5) + _rotationX / 5;
          _rotationY += 0.01;
          _rotationZ = 0.1 * math.sin(animDelta * 0.3) + _rotationZ / 5;

          return CustomPaint(
            painter: _HologramMatrixPainter(
              points: _points,
              lines: _lines,
              glitches: _glitches,
              hologramColor: hologramColor,
              glowIntensity: widget.glowIntensity,
              distortion: widget.distortion,
              animationValue: _controller.value,
              rotationX: _rotationX,
              rotationY: _rotationY,
              rotationZ: _rotationZ,
              showScanLines: widget.showScanLines,
              showDataLabels: widget.showDataLabels,
              showWireframe: widget.showWireframe,
            ),
          );
        },
      ),
    );
  }
}

class Vector3 {
  final double x;
  final double y;
  final double z;

  Vector3(this.x, this.y, this.z);

  Vector3 operator -(Vector3 other) {
    return Vector3(x - other.x, y - other.y, z - other.z);
  }

  double get length {
    return math.sqrt(x * x + y * y + z * z);
  }

  Vector3 transform(double rotX, double rotY, double rotZ) {
    // Apply 3D rotation transformations
    // X rotation
    double y1 = y * math.cos(rotX) - z * math.sin(rotX);
    double z1 = y * math.sin(rotX) + z * math.cos(rotX);

    // Y rotation
    double x2 = x * math.cos(rotY) + z1 * math.sin(rotY);
    double z2 = -x * math.sin(rotY) + z1 * math.cos(rotY);

    // Z rotation
    double x3 = x2 * math.cos(rotZ) - y1 * math.sin(rotZ);
    double y3 = x2 * math.sin(rotZ) + y1 * math.cos(rotZ);

    return Vector3(x3, y3, z2);
  }
}

class _HologramPoint3D {
  final Vector3 position;
  final double size;
  final double intensity;
  final String dataValue;

  _HologramPoint3D({
    required this.position,
    required this.size,
    required this.intensity,
    required this.dataValue,
  });
}

class _HologramLine {
  final int startPointIndex;
  final int endPointIndex;
  final double intensity;

  _HologramLine({
    required this.startPointIndex,
    required this.endPointIndex,
    required this.intensity,
  });
}

class _HologramGlitch {
  final double startTime;
  final double duration;
  final double yPos;
  final double height;

  _HologramGlitch({
    required this.startTime,
    required this.duration,
    required this.yPos,
    required this.height,
  });

  bool isActive(double time) {
    final normalizedTime = time % 1.0;
    final endTime = (startTime + duration) % 1.0;

    if (startTime < endTime) {
      return normalizedTime >= startTime && normalizedTime <= endTime;
    } else {
      // Handle wrap-around case
      return normalizedTime >= startTime || normalizedTime <= endTime;
    }
  }
}

class _HologramMatrixPainter extends CustomPainter {
  final List<_HologramPoint3D> points;
  final List<_HologramLine> lines;
  final List<_HologramGlitch> glitches;
  final Color hologramColor;
  final double glowIntensity;
  final double distortion;
  final double animationValue;
  final double rotationX;
  final double rotationY;
  final double rotationZ;
  final bool showScanLines;
  final bool showDataLabels;
  final bool showWireframe;

  _HologramMatrixPainter({
    required this.points,
    required this.lines,
    required this.glitches,
    required this.hologramColor,
    required this.glowIntensity,
    required this.distortion,
    required this.animationValue,
    required this.rotationX,
    required this.rotationY,
    required this.rotationZ,
    required this.showScanLines,
    required this.showDataLabels,
    required this.showWireframe,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    _drawHologramBase(canvas, center, size);
    final projectedPoints = _calculateProjections(size);

    if (showScanLines) {
      _drawScanLines(canvas, size);
    }

    _drawGlitches(canvas, size);

    if (showWireframe) {
      _drawConnections(canvas, projectedPoints);
    }

    // Draw data points
    _drawPoints(canvas, projectedPoints);

    if (showDataLabels) {
      // Draw data labels
      _drawDataLabels(canvas, projectedPoints);
    }

    // Draw additional hologram effects
    _drawHologramEffects(canvas, size);
  }

  List<Offset> _calculateProjections(Size size) {
    // Project 3D points to 2D with perspective
    final baseSize = math.min(size.width, size.height) * 0.4;
    final center = Offset(size.width / 2, size.height / 2);

    return points.map((point) {
      // Apply 3D rotation transformation
      final transformed = point.position.transform(
        rotationX,
        rotationY,
        rotationZ,
      );

      // Apply perspective projection (basic Z-perspective)
      // Adjust the divisor to control perspective strength
      final perspectiveZ = 2.0 + transformed.z;
      final perspectiveScale = 1.0 / perspectiveZ;

      // Calculate projected x, y on screen
      final x = center.dx + transformed.x * baseSize * perspectiveScale;
      final y = center.dy + transformed.y * baseSize * perspectiveScale;

      return Offset(x, y);
    }).toList();
  }

  void _drawHologramBase(Canvas canvas, Offset center, Size size) {
    final baseWidth = size.width * 0.8;
    final baseHeight = size.height * 0.05;
    final baseRect = Rect.fromCenter(
      center: Offset(center.dx, size.height * 0.95),
      width: baseWidth,
      height: baseHeight,
    );

    // Draw base gradient
    final baseGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [hologramColor.withOpacity(0.5), hologramColor.withOpacity(0.1)],
    );

    canvas.drawRect(
      baseRect,
      Paint()..shader = baseGradient.createShader(baseRect),
    );

    // Draw base border
    canvas.drawRect(
      baseRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = hologramColor.withOpacity(0.7)
        ..strokeWidth = 1.5,
    );

    // Draw vertical light beam
    final beamRect = Rect.fromLTRB(
      center.dx - baseWidth * 0.05,
      0,
      center.dx + baseWidth * 0.05,
      size.height * 0.95,
    );

    final beamGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        hologramColor.withOpacity(0.0),
        hologramColor.withOpacity(0.05),
        hologramColor.withOpacity(0.1),
      ],
    );

    canvas.drawRect(
      beamRect,
      Paint()..shader = beamGradient.createShader(beamRect),
    );
  }

  void _drawPoints(Canvas canvas, List<Offset> projectedPoints) {
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final projection = projectedPoints[i];

      // Point size adjusted for perspective
      final baseSize = math.min(
        point.size * (1.0 + point.position.z * 0.5),
        5.0,
      );

      // Add pulsation effect
      final pulse =
          0.8 + 0.2 * math.sin(animationValue * math.pi * 2 + i * 0.5);
      final pointSize = baseSize * pulse;

      // Point intensity with distance falloff
      final intensity =
          point.intensity * (1.0 - math.min(1.0, point.position.z.abs()));

      // Draw point glow
      if (glowIntensity > 0) {
        canvas.drawCircle(
          projection,
          pointSize * 2.0,
          Paint()
            ..color = hologramColor.withOpacity(intensity * 0.3 * glowIntensity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
      }

      // Draw point
      canvas.drawCircle(
        projection,
        pointSize,
        Paint()..color = hologramColor.withOpacity(intensity * 0.8),
      );

      // Draw point highlight
      canvas.drawCircle(
        projection,
        pointSize * 0.3,
        Paint()..color = Colors.white.withOpacity(intensity * 0.6),
      );
    }
  }

  void _drawConnections(Canvas canvas, List<Offset> projectedPoints) {
    for (final line in lines) {
      final startPoint = projectedPoints[line.startPointIndex];
      final endPoint = projectedPoints[line.endPointIndex];

      // Check if line is mostly behind view (basic culling)
      final startZ = points[line.startPointIndex].position.z;
      final endZ = points[line.endPointIndex].position.z;
      final avgZ = (startZ + endZ) / 2;

      if (avgZ > 0.8) continue;

      // Line intensity with distance falloff
      final intensity = line.intensity * (1.0 - math.min(1.0, avgZ.abs()));

      // Apply flickering
      final flicker =
          0.8 +
          0.2 * math.sin(animationValue * math.pi * 10 + line.startPointIndex);

      // Draw connection glow
      if (glowIntensity > 0) {
        canvas.drawLine(
          startPoint,
          endPoint,
          Paint()
            ..color = hologramColor.withOpacity(
              intensity * 0.3 * glowIntensity * flicker,
            )
            ..strokeWidth = 2.0
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }

      // Draw connection line
      canvas.drawLine(
        startPoint,
        endPoint,
        Paint()
          ..color = hologramColor.withOpacity(intensity * 0.6 * flicker)
          ..strokeWidth = 0.8,
      );
    }
  }

  void _drawDataLabels(Canvas canvas, List<Offset> projectedPoints) {
    // Only show labels for select points to avoid clutter
    for (int i = 0; i < points.length; i++) {
      // Skip some labels
      if (i % 5 != 0) continue;

      final point = points[i];
      final projection = projectedPoints[i];

      // Skip points that are too far back
      if (point.position.z > 0.5) continue;

      // Intensity with distance falloff
      final intensity =
          point.intensity * (1.0 - math.min(1.0, point.position.z.abs()));

      // Create a data label
      final textStyle = TextStyle(
        color: hologramColor.withOpacity(intensity * 0.7),
        fontSize: 8.0,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w500,
      );

      final textSpan = TextSpan(text: point.dataValue, style: textStyle);

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // Position label near point
      final labelOffset = Offset(
        projection.dx + 8.0,
        projection.dy - textPainter.height / 2,
      );

      // Draw text
      textPainter.paint(canvas, labelOffset);

      // Draw connecting line from point to label
      canvas.drawLine(
        projection,
        Offset(labelOffset.dx - 3, labelOffset.dy + textPainter.height / 2),
        Paint()
          ..color = hologramColor.withOpacity(intensity * 0.5)
          ..strokeWidth = 0.5,
      );
    }
  }

  void _drawScanLines(Canvas canvas, Size size) {
    // Horizontal scan lines
    final scanPaint =
        Paint()
          ..color = hologramColor.withOpacity(0.2)
          ..strokeWidth = 0.5;

    for (double y = 0; y < size.height; y += 4.0) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanPaint);
    }

    // Moving scan line
    final scanY = (animationValue * size.height * 2) % size.height;
    canvas.drawLine(
      Offset(0, scanY),
      Offset(size.width, scanY),
      Paint()
        ..color = hologramColor.withOpacity(0.4)
        ..strokeWidth = 1.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
  }

  void _drawGlitches(Canvas canvas, Size size) {
    // Apply random horizontal displacements to create a glitch effect
    for (final glitch in glitches) {
      if (glitch.isActive(animationValue)) {
        final glitchY = size.height * glitch.yPos;
        final glitchHeight = size.height * glitch.height;
        final displacement = size.width * 0.05 * distortion;

        // Glitch rect
        final glitchRect = Rect.fromLTWH(0, glitchY, size.width, glitchHeight);

        // Save current canvas state
        canvas.save();

        // Clip to glitch area
        canvas.clipRect(glitchRect);

        // Translate horizontally
        canvas.translate(displacement, 0);

        // Draw glitch overlay
        canvas.drawRect(
          glitchRect,
          Paint()
            ..color = hologramColor.withOpacity(0.3)
            ..blendMode = BlendMode.screen,
        );

        // Restore canvas state
        canvas.restore();
      }
    }
  }

  void _drawHologramEffects(Canvas canvas, Size size) {
    // Draw hologram frame corners
    final cornerSize = size.width * 0.08;
    final strokeWidth = 2.0;
    final cornerPaint =
        Paint()
          ..color = hologramColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerSize)
        ..lineTo(0, 0)
        ..lineTo(cornerSize, 0),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerSize, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, cornerSize),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerSize)
        ..lineTo(0, size.height)
        ..lineTo(cornerSize, size.height),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerSize, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - cornerSize),
      cornerPaint,
    );

    // Draw status text
    final statusText =
        "MATRIX-${(animationValue * 999).toInt().toString().padLeft(3, '0')}";
    final textStyle = TextStyle(
      color: hologramColor,
      fontSize: 10,
      fontFamily: 'monospace',
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(text: statusText, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - textPainter.width - 10, 10));

    // Draw coordinate axes indicators
    final axisText =
        "X:${(rotationX * 100).toInt()} Y:${(rotationY * 100).toInt()}";
    final axisSpan = TextSpan(text: axisText, style: textStyle);

    final axisPainter = TextPainter(
      text: axisSpan,
      textDirection: TextDirection.ltr,
    );

    axisPainter.layout();
    axisPainter.paint(
      canvas,
      Offset(10, size.height - axisPainter.height - 10),
    );
  }

  @override
  bool shouldRepaint(covariant _HologramMatrixPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.rotationX != rotationX ||
      oldDelegate.rotationY != rotationY ||
      oldDelegate.rotationZ != rotationZ;
}
