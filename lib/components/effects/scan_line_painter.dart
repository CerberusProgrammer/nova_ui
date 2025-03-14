import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Painter for an authentic old CRT monitor scan line effect
class ScanLinePainter extends CustomPainter {
  final double intensity;
  final DateTime _startTime = DateTime.now();

  ScanLinePainter({this.intensity = 0.08});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    final vignetteRect = Rect.fromLTRB(0, 0, size.width, size.height);
    final vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        Colors.transparent,
        Colors.black.withAlpha(((intensity * 1.5) * 255).toInt()),
      ],
      stops: const [0.6, 1.0],
    );

    final vignettePaint =
        Paint()
          ..shader = vignetteGradient.createShader(vignetteRect)
          ..blendMode = BlendMode.multiply;

    canvas.drawRect(vignetteRect, vignettePaint);

    final timeDiff = DateTime.now().difference(_startTime).inMilliseconds;
    final scanPosition = (timeDiff % 2000) / 2000;
    final refreshLineY = size.height * scanPosition;

    final scanLinePaint =
        Paint()
          ..color = Colors.white.withAlpha(((intensity * 1.2) * 255).toInt())
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 2) {
      final lineOpacity = y % 4 == 0 ? intensity * 0.8 : intensity * 0.4;

      scanLinePaint.color = Colors.white.withAlpha((lineOpacity * 255).toInt());
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanLinePaint);
    }

    final leftEdge = size.width * 0.05;
    final rightEdge = size.width * 0.95;

    final rgbSeparationPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    rgbSeparationPaint.color = Colors.red.withAlpha(
      ((intensity * 0.5) * 255).toInt(),
    );
    canvas.drawRect(
      Rect.fromLTRB(leftEdge - 1, 0, rightEdge - 1, size.height),
      rgbSeparationPaint,
    );

    // Blue channel shift
    rgbSeparationPaint.color = Colors.blue.withOpacity(intensity * 0.5);
    canvas.drawRect(
      Rect.fromLTRB(leftEdge + 1, 0, rightEdge + 1, size.height),
      rgbSeparationPaint,
    );

    // CRT refresh line effect (bright horizontal line that moves down)
    final refreshLinePaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(intensity * 1.5),
              Colors.white.withOpacity(0),
            ],
            stops: const [0.0, 1.0],
          ).createShader(Rect.fromLTWH(0, refreshLineY, size.width, 10));

    canvas.drawRect(
      Rect.fromLTWH(0, refreshLineY, size.width, 10),
      refreshLinePaint,
    );

    // Add random digital noise (more visible)
    final noisePaint = Paint();

    for (int i = 0; i < (size.width * size.height) / 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      // Random RGB primary color noise
      final noiseType = random.nextInt(3);
      switch (noiseType) {
        case 0:
          noisePaint.color = Colors.red.withOpacity(intensity * 0.4);
          break;
        case 1:
          noisePaint.color = Colors.green.withOpacity(intensity * 0.4);
          break;
        case 2:
          noisePaint.color = Colors.blue.withOpacity(intensity * 0.4);
          break;
      }

      canvas.drawCircle(Offset(x, y), 0.5, noisePaint);
    }

    // Screen flicker effect
    if (random.nextDouble() > 0.8) {
      // 20% chance of flicker on repaint
      final flickerOpacity = random.nextDouble() * intensity * 0.3;
      final flickerPaint =
          Paint()
            ..color = Colors.white.withOpacity(flickerOpacity)
            ..style = PaintingStyle.fill;

      canvas.drawRect(vignetteRect, flickerPaint);
    }

    // Occasional horizontal distortion lines (like interference)
    if (random.nextDouble() > 0.9) {
      // 10% chance
      final distortPaint =
          Paint()
            ..color = Colors.white.withOpacity(intensity * 0.7)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      final distortY = random.nextDouble() * size.height;
      canvas.drawLine(
        Offset(0, distortY),
        Offset(size.width, distortY),
        distortPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ScanLinePainter oldDelegate) => true; // Always repaint to animate effects
}
