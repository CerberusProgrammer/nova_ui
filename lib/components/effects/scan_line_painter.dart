import 'package:flutter/material.dart';
import 'dart:math' as math;

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

    rgbSeparationPaint.color = Colors.blue.withAlpha(
      (intensity * 0.5 * 255).toInt(),
    );
    canvas.drawRect(
      Rect.fromLTRB(leftEdge + 1, 0, rightEdge + 1, size.height),
      rgbSeparationPaint,
    );

    final refreshLinePaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withAlpha((intensity * 1.5 * 255).toInt()),
              Colors.white.withAlpha(0),
            ],
            stops: const [0.0, 1.0],
          ).createShader(Rect.fromLTWH(0, refreshLineY, size.width, 10));

    canvas.drawRect(
      Rect.fromLTWH(0, refreshLineY, size.width, 10),
      refreshLinePaint,
    );

    final noisePaint = Paint();

    for (int i = 0; i < (size.width * size.height) / 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      final noiseType = random.nextInt(3);
      switch (noiseType) {
        case 0:
          noisePaint.color = Colors.red.withAlpha(
            (intensity * 0.4 * 255).toInt(),
          );
          break;
        case 1:
          noisePaint.color = Colors.green.withAlpha(
            (intensity * 0.4 * 255).toInt(),
          );
          break;
        case 2:
          noisePaint.color = Colors.blue.withAlpha(
            (intensity * 0.4 * 255).toInt(),
          );
          break;
      }

      canvas.drawCircle(Offset(x, y), 0.5, noisePaint);
    }

    if (random.nextDouble() > 0.8) {
      final flickerOpacity = random.nextDouble() * intensity * 0.3;
      final flickerPaint =
          Paint()
            ..color = Colors.white.withAlpha((flickerOpacity * 255).toInt())
            ..style = PaintingStyle.fill;

      canvas.drawRect(vignetteRect, flickerPaint);
    }

    if (random.nextDouble() > 0.9) {
      final distortPaint =
          Paint()
            ..color = Colors.white.withAlpha((intensity * 0.7 * 255).toInt())
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
  bool shouldRepaint(covariant ScanLinePainter oldDelegate) => true;
}
