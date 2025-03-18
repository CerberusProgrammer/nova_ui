import 'dart:math' as math;
import 'package:flutter/material.dart';

class NovaHexagonPainter extends CustomPainter {
  final Color color;
  final double size;

  NovaHexagonPainter({required this.color, this.size = 40});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    final rows = (canvasSize.height / (size * 0.75)).ceil();
    final cols = (canvasSize.width / (size * 0.866)).ceil();

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final isOffset = c % 2 == 1;
        final centerX = c * size * 0.866;
        final centerY = r * size * 0.75 + (isOffset ? size * 0.375 : 0);

        if (centerX < 0 ||
            centerX > canvasSize.width ||
            centerY < 0 ||
            centerY > canvasSize.height) {
          continue;
        }

        final path = Path();
        for (int i = 0; i < 6; i++) {
          final angle = (i * 60 + 30) * math.pi / 180;
          final x = centerX + size * 0.5 * math.cos(angle);
          final y = centerY + size * 0.5 * math.sin(angle);

          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(NovaHexagonPainter oldDelegate) => false;
}
