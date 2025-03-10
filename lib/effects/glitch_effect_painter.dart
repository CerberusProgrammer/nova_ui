import 'package:flutter/material.dart';
import 'dart:math' as math;

// Modify the GlitchPainter to support different intensity levels
class GlitchPainter extends CustomPainter {
  final bool isHover;
  final Color? textColor;

  GlitchPainter({this.isHover = false, this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random();

    // Use reduced intensity for hover effect
    final baseOpacity = isHover ? 0.03 : 0.08;
    final effectCount = isHover ? 6 : 10;

    // Horizontal distortion lines
    final distortionPaint =
        Paint()
          ..color = Colors.white.withOpacity(isHover ? 0.05 : 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isHover ? 0.8 : 1.5;

    // Fewer distortion lines on hover, more on press
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

    // Digital artifacts (blocky rectangles)
    final glitchPaint = Paint()..style = PaintingStyle.fill;

    // Draw random glitch rectangles
    for (int i = 0; i < effectCount; i++) {
      // Subtler color for hover
      glitchPaint.color = Colors.white.withOpacity(baseOpacity);

      // Smaller artifacts on hover
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

    // Occasional vertical glitch bars only on press (not on hover)
    if (!isHover && random.nextBool()) {
      final verticalGlitchPaint =
          Paint()
            ..color = Colors.white.withOpacity(0.1)
            ..style = PaintingStyle.fill;

      final xPos = random.nextDouble() * size.width;
      final width = random.nextDouble() * 8 + 2;

      canvas.drawRect(
        Rect.fromLTWH(xPos, 0, width, size.height),
        verticalGlitchPaint,
      );
    }

    // Rare animated distortion only on press
    if (!isHover && random.nextDouble() > 0.8) {
      final timeBased = DateTime.now().millisecondsSinceEpoch % 1000 / 1000;
      final distortY = size.height * timeBased;

      canvas.drawLine(
        Offset(0, distortY),
        Offset(size.width, distortY + random.nextDouble() * 4 - 2),
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
