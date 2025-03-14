import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircuitPatternPainter extends CustomPainter {
  final Color color;
  final int patternDensity;

  CircuitPatternPainter({required this.color, this.patternDensity = 10});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    final random = math.Random(42); // Fixed seed for consistent pattern

    // Create nodes
    final nodes = <Offset>[];
    for (int i = 0; i < patternDensity; i++) {
      nodes.add(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
      );
    }

    // Draw circuit lines
    for (int i = 0; i < nodes.length; i++) {
      // Connect each node to 1-3 other nodes
      final connections = 1 + random.nextInt(2);
      for (int j = 0; j < connections; j++) {
        final targetIndex =
            (i + 1 + random.nextInt(nodes.length - 1)) % nodes.length;

        // Draw path with kinks/angles like a circuit
        final path = Path();
        path.moveTo(nodes[i].dx, nodes[i].dy);

        if (random.nextBool()) {
          // Horizontal then vertical
          path.lineTo(nodes[targetIndex].dx, nodes[i].dy);
          path.lineTo(nodes[targetIndex].dx, nodes[targetIndex].dy);
        } else {
          // Vertical then horizontal
          path.lineTo(nodes[i].dx, nodes[targetIndex].dy);
          path.lineTo(nodes[targetIndex].dx, nodes[targetIndex].dy);
        }

        canvas.drawPath(path, paint);
      }

      // Draw node points
      canvas.drawCircle(nodes[i], 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
