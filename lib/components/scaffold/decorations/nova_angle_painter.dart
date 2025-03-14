import 'package:flutter/material.dart';

class NovaAnglePainter extends CustomPainter {
  final Color color;

  NovaAnglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final path =
        Path()
          ..moveTo(0, size.height * 0.4)
          ..lineTo(0, 0)
          ..lineTo(size.width * 0.4, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
