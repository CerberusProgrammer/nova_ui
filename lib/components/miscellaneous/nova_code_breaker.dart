import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';

/// A cyberpunk-style code breaking/decryption visualization
class NovaCodeBreaker extends StatefulWidget {
  /// Width of the component
  final double width;

  /// Height of the component
  final double height;

  /// Primary color for the display (uses theme accent if null)
  final Color? codeColor;

  /// Animation style controlling intensity
  final NovaAnimationStyle animationStyle;

  /// Animation speed multiplier (1.0 = normal)
  final double animationSpeed;

  /// Glow intensity (0.0 to 1.0)
  final double glowIntensity;

  /// Number of code rows to display
  final int codeRows;

  /// Number of digits per row
  final int digitsPerRow;

  /// Whether to show scan lines effect
  final bool scanLines;

  /// Whether to show column labels
  final bool showLabels;

  /// Custom title text (null for default)
  final String? title;

  const NovaCodeBreaker({
    super.key,
    this.width = 300.0,
    this.height = 200.0,
    this.codeColor,
    this.animationStyle = NovaAnimationStyle.standard,
    this.animationSpeed = 1.0,
    this.glowIntensity = 0.7,
    this.codeRows = 8,
    this.digitsPerRow = 16,
    this.scanLines = true,
    this.showLabels = true,
    this.title,
  });

  @override
  State<NovaCodeBreaker> createState() => _NovaCodeBreakerState();
}

class _NovaCodeBreakerState extends State<NovaCodeBreaker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_CodeRow> _codeRows;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (10000 / widget.animationSpeed).round()),
    );
    _controller.repeat();
    _generateCodeRows();
  }

  void _generateCodeRows() {
    _codeRows = List.generate(
      widget.codeRows,
      (index) => _CodeRow(
        digits: List.generate(
          widget.digitsPerRow,
          (i) => _CodeDigit(
            originalValue: _random.nextInt(10).toString(),
            targetValue: _random.nextInt(10).toString(),
            decryptionSpeed: 0.2 + _random.nextDouble() * 0.8,
            decryptionDelay: _random.nextDouble() * 0.7,
            isHighlighted: _random.nextDouble() < 0.1,
          ),
        ),
        label:
            '0x${_random.nextInt(0xFFFF).toRadixString(16).padLeft(4, '0').toUpperCase()}',
        decryptionProgress: _random.nextDouble() * 0.3,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;
    final codeColor = widget.codeColor ?? theme.accent;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: codeColor.withOpacity(0.6), width: 1),
        boxShadow: [
          BoxShadow(
            color: codeColor.withOpacity(0.2 * widget.glowIntensity),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background grid (optional)
          CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _GridPainter(
              gridColor: codeColor.withOpacity(0.1),
              gridSpacing: 20.0,
            ),
          ),
          // Scanlines effect
          if (widget.scanLines)
            CustomPaint(
              size: Size(widget.width, widget.height),
              painter: _ScanLinePainter(
                scanLineOpacity: 0.05,
                animationValue: _controller.value,
              ),
            ),
          // Main code breaker visualization
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: _CodeBreakerPainter(
                  codeRows: _codeRows,
                  codeColor: codeColor,
                  animationValue: _controller.value,
                  glowIntensity: widget.glowIntensity,
                  showLabels: widget.showLabels,
                  title: widget.title ?? 'DECRYPTION IN PROGRESS',
                  animationStyle: widget.animationStyle,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CodeRow {
  final List<_CodeDigit> digits;
  final String label;
  final double decryptionProgress;

  _CodeRow({
    required this.digits,
    required this.label,
    required this.decryptionProgress,
  });
}

class _CodeDigit {
  final String originalValue;
  final String targetValue;
  final double decryptionSpeed;
  final double decryptionDelay;
  final bool isHighlighted;
  bool isDecrypted = false;

  _CodeDigit({
    required this.originalValue,
    required this.targetValue,
    required this.decryptionSpeed,
    required this.decryptionDelay,
    required this.isHighlighted,
  });

  String getCurrentValue(double animationValue) {
    final adjustedAnimation =
        (animationValue - decryptionDelay) * decryptionSpeed;

    if (adjustedAnimation <= 0) {
      return originalValue;
    }

    if (adjustedAnimation >= 1.0) {
      isDecrypted = true;
      return targetValue;
    }
    isDecrypted = false;
    if ((adjustedAnimation * 10).floor() % 2 == 0) {
      return math.Random().nextInt(10).toString();
    } else {
      return originalValue;
    }
  }
}

class _CodeBreakerPainter extends CustomPainter {
  final List<_CodeRow> codeRows;
  final Color codeColor;
  final double animationValue;
  final double glowIntensity;
  final bool showLabels;
  final String title;
  final NovaAnimationStyle animationStyle;

  _CodeBreakerPainter({
    required this.codeRows,
    required this.codeColor,
    required this.animationValue,
    required this.glowIntensity,
    required this.showLabels,
    required this.title,
    required this.animationStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawTitle(canvas, size);
    _drawProgressBar(canvas, size);

    final rowHeight = (size.height - 50) / codeRows.length;
    final digitWidth =
        (size.width - (showLabels ? 70 : 20)) / codeRows[0].digits.length;

    for (int rowIndex = 0; rowIndex < codeRows.length; rowIndex++) {
      final row = codeRows[rowIndex];
      final y = 40 + rowIndex * rowHeight;

      if (showLabels) {
        final labelStyle = TextStyle(
          color: codeColor.withOpacity(0.8),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        );

        final labelSpan = TextSpan(text: row.label, style: labelStyle);

        final labelPainter = TextPainter(
          text: labelSpan,
          textDirection: TextDirection.ltr,
        );

        labelPainter.layout();
        labelPainter.paint(
          canvas,
          Offset(10, y + (rowHeight - labelPainter.height) / 2),
        );
      }

      final animationMultiplier =
          animationStyle == NovaAnimationStyle.dramatic
              ? 1.5
              : animationStyle == NovaAnimationStyle.subtle
              ? 0.7
              : 1.0;

      final rowProgress =
          (animationValue * animationMultiplier - 0.1 * rowIndex) * 1.3;

      for (int digitIndex = 0; digitIndex < row.digits.length; digitIndex++) {
        final digit = row.digits[digitIndex];
        final x = (showLabels ? 60 : 10) + digitIndex * digitWidth;

        final digitProgress = rowProgress - 0.03 * digitIndex;
        final currentValue = digit.getCurrentValue(digitProgress);

        Color digitColor;
        double fontSize;
        FontWeight fontWeight;

        if (digit.isDecrypted) {
          digitColor = codeColor.withOpacity(0.9);
          fontSize = 14;
          fontWeight = FontWeight.bold;
        } else if (digitProgress > 0 && digitProgress < 1.0) {
          digitColor = codeColor;
          fontSize = 14;
          fontWeight = FontWeight.bold;
        } else {
          digitColor = codeColor.withOpacity(0.6);
          fontSize = 12;
          fontWeight = FontWeight.normal;
        }
        if (digit.isHighlighted && digit.isDecrypted) {
          if (glowIntensity > 0) {
            final glowText = TextSpan(
              text: currentValue,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8 * glowIntensity),
                fontSize: fontSize + 1,
                fontWeight: fontWeight,
              ),
            );

            final glowPainter = TextPainter(
              text: glowText,
              textDirection: TextDirection.ltr,
            );

            glowPainter.layout();

            for (double blur = 4; blur > 0; blur -= 1) {
              canvas.saveLayer(
                Rect.fromLTWH(
                  x - 10,
                  y - 10,
                  glowPainter.width + 20,
                  glowPainter.height + 20,
                ),
                Paint(),
              );

              glowPainter.paint(canvas, Offset(x, y));

              canvas.restore();
            }
          }

          digitColor = Colors.white;
        }

        final digitStyle = TextStyle(
          color: digitColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );

        final digitSpan = TextSpan(text: currentValue, style: digitStyle);

        final digitPainter = TextPainter(
          text: digitSpan,
          textDirection: TextDirection.ltr,
        );

        digitPainter.layout();
        digitPainter.paint(canvas, Offset(x, y));
      }
    }

    _drawCursor(canvas, size);
  }

  void _drawTitle(Canvas canvas, Size size) {
    final titleStyle = TextStyle(
      color: codeColor,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    final titleSpan = TextSpan(text: title, style: titleStyle);

    final titlePainter = TextPainter(
      text: titleSpan,
      textDirection: TextDirection.ltr,
    );

    titlePainter.layout();
    titlePainter.paint(
      canvas,
      Offset((size.width - titlePainter.width) / 2, 10),
    );

    canvas.drawLine(
      Offset(10, 30),
      Offset(size.width - 10, 30),
      Paint()
        ..color = codeColor.withOpacity(0.5)
        ..strokeWidth = 1.0,
    );
  }

  void _drawProgressBar(Canvas canvas, Size size) {
    final progressBarWidth = size.width - 20;
    final progressBarHeight = 3.0;
    final progressBarY = size.height - 15;

    canvas.drawRect(
      Rect.fromLTWH(10, progressBarY, progressBarWidth, progressBarHeight),
      Paint()
        ..color = codeColor.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );

    final progress = (animationValue % 1.0) * progressBarWidth;
    canvas.drawRect(
      Rect.fromLTWH(10, progressBarY, progress, progressBarHeight),
      Paint()
        ..color = codeColor
        ..style = PaintingStyle.fill,
    );

    final percentage = ((animationValue % 1.0) * 100).toInt();
    final percentText = '$percentage%';
    final percentStyle = TextStyle(
      color: codeColor,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

    final percentSpan = TextSpan(text: percentText, style: percentStyle);

    final percentPainter = TextPainter(
      text: percentSpan,
      textDirection: TextDirection.ltr,
    );

    percentPainter.layout();
    percentPainter.paint(
      canvas,
      Offset(size.width - percentPainter.width - 10, progressBarY - 15),
    );
  }

  void _drawCursor(Canvas canvas, Size size) {
    if ((animationValue * 2).floor() % 2 == 0) {
      final cursorY = size.height - 25;
      canvas.drawRect(
        Rect.fromLTWH(size.width - 20, cursorY, 8, 2),
        Paint()..color = codeColor,
      );
    }
  }

  @override
  bool shouldRepaint(_CodeBreakerPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class _GridPainter extends CustomPainter {
  final Color gridColor;
  final double gridSpacing;

  _GridPainter({required this.gridColor, required this.gridSpacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = gridColor
          ..strokeWidth = 0.5;

    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

class _ScanLinePainter extends CustomPainter {
  final double scanLineOpacity;
  final double animationValue;

  _ScanLinePainter({
    required this.scanLineOpacity,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scanPaint =
        Paint()
          ..color = Colors.white.withOpacity(scanLineOpacity)
          ..style = PaintingStyle.fill;

    for (double y = 0; y < size.height; y += 2) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), scanPaint);
    }

    final scanY = (animationValue * size.height * 2) % (size.height * 2);
    if (scanY < size.height) {
      canvas.drawRect(
        Rect.fromLTWH(0, scanY, size.width, 2),
        Paint()..color = Colors.white.withOpacity(0.1),
      );
    }
  }

  @override
  bool shouldRepaint(_ScanLinePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
