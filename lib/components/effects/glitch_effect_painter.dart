import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlitchPainter extends CustomPainter {
  final bool isHover;
  final Color? textColor;

  GlitchPainter({this.isHover = false, this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random();

    final baseOpacity = isHover ? 0.03 : 0.08;
    final effectCount = isHover ? 6 : 10;

    final distortionPaint =
        Paint()
          ..color = Colors.white.withAlpha(
            ((isHover ? 0.05 : 0.15) * 255).toInt(),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = isHover ? 0.8 : 1.5;

    final lineCount = isHover ? 2 : 5;

    for (int i = 0; i < lineCount; i++) {
      final yPos = random.nextDouble() * size.height;
      final xOffset = random.nextDouble() * 4 - 2;

      canvas.drawLine(
        Offset(0, yPos),
        Offset(size.width + xOffset, yPos + random.nextDouble() * 2 - 1),
        distortionPaint,
      );
    }

    final glitchPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < effectCount; i++) {
      glitchPaint.color = Colors.white.withAlpha((baseOpacity * 255).toInt());

      final width = random.nextDouble() * (isHover ? 10 : 20) + 5;
      final height = random.nextDouble() * (isHover ? 1 : 2) + 1;

      final rect = Rect.fromLTWH(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
        width,
        height,
      );
      canvas.drawRect(rect, glitchPaint);
    }

    if (!isHover && random.nextBool()) {
      final verticalGlitchPaint =
          Paint()
            ..color = Colors.white.withAlpha((0.1 * 255).toInt())
            ..style = PaintingStyle.fill;

      final xPos = random.nextDouble() * size.width;
      final width = random.nextDouble() * 8 + 2;

      canvas.drawRect(
        Rect.fromLTWH(xPos, 0, width, size.height),
        verticalGlitchPaint,
      );
    }

    if (!isHover && random.nextDouble() > 0.8) {
      final timeBased = DateTime.now().millisecondsSinceEpoch % 1000 / 1000;
      final distortY = size.height * timeBased;

      canvas.drawLine(
        Offset(0, distortY),
        Offset(size.width, distortY + random.nextDouble() * 4 - 2),
        Paint()
          ..color = Colors.white.withAlpha((0.2 * 255).toInt())
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
