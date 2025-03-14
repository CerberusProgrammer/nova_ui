import 'package:flutter/material.dart';

/// Painter for animated dashed border effect
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;
  final List<double> dashOffset;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashPattern,
    required this.dashOffset,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rect);

    // Create the dash effect with offset for animation
    final dashArray = <double>[];
    final dashCount = (dashPattern.length / 2).ceil();

    for (int i = 0; i < dashCount; i++) {
      dashArray.add(dashPattern[i * 2]); // dash
      dashArray.add(
        dashPattern[i * 2 + 1 >= dashPattern.length ? 0 : i * 2 + 1],
      ); // gap
    }

    // Apply dash offset for animation
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      var distance = 0.0;
      final totalLength = metric.length;
      var needsDraw = true;

      // Apply the offset for animation
      distance += dashOffset[0] % (dashArray[0] + dashArray[1]);

      while (distance < totalLength) {
        final dashLength = dashArray[needsDraw ? 0 : 1];
        final remaining = totalLength - distance;
        final toDraw = dashLength > remaining ? remaining : dashLength;

        if (needsDraw && toDraw > 0) {
          canvas.drawPath(
            metric.extractPath(distance, distance + toDraw),
            paint,
          );
        }

        distance += toDraw;
        needsDraw = !needsDraw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      dashOffset != oldDelegate.dashOffset ||
      borderRadius != oldDelegate.borderRadius;
}
