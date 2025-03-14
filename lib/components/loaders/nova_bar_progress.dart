import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';
import 'package:nova_ui/components/buttons/nova_border_style.dart';
import 'package:nova_ui/components/effects/glitch_effect_painter.dart';
import 'package:nova_ui/components/effects/nova_bar_loading_effect.dart';
import 'package:nova_ui/components/effects/scan_line_painter.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';

/// A retro-futuristic segmented progress bar that fills with bars as progress increases
class NovaBarProgress extends StatefulWidget {
  /// Current progress value from 0.0 to 1.0
  final double value;

  /// Number of bar segments
  final int barCount;

  /// Height of the progress bar
  final double height;

  /// Width of the progress bar (null for parent width)
  final double? width;

  /// Space between bars
  final double barSpacing;

  /// Duration for the progress animation
  final Duration animationDuration;

  /// Border radius for the container and bars
  final double borderRadius;

  /// Glow intensity for active bars
  final double? glowIntensity;

  /// Whether to add a pulsing effect to active bars
  final bool pulseEffect;

  /// Whether to show scan lines effect
  final bool scanLines;

  /// Animation style controlling intensity
  final NovaAnimationStyle animationStyle;

  /// Color for active bars (uses theme if null)
  final Color? activeColor;

  /// Color for inactive bars (uses theme if null)
  final Color? inactiveColor;

  /// Background colors for gradient
  final List<Color>? backgroundColors;

  /// Border style of the container
  final NovaBorderStyle borderStyle;

  /// Border width
  final double? borderWidth;

  /// Effect for the loading animation
  final NovaBarLoadingEffect loadingEffect;

  /// Text label to display (optional)
  final String? textLabel;

  /// Whether to show percentage text
  final bool showPercentage;

  /// Whether to display a glitch effect on bars
  final bool glitchEffect;

  /// Whether to animate even when progress is static
  final bool idleAnimations;

  /// Animation speed multiplier
  final double animationSpeed;

  /// Thickness ratio of bars (0.0 to 1.0)
  final double barThickness;

  const NovaBarProgress({
    super.key,
    required this.value,
    this.barCount = 12,
    this.height = 30.0,
    this.width,
    this.barSpacing = 4.0,
    this.animationDuration = const Duration(milliseconds: 400),
    this.borderRadius = 4.0,
    this.glowIntensity,
    this.pulseEffect = true,
    this.scanLines = true,
    this.animationStyle = NovaAnimationStyle.standard,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColors,
    this.borderStyle = NovaBorderStyle.none,
    this.borderWidth = 2.0,
    this.loadingEffect = NovaBarLoadingEffect.sequential,
    this.textLabel,
    this.showPercentage = false,
    this.glitchEffect = true,
    this.idleAnimations = true,
    this.animationSpeed = 1.0,
    this.barThickness = 0.8,
  });

  @override
  State<NovaBarProgress> createState() => _NovaBarProgressState();
}

class _NovaBarProgressState extends State<NovaBarProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _barOpacities = [];
  double _pulseValue = 1.0;
  double _scanPosition = 0.0;
  int _glitchBarIndex = -1;
  Timer? _animationTimer;
  late List<int> _barOrder;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds:
            (widget.animationDuration.inMilliseconds / widget.animationSpeed)
                .round(),
      ),
    );

    _initializeBarOpacities();
    _initializeBarOrder();
    _startAnimations();

    _updateProgress(widget.value);
  }

  void _initializeBarOpacities() {
    _barOpacities.clear();
    for (int i = 0; i < widget.barCount; i++) {
      _barOpacities.add(0.3);
    }
  }

  void _initializeBarOrder() {
    _barOrder = List.generate(widget.barCount, (index) => index);

    switch (widget.loadingEffect) {
      case NovaBarLoadingEffect.random:
        _barOrder.shuffle();
        break;
      case NovaBarLoadingEffect.fromCenter:
        final List<int> newOrder = [];
        final int mid = widget.barCount ~/ 2;
        int left = mid - 1;
        int right = widget.barCount % 2 == 0 ? mid : mid + 1;

        newOrder.add(mid);
        while (left >= 0 || right < widget.barCount) {
          if (left >= 0) newOrder.add(left--);
          if (right < widget.barCount) newOrder.add(right++);
        }
        _barOrder = newOrder;
        break;
      case NovaBarLoadingEffect.fromEnds:
        final List<int> newOrder = [];
        int left = 0;
        int right = widget.barCount - 1;

        while (left <= right) {
          newOrder.add(left++);
          if (left <= right) newOrder.add(right--);
        }
        _barOrder = newOrder;
        break;
      case NovaBarLoadingEffect.digital:
        break;
      case NovaBarLoadingEffect.terminal:
        break;
      case NovaBarLoadingEffect.sequential:
        break;
    }
  }

  void _updateProgress(double value) {
    final int totalBarsToFill = (value * widget.barCount).round();

    for (int i = 0; i < widget.barCount; i++) {
      if (i < totalBarsToFill) {
        switch (widget.loadingEffect) {
          case NovaBarLoadingEffect.digital:
            final bool shouldFill = _digitalPatternForBar(i, value);
            _barOpacities[i] = shouldFill ? 1.0 : 0.3;
            break;
          case NovaBarLoadingEffect.terminal:
            if (_barOrder.indexOf(i) < totalBarsToFill) {
              _barOpacities[i] = 1.0;
            } else {
              _barOpacities[i] = 0.3;
            }
            break;
          default:
            int orderIndex = _barOrder.indexOf(i);
            if (orderIndex < totalBarsToFill) {
              _barOpacities[i] = 1.0;
            } else {
              _barOpacities[i] = 0.3;
            }
        }
      } else {
        _barOpacities[i] = 0.3;
      }
    }

    setState(() {});
  }

  bool _digitalPatternForBar(int index, double progress) {
    final int binaryPattern = ((progress * 100).toInt() + index) % 5;
    return binaryPattern < 3 && index < (progress * widget.barCount);
  }

  void _startAnimations() {
    _animationTimer?.cancel();

    if (widget.idleAnimations) {
      _animationTimer = Timer.periodic(Duration(milliseconds: 50), (_) {
        if (!mounted) return;

        setState(() {
          if (widget.pulseEffect) {
            _pulseValue =
                1.0 +
                0.1 * math.sin(DateTime.now().millisecondsSinceEpoch / 500);
          }

          if (widget.scanLines) {
            _scanPosition =
                (_scanPosition + 0.03 * widget.animationSpeed) % 1.0;
          }

          if (widget.glitchEffect && math.Random().nextDouble() > 0.92) {
            _glitchBarIndex = math.Random().nextInt(widget.barCount);
            Future.delayed(Duration(milliseconds: 100), () {
              if (mounted) {
                setState(() {
                  _glitchBarIndex = -1;
                });
              }
            });
          }

          if (widget.loadingEffect == NovaBarLoadingEffect.terminal) {
            final int filledBars = (widget.value * widget.barCount).round();
            for (int i = 0; i < widget.barCount; i++) {
              if (i < filledBars) {
                if (math.Random().nextDouble() > 0.92) {
                  _barOpacities[i] = 0.7 + (0.3 * math.Random().nextDouble());
                } else {
                  _barOpacities[i] = 1.0;
                }
              }
            }
          }
        });
      });
    }
  }

  @override
  void didUpdateWidget(NovaBarProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _updateProgress(widget.value);
    }

    if (oldWidget.barCount != widget.barCount) {
      _initializeBarOpacities();
      _initializeBarOrder();
      _updateProgress(widget.value);
    }

    if (oldWidget.animationSpeed != widget.animationSpeed) {
      _controller.duration = Duration(
        milliseconds:
            (widget.animationDuration.inMilliseconds / widget.animationSpeed)
                .round(),
      );
    }

    if (oldWidget.idleAnimations != widget.idleAnimations ||
        oldWidget.loadingEffect != widget.loadingEffect) {
      _startAnimations();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final novaTheme = context.novaTheme;

    final effectiveActiveColor = widget.activeColor ?? novaTheme.primary;
    final effectiveInactiveColor =
        widget.inactiveColor ?? novaTheme.divider.withOpacity(0.3);

    final effectiveGlowIntensity =
        widget.glowIntensity ?? novaTheme.glowIntensity;

    final List<Color> backgroundColors =
        widget.backgroundColors ??
        [novaTheme.surface.withOpacity(0.8), novaTheme.surface];

    BoxBorder? containerBorder;
    switch (widget.borderStyle) {
      case NovaBorderStyle.solid:
        containerBorder = Border.all(
          color: novaTheme.divider,
          width: widget.borderWidth ?? 2.0,
        );
        break;
      case NovaBorderStyle.double:
        containerBorder = Border(
          top: BorderSide(
            color: novaTheme.divider,
            width: widget.borderWidth ?? 2.0,
          ),
          left: BorderSide(
            color: novaTheme.divider,
            width: widget.borderWidth ?? 2.0,
          ),
          right: BorderSide(
            color: novaTheme.divider.withOpacity(0.7),
            width: widget.borderWidth ?? 2.0,
          ),
          bottom: BorderSide(
            color: novaTheme.divider.withOpacity(0.7),
            width: widget.borderWidth ?? 2.0,
          ),
        );
        break;
      case NovaBorderStyle.dashed:
        containerBorder = null;
        break;
      case NovaBorderStyle.glow:
        containerBorder = Border.all(
          color: novaTheme.glow.withOpacity(0.5),
          width: widget.borderWidth ?? 2.0,
        );
        break;
      case NovaBorderStyle.none:
        containerBorder = null;
    }

    final double totalBarSpace = widget.width ?? double.infinity;
    final double barWidth =
        widget.width == null
            ? (MediaQuery.of(context).size.width -
                    ((widget.barCount - 1) * widget.barSpacing)) /
                widget.barCount
            : (totalBarSpace - ((widget.barCount - 1) * widget.barSpacing)) /
                widget.barCount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.textLabel != null || widget.showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.textLabel != null)
                  Text(
                    widget.textLabel!,
                    style: novaTheme.getBodyStyle(fontSize: 14),
                  ),
                if (widget.showPercentage)
                  Text(
                    "${(widget.value * 100).round()}%",
                    style: novaTheme.getBodyStyle(fontSize: 14),
                  ),
              ],
            ),
          ),
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: backgroundColors,
            ),
            border: containerBorder,
            boxShadow:
                widget.borderStyle == NovaBorderStyle.glow
                    ? [
                      BoxShadow(
                        color: novaTheme.glow.withOpacity(
                          effectiveGlowIntensity * 0.3,
                        ),
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                      ),
                    ]
                    : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Stack(
              children: [
                if (widget.scanLines)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ScanLinePainter(
                        intensity: novaTheme.scanLineIntensity * 0.5,
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(widget.barCount, (index) {
                    final double opacity = _barOpacities[index];

                    double pulseModifier =
                        index < (widget.value * widget.barCount) &&
                                widget.pulseEffect
                            ? _pulseValue
                            : 1.0;

                    final double barHeight =
                        widget.height * widget.barThickness * pulseModifier;

                    final bool isGlitching =
                        _glitchBarIndex == index && widget.glitchEffect;

                    return Container(
                      width: barWidth,
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                        opacity:
                            isGlitching
                                ? math.Random().nextDouble() * 0.5 + 0.5
                                : opacity,
                        duration: Duration(
                          milliseconds: isGlitching ? 50 : 200,
                        ),
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              width:
                                  barWidth *
                                  (isGlitching
                                      ? (0.9 + math.Random().nextDouble() * 0.2)
                                      : 1.0),
                              height: barHeight,
                              decoration: BoxDecoration(
                                color:
                                    index < (widget.value * widget.barCount)
                                        ? effectiveActiveColor
                                        : effectiveInactiveColor,
                                borderRadius: BorderRadius.circular(
                                  widget.borderRadius / 2,
                                ),
                                boxShadow:
                                    index < (widget.value * widget.barCount)
                                        ? [
                                          BoxShadow(
                                            color: effectiveActiveColor
                                                .withOpacity(
                                                  effectiveGlowIntensity * 0.3,
                                                ),
                                            blurRadius: 4.0,
                                            spreadRadius:
                                                isGlitching ? 2.0 : 0.5,
                                          ),
                                        ]
                                        : null,
                              ),
                            ),
                            if (isGlitching)
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    widget.borderRadius / 2,
                                  ),
                                  child: CustomPaint(
                                    painter: GlitchPainter(
                                      isHover: false,
                                      textColor: effectiveActiveColor,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                if (widget.scanLines)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: widget.height * _scanPosition - 5,
                    height: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            novaTheme.glow.withOpacity(0.2),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
