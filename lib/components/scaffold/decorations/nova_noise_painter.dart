import 'dart:math' as math;
import 'package:flutter/material.dart';

class NovaNoisePainter extends CustomPainter {
  final Color color;
  final double opacity;
  final int seed;

  NovaNoisePainter({required this.color, this.opacity = 0.05, this.seed = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed + DateTime.now().microsecondsSinceEpoch);
    final paint =
        Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.fill;

    final pixelSize = 2.0;
    final cols = (size.width / pixelSize).ceil();
    final rows = (size.height / pixelSize).ceil();

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        if (random.nextDouble() > 0.97) {
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
