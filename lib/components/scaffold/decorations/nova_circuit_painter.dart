import 'dart:math' as math;
import 'package:flutter/material.dart';

class NovaCircuitPainter extends CustomPainter {
  final Color color;
  final double density;
  final int seed;

  NovaCircuitPainter({required this.color, this.density = 0.5, this.seed = 42});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    final nodeCount = (size.width * size.height * 0.0003 * density)
        .toInt()
        .clamp(5, 20);
    final nodes = List.generate(nodeCount, (_) {
      return Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
    });

    for (final node in nodes) {
      canvas.drawCircle(node, 2, paint);
      final connections = random.nextInt(3) + 1;
      for (int i = 0; i < connections; i++) {
        final targetNode = nodes[random.nextInt(nodes.length)];
        final path = Path();

        if (random.nextBool()) {
          path.moveTo(node.dx, node.dy);
          path.lineTo(targetNode.dx, targetNode.dy);
        } else {
          path.moveTo(node.dx, node.dy);
          if (random.nextBool()) {
            path.lineTo(node.dx, targetNode.dy);
            path.lineTo(targetNode.dx, targetNode.dy);
          } else {
            path.lineTo(targetNode.dx, node.dy);
            path.lineTo(targetNode.dx, targetNode.dy);
          }
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(NovaCircuitPainter oldDelegate) =>
      oldDelegate.density != density;
}
