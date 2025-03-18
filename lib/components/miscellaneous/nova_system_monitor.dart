import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';

/// A retro-futuristic system monitor component
class NovaSystemMonitor extends StatefulWidget {
  /// Width of the monitor
  final double width;

  /// Height of the monitor
  final double height;

  /// Animation style controlling intensity
  final NovaAnimationStyle animationStyle;

  /// Animation speed multiplier (1.0 = normal)
  final double animationSpeed;

  /// Color of the monitor elements (uses theme accent if null)
  final Color? monitorColor;

  /// Glow intensity (0.0 to 1.0)
  final double glowIntensity;

  /// Number of resource bars to display
  final int resourceCount;

  /// Whether to show scan lines effect
  final bool scanLines;

  /// Whether to show a title
  final bool showTitle;

  /// Custom title text
  final String? title;

  const NovaSystemMonitor({
    super.key,
    this.width = 300.0,
    this.height = 150.0,
    this.animationStyle = NovaAnimationStyle.standard,
    this.animationSpeed = 1.0,
    this.monitorColor,
    this.glowIntensity = 0.7,
    this.resourceCount = 4,
    this.scanLines = true,
    this.showTitle = true,
    this.title,
  });

  @override
  State<NovaSystemMonitor> createState() => _NovaSystemMonitorState();
}

class _NovaSystemMonitorState extends State<NovaSystemMonitor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_SystemResource> _resources;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (5000 / widget.animationSpeed).round()),
    );

    _controller.repeat();
    _generateResources();
  }

  void _generateResources() {
    final resourceTypes = [
      'CPU',
      'MEM',
      'GPU',
      'NET',
      'DSK',
      'PWR',
      'THR',
      'BUS',
    ];

    _resources = List.generate(
      widget.resourceCount,
      (index) => _SystemResource(
        name: resourceTypes[index % resourceTypes.length],
        baseValue: 0.2 + _random.nextDouble() * 0.4,
        fluctuation: 0.05 + _random.nextDouble() * 0.2,
        speed: 0.5 + _random.nextDouble() * 2,
        criticalThreshold: 0.9,
        warningThreshold: 0.7,
      ),
    );
  }

  @override
  void didUpdateWidget(NovaSystemMonitor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.resourceCount != widget.resourceCount) {
      _generateResources();
    }

    if (oldWidget.animationSpeed != widget.animationSpeed) {
      _controller.duration = Duration(
        milliseconds: (5000 / widget.animationSpeed).round(),
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
    final monitorColor = widget.monitorColor ?? theme.accent;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Update resource values based on animation
        for (final resource in _resources) {
          final phase = (_controller.value * resource.speed) % 1.0;
          resource.currentValue =
              resource.baseValue +
              math.sin(phase * math.pi * 2) * resource.fluctuation;

          // Ensure value is within bounds
          resource.currentValue = resource.currentValue.clamp(0.05, 1.0);
        }

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: monitorColor.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: monitorColor.withOpacity(0.2 * widget.glowIntensity),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _SystemMonitorPainter(
              resources: _resources,
              monitorColor: monitorColor,
              glowIntensity: widget.glowIntensity,
              scanLines: widget.scanLines,
              animationValue: _controller.value,
              showTitle: widget.showTitle,
              title: widget.title,
            ),
          ),
        );
      },
    );
  }
}

class _SystemResource {
  final String name;
  final double baseValue;
  final double fluctuation;
  final double speed;
  final double criticalThreshold;
  final double warningThreshold;
  double currentValue;

  _SystemResource({
    required this.name,
    required this.baseValue,
    required this.fluctuation,
    required this.speed,
    required this.criticalThreshold,
    required this.warningThreshold,
  }) : currentValue = baseValue;
}

class _SystemMonitorPainter extends CustomPainter {
  final List<_SystemResource> resources;
  final Color monitorColor;
  final double glowIntensity;
  final bool scanLines;
  final double animationValue;
  final bool showTitle;
  final String? title;

  _SystemMonitorPainter({
    required this.resources,
    required this.monitorColor,
    required this.glowIntensity,
    required this.scanLines,
    required this.animationValue,
    required this.showTitle,
    this.title,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: monitorColor,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    // Draw background grid
    _drawGrid(canvas, size);

    // Draw scanlines if enabled
    if (scanLines) {
      _drawScanLines(canvas, size);
    }

    // Draw title
    if (showTitle) {
      final titleText = title ?? 'SYSTEM RESOURCES';
      final titleSpan = TextSpan(
        text: titleText,
        style: textStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
      );

      final titlePainter = TextPainter(
        text: titleSpan,
        textDirection: TextDirection.ltr,
      );

      titlePainter.layout();
      titlePainter.paint(canvas, Offset(10, 10));

      // Draw separator line under title
      canvas.drawLine(
        Offset(10, 26),
        Offset(size.width - 10, 26),
        Paint()
          ..color = monitorColor.withOpacity(0.3)
          ..strokeWidth = 1,
      );
    }

    // Draw timestamp
    final now = DateTime.now();
    final timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    final timeSpan = TextSpan(
      text: timestamp,
      style: textStyle.copyWith(fontSize: 10),
    );

    final timePainter = TextPainter(
      text: timeSpan,
      textDirection: TextDirection.ltr,
    );

    timePainter.layout();
    timePainter.paint(canvas, Offset(size.width - timePainter.width - 10, 10));

    // Draw resource bars
    final barStartY = showTitle ? 40 : 20;
    final barHeight = 18.0;
    final barSpacing = 8.0;
    final maxBarWidth = size.width - 80;

    for (int i = 0; i < resources.length; i++) {
      final resource = resources[i];
      final y = barStartY + i * (barHeight + barSpacing);

      // Draw resource name
      final nameSpan = TextSpan(text: resource.name, style: textStyle);

      final namePainter = TextPainter(
        text: nameSpan,
        textDirection: TextDirection.ltr,
      );

      namePainter.layout();
      namePainter.paint(
        canvas,
        Offset(10, y + (barHeight - namePainter.height) / 2),
      );

      // Draw bar background
      final barRect = Rect.fromLTWH(50, y, maxBarWidth, barHeight);
      canvas.drawRect(
        barRect,
        Paint()
          ..color = monitorColor.withOpacity(0.1)
          ..style = PaintingStyle.fill,
      );

      // Draw bar value
      final valueWidth = resource.currentValue * maxBarWidth;
      final valueRect = Rect.fromLTWH(50, y, valueWidth, barHeight);

      // Choose color based on threshold
      Color barColor = monitorColor;
      if (resource.currentValue >= resource.criticalThreshold) {
        barColor = Colors.red;
      } else if (resource.currentValue >= resource.warningThreshold) {
        barColor = Colors.orange;
      }

      // Draw bar glow
      canvas.drawRect(
        valueRect.inflate(2),
        Paint()
          ..color = barColor.withOpacity(0.3 * glowIntensity)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3),
      );

      // Draw bar
      canvas.drawRect(
        valueRect,
        Paint()
          ..color = barColor
          ..style = PaintingStyle.fill,
      );

      // Draw percentage text
      final percentage = (resource.currentValue * 100).toInt().toString() + '%';
      final percentSpan = TextSpan(
        text: percentage,
        style: textStyle.copyWith(color: Colors.white),
      );

      final percentPainter = TextPainter(
        text: percentSpan,
        textDirection: TextDirection.ltr,
      );

      percentPainter.layout();
      percentPainter.paint(
        canvas,
        Offset(
          55 + valueWidth - percentPainter.width - 5,
          y + (barHeight - percentPainter.height) / 2,
        ),
      );
    }

    // Draw blinking indicator
    if ((animationValue * 2).floor() % 2 == 0) {
      canvas.drawCircle(
        Offset(size.width - 15, size.height - 15),
        4,
        Paint()..color = monitorColor,
      );
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint =
        Paint()
          ..color = monitorColor.withOpacity(0.1)
          ..strokeWidth = 0.5;

    // Vertical lines
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawScanLines(Canvas canvas, Size size) {
    final scanPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.03)
          ..style = PaintingStyle.fill;

    for (double y = 0; y < size.height; y += 2) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), scanPaint);
    }

    // Moving scan line effect
    final scanY = (animationValue * size.height * 2) % (size.height * 2);
    if (scanY < size.height) {
      canvas.drawRect(
        Rect.fromLTWH(0, scanY, size.width, 2),
        Paint()..color = Colors.white.withOpacity(0.1),
      );
    }
  }

  @override
  bool shouldRepaint(_SystemMonitorPainter oldDelegate) => true;
}
