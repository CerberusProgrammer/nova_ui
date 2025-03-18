import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';

/// Types of waveform animations available
enum NovaWaveformType {
  /// Sine wave pattern
  sine,

  /// Audio-like frequency visualization
  audio,

  /// Heartbeat/pulse pattern
  pulse,

  /// Digital signal pattern
  digital,

  /// Static/white noise pattern
  noise,
}

/// A retro-futuristic waveform visualization component
class NovaWaveform extends StatefulWidget {
  /// Width of the waveform
  final double width;

  /// Height of the waveform
  final double height;

  /// Type of waveform to display
  final NovaWaveformType type;

  /// Animation style controlling intensity
  final NovaAnimationStyle animationStyle;

  /// Animation speed multiplier (1.0 = normal)
  final double animationSpeed;

  /// Color of the waveform (uses theme accent if null)
  final Color? waveColor;

  /// Whether to show vertical grid lines
  final bool showVerticalLines;

  /// Whether to show horizontal grid lines
  final bool showHorizontalLines;

  /// Glow intensity (0.0 to 1.0)
  final double glowIntensity;

  /// Number of waves to display (for sine waves)
  final int waveCount;

  /// Line width for the wave
  final double lineWidth;

  /// Whether to show numerical indicators
  final bool showIndicators;

  /// Whether to fill area below the wave
  final bool fillWave;

  /// Custom data points to visualize (overrides animation)
  final List<double>? dataPoints;

  const NovaWaveform({
    super.key,
    this.width = 300.0,
    this.height = 100.0,
    this.type = NovaWaveformType.sine,
    this.animationStyle = NovaAnimationStyle.standard,
    this.animationSpeed = 1.0,
    this.waveColor,
    this.showVerticalLines = true,
    this.showHorizontalLines = true,
    this.glowIntensity = 0.6,
    this.waveCount = 2,
    this.lineWidth = 2.0,
    this.showIndicators = true,
    this.fillWave = false,
    this.dataPoints,
  });

  @override
  State<NovaWaveform> createState() => _NovaWaveformState();
}

class _NovaWaveformState extends State<NovaWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final math.Random _random = math.Random();
  late List<double> _noiseValues;
  late List<double> _audioValues;
  int _animationFrame = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (2000 / widget.animationSpeed).round()),
    );

    _controller.repeat();

    _noiseValues = List.generate(100, (_) => _random.nextDouble() * 2 - 1);

    _generateAudioValues();
  }

  void _generateAudioValues() {
    final int valueCount = 40;
    _audioValues = List.generate(valueCount, (index) {
      if (index < 5) {
        return 0.2 + _random.nextDouble() * 0.3;
      } else if (index < 10) {
        return 0.5 + _random.nextDouble() * 0.4;
      } else if (index < 20) {
        return 0.2 + _random.nextDouble() * 0.7;
      } else if (index < 30) {
        return 0.1 + _random.nextDouble() * 0.3;
      } else {
        return _random.nextDouble() * 0.2;
      }
    });
  }

  @override
  void didUpdateWidget(NovaWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationSpeed != widget.animationSpeed) {
      _controller.duration = Duration(
        milliseconds: (2000 / widget.animationSpeed).round(),
      );
      if (_controller.isAnimating) {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;
    final waveColor = widget.waveColor ?? theme.accent;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (widget.type == NovaWaveformType.audio ||
            widget.type == NovaWaveformType.noise) {
          _animationFrame++;
          if (_animationFrame % 10 == 0) {
            if (widget.type == NovaWaveformType.audio) {
              _generateAudioValues();
            } else {
              _noiseValues = List.generate(
                100,
                (_) => _random.nextDouble() * 2 - 1,
              );
            }
          }
        }

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: waveColor.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: waveColor.withOpacity(0.2 * widget.glowIntensity),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _WaveformPainter(
              type: widget.type,
              animationValue: _controller.value,
              waveColor: waveColor,
              showVerticalLines: widget.showVerticalLines,
              showHorizontalLines: widget.showHorizontalLines,
              glowIntensity: widget.glowIntensity,
              waveCount: widget.waveCount,
              lineWidth: widget.lineWidth,
              showIndicators: widget.showIndicators,
              fillWave: widget.fillWave,
              dataPoints: widget.dataPoints,
              noiseValues: _noiseValues,
              audioValues: _audioValues,
            ),
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final NovaWaveformType type;
  final double animationValue;
  final Color waveColor;
  final bool showVerticalLines;
  final bool showHorizontalLines;
  final double glowIntensity;
  final int waveCount;
  final double lineWidth;
  final bool showIndicators;
  final bool fillWave;
  final List<double>? dataPoints;
  final List<double> noiseValues;
  final List<double> audioValues;

  _WaveformPainter({
    required this.type,
    required this.animationValue,
    required this.waveColor,
    required this.showVerticalLines,
    required this.showHorizontalLines,
    required this.glowIntensity,
    required this.waveCount,
    required this.lineWidth,
    required this.showIndicators,
    required this.fillWave,
    this.dataPoints,
    required this.noiseValues,
    required this.audioValues,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);

    switch (type) {
      case NovaWaveformType.sine:
        _drawSineWave(canvas, size);
        break;
      case NovaWaveformType.audio:
        _drawAudioWave(canvas, size);
        break;
      case NovaWaveformType.pulse:
        _drawPulseWave(canvas, size);
        break;
      case NovaWaveformType.digital:
        _drawDigitalWave(canvas, size);
        break;
      case NovaWaveformType.noise:
        _drawNoiseWave(canvas, size);
        break;
    }

    if (showIndicators) {
      _drawIndicators(canvas, size);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = waveColor.withOpacity(0.2)
          ..strokeWidth = 0.5;

    if (showHorizontalLines) {
      final lineCount = 5;
      final lineSpacing = size.height / lineCount;

      for (int i = 0; i <= lineCount; i++) {
        final y = i * lineSpacing;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    if (showVerticalLines) {
      final lineCount = 10;
      final lineSpacing = size.width / lineCount;

      for (int i = 0; i <= lineCount; i++) {
        final x = i * lineSpacing;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
    }
  }

  void _drawSineWave(Canvas canvas, Size size) {
    final wavePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = waveColor
          ..strokeWidth = lineWidth
          ..strokeCap = StrokeCap.round;

    final path = Path();
    final center = size.height / 2;
    final amplitude = size.height / 3;

    path.moveTo(0, center);

    for (double x = 0; x <= size.width; x++) {
      final progress = x / size.width;
      final offset = animationValue * 2 * math.pi * waveCount;
      final y =
          center +
          math.sin(progress * 2 * math.pi * waveCount + offset) * amplitude;
      path.lineTo(x, y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = waveColor.withOpacity(0.5 * glowIntensity)
        ..strokeWidth = lineWidth + 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawPath(path, wavePaint);

    if (fillWave) {
      final fillPath = Path.from(path);
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();

      canvas.drawPath(
        fillPath,
        Paint()
          ..style = PaintingStyle.fill
          ..color = waveColor.withOpacity(0.1),
      );
    }
  }

  void _drawAudioWave(Canvas canvas, Size size) {
    final barPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = waveColor;

    final barCount = audioValues.length;
    final barWidth = size.width / barCount;
    final maxBarHeight = size.height * 0.8;

    for (int i = 0; i < barCount; i++) {
      double animatedValue = audioValues[i];

      final barPhase = (animationValue * 10 + i / barCount) % 1.0;
      final animationFactor = math.sin(barPhase * math.pi * 2) * 0.2 + 0.8;

      final barHeight = maxBarHeight * animatedValue * animationFactor;
      final x = i * barWidth;
      final y = (size.height - barHeight) / 2;

      canvas.drawRect(
        Rect.fromLTWH(x + 1, y - 2, barWidth - 2, barHeight + 4),
        Paint()
          ..style = PaintingStyle.fill
          ..color = waveColor.withOpacity(0.3 * glowIntensity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      canvas.drawRect(
        Rect.fromLTWH(x + 1, y, barWidth - 2, barHeight),
        barPaint,
      );
    }
  }

  void _drawPulseWave(Canvas canvas, Size size) {
    final wavePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = waveColor
          ..strokeWidth = lineWidth
          ..strokeCap = StrokeCap.round;

    final center = size.height / 2;
    final path = Path();

    path.moveTo(0, center);

    final pulsePosition =
        (animationValue * size.width * 1.5) % (size.width * 2) - size.width / 2;

    path.lineTo(math.max(0, pulsePosition - size.width / 6), center);

    if (pulsePosition > -size.width / 6 && pulsePosition < size.width * 1.1) {
      final pulseStart = math.max(0, pulsePosition - size.width / 6);
      final pulseEnd = math.min(size.width, pulsePosition + size.width / 6);

      final x2 = pulseStart + (pulseEnd - pulseStart) * 0.2;
      final x3 = pulseStart + (pulseEnd - pulseStart) * 0.3;
      final x4 = pulseStart + (pulseEnd - pulseStart) * 0.4;
      final x5 = pulseStart + (pulseEnd - pulseStart) * 0.6;
      final x6 = pulseStart + (pulseEnd - pulseStart) * 0.7;
      final x7 = pulseStart + (pulseEnd - pulseStart) * 0.8;

      final y2 = center - size.height * 0.1;
      final y3 = center - size.height * 0.3;
      final y4 = center + size.height * 0.3;
      final y5 = center - size.height * 0.1;
      final y6 = center + size.height * 0.05;
      final y7 = center;

      path.lineTo(x2, y2);
      path.lineTo(x3, y3);
      path.lineTo(x4, y4);
      path.lineTo(x5, y5);
      path.lineTo(x6, y6);
      path.lineTo(x7, y7);
    }

    path.lineTo(math.min(size.width, pulsePosition + size.width / 6), center);
    path.lineTo(size.width, center);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = waveColor.withOpacity(0.5 * glowIntensity)
        ..strokeWidth = lineWidth + 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    canvas.drawPath(path, wavePaint);
  }

  void _drawDigitalWave(Canvas canvas, Size size) {
    final wavePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = waveColor
          ..strokeWidth = lineWidth
          ..strokeCap = StrokeCap.round;

    final path = Path();
    final center = size.height / 2;
    final amplitude = size.height / 3;

    path.moveTo(0, center - amplitude * (animationValue < 0.5 ? 1 : -1));

    final segments = 8;
    final segmentWidth = size.width / segments;

    for (int i = 0; i <= segments; i++) {
      final segStart = i * segmentWidth;
      final isHigh = (i + (animationValue * segments).toInt()) % 2 == 0;
      final y = center - amplitude * (isHigh ? 1 : -1);

      if (i > 0) {
        path.lineTo(segStart, path.getBounds().bottom);
      }

      path.lineTo(segStart, y);

      if (i < segments) {
        path.lineTo(segStart + segmentWidth, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = waveColor.withOpacity(0.4 * glowIntensity)
        ..strokeWidth = lineWidth + 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    canvas.drawPath(path, wavePaint);

    if (fillWave) {
      final fillPath = Path.from(path);
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();

      canvas.drawPath(
        fillPath,
        Paint()
          ..style = PaintingStyle.fill
          ..color = waveColor.withOpacity(0.05),
      );
    }

    for (int i = 1; i < segments; i++) {
      final x = i * segmentWidth;
      canvas.drawLine(
        Offset(x, center - amplitude - 5),
        Offset(x, center + amplitude + 5),
        Paint()
          ..color = waveColor.withOpacity(0.3)
          ..strokeWidth = 1,
      );
    }
  }

  void _drawNoiseWave(Canvas canvas, Size size) {
    final noisePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = waveColor
          ..strokeWidth = lineWidth
          ..strokeCap = StrokeCap.round;

    final path = Path();
    final center = size.height / 2;
    final amplitude = size.height * 0.4;

    path.moveTo(0, center + noiseValues[0] * amplitude);

    final pointCount = math.min(size.width.toInt(), noiseValues.length);
    final xStep = size.width / pointCount;

    for (int i = 1; i < pointCount; i++) {
      final x = i * xStep;
      final noiseValue = noiseValues[i];
      final y = center + noiseValue * amplitude;
      path.lineTo(x, y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = waveColor.withOpacity(0.3 * glowIntensity)
        ..strokeWidth = lineWidth + 1
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    canvas.drawPath(path, noisePaint);

    if (fillWave) {
      final fillPath = Path.from(path);
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();

      canvas.drawPath(
        fillPath,
        Paint()
          ..style = PaintingStyle.fill
          ..color = waveColor.withOpacity(0.05),
      );
    }

    for (int i = 0; i < 20; i++) {
      final x = math.Random().nextDouble() * size.width;
      final y = math.Random().nextDouble() * size.height;
      canvas.drawCircle(
        Offset(x, y),
        math.Random().nextDouble() * 1.5,
        Paint()..color = waveColor.withOpacity(0.5),
      );
    }
  }

  void _drawIndicators(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: waveColor,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    final verticalMarkings = 5;
    final verticalStep = size.height / verticalMarkings;

    for (int i = 0; i <= verticalMarkings; i++) {
      final y = i * verticalStep;
      final value = (verticalMarkings - i) * 20;

      final textSpan = TextSpan(text: value.toString(), style: textStyle);

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: 20);
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }

    final time = (animationValue * 60).round();
    final timeSpan = TextSpan(
      text: "T+$time",
      style: textStyle.copyWith(fontSize: 12),
    );

    final timePainter = TextPainter(
      text: timeSpan,
      textDirection: TextDirection.ltr,
    );

    timePainter.layout(minWidth: 0, maxWidth: 50);
    timePainter.paint(canvas, Offset(size.width - timePainter.width - 5, 5));

    final typeText = type.toString().split('.').last.toUpperCase();
    final typeSpan = TextSpan(
      text: typeText,
      style: textStyle.copyWith(fontSize: 9),
    );

    final typePainter = TextPainter(
      text: typeSpan,
      textDirection: TextDirection.ltr,
    );

    typePainter.layout(minWidth: 0, maxWidth: 50);
    typePainter.paint(
      canvas,
      Offset(
        size.width - typePainter.width - 5,
        size.height - typePainter.height - 5,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
