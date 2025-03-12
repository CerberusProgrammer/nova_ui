import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nova_ui/effects/nova_animation_style.dart';
import 'package:nova_ui/buttons/nova_border_style.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:nova_ui/buttons/nova_button_style.dart';
import 'package:nova_ui/effects/dash_border_painter.dart';
import 'package:nova_ui/effects/scan_line_painter.dart';
import 'package:nova_ui/effects/glitch_effect_painter.dart';
import 'package:nova_ui/effects/circuit_pattern_painter.dart';
import 'package:nova_ui/theme/nova_theme_provider.dart';

class NovaIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final NovaButtonStyle style;
  final double size;
  final bool scanLines;
  final bool pulseEffect;
  final bool isLoading;
  final bool soundEffects;
  final bool bootAnimation;
  final bool idleAnimations;
  final double? borderWidth;
  final double? borderRadius;
  final double? glowIntensity;
  final bool disabled;
  final Duration pressAnimationDuration;
  final bool hoverGlitch;
  final bool hoverScanEffect;
  final NovaBorderStyle borderStyle;
  final NovaAnimationStyle animationStyle;
  final bool circuitPattern;
  final double animationSpeed;
  final Color? foregroundColor;
  final List<Color>? backgroundColors;
  final bool circular;

  const NovaIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.style = NovaButtonStyle.terminal,
    this.size = 40.0,
    this.scanLines = true,
    this.pulseEffect = true,
    this.isLoading = false,
    this.soundEffects = false,
    this.bootAnimation = true,
    this.idleAnimations = true,
    this.borderWidth = 2,
    this.borderRadius,
    this.glowIntensity,
    this.disabled = false,
    this.pressAnimationDuration = const Duration(milliseconds: 150),
    this.hoverGlitch = true,
    this.hoverScanEffect = true,
    this.borderStyle = NovaBorderStyle.none,
    this.animationStyle = NovaAnimationStyle.standard,
    this.circuitPattern = true,
    this.animationSpeed = 1.0,
    this.foregroundColor,
    this.backgroundColors,
    this.circular = true,
  });

  @override
  State<NovaIconButton> createState() => _NovaIconButtonState();
}

class _NovaIconButtonState extends State<NovaIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;
  bool _hasBooted = false;
  double _scanPosition = 0.0;
  double _iconPulse = 1.0;
  final List<double> _dashOffsets = [0, 0];
  double _circuitOpacity = 0.0;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds:
            (widget.pressAnimationDuration.inMilliseconds /
                    widget.animationSpeed)
                .round(),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: _getAnimationIntensity(0.92, 0.95, 0.88),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.bootAnimation) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() => _hasBooted = true);
          _startIdleAnimations();
        }
      });
    } else {
      _hasBooted = true;
      _startIdleAnimations();
    }

    _setupRepeatingAnimations();
  }

  @override
  void didUpdateWidget(NovaIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationSpeed != widget.animationSpeed) {
      _controller.duration = Duration(
        milliseconds:
            (widget.pressAnimationDuration.inMilliseconds /
                    widget.animationSpeed)
                .round(),
      );
    }

    if (oldWidget.idleAnimations != widget.idleAnimations ||
        oldWidget.animationStyle != widget.animationStyle) {
      _setupRepeatingAnimations();
    }
  }

  double _getAnimationIntensity(
    double standard,
    double subtle,
    double dramatic,
  ) {
    switch (widget.animationStyle) {
      case NovaAnimationStyle.subtle:
        return subtle;
      case NovaAnimationStyle.standard:
        return standard;
      case NovaAnimationStyle.dramatic:
        return dramatic;
      case NovaAnimationStyle.none:
        return 1.0;
    }
  }

  void _setupRepeatingAnimations() {
    _animationTimer?.cancel();

    if (widget.idleAnimations &&
        widget.animationStyle != NovaAnimationStyle.none &&
        !widget.disabled) {
      _animationTimer = Timer.periodic(Duration(milliseconds: 50), (_) {
        if (mounted) {
          setState(() {
            _dashOffsets[0] -= 0.5 * widget.animationSpeed;
            _dashOffsets[1] += 0.3 * widget.animationSpeed;

            if (_isHovered && widget.hoverScanEffect) {
              _scanPosition =
                  (_scanPosition + 0.05 * widget.animationSpeed) % 1.0;
            }

            if (widget.pulseEffect) {
              _iconPulse =
                  1.0 +
                  0.1 * math.sin(DateTime.now().millisecondsSinceEpoch / 800);
            }

            if (widget.circuitPattern) {
              if (_isHovered) {
                _circuitOpacity = math.min(
                  1.0,
                  _circuitOpacity + 0.05 * widget.animationSpeed,
                );
              } else {
                _circuitOpacity = math.max(
                  0.0,
                  _circuitOpacity - 0.05 * widget.animationSpeed,
                );
              }
            }
          });
        }
      });
    }
  }

  void _startIdleAnimations() {
    if (widget.idleAnimations &&
        !widget.disabled &&
        widget.animationStyle != NovaAnimationStyle.none) {
      _setupRepeatingAnimations();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationTimer?.cancel();
    super.dispose();
  }

  void _playClickSound() {
    if (widget.soundEffects && !widget.disabled) {
      HapticFeedback.lightImpact();
    }
  }

  void _playHoverSound() {
    if (widget.soundEffects && !widget.disabled) {
      HapticFeedback.selectionClick();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.disabled) return;
    setState(() => _isPressed = true);

    if (widget.animationStyle != NovaAnimationStyle.none) {
      _controller.forward();
    }

    _playClickSound();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.disabled) return;
    setState(() => _isPressed = false);

    if (widget.animationStyle != NovaAnimationStyle.none) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.disabled) return;
    setState(() => _isPressed = false);

    if (widget.animationStyle != NovaAnimationStyle.none) {
      _controller.reverse();
    }
  }

  void _handleHoverStart(PointerEvent event) {
    if (widget.disabled) return;
    setState(() => _isHovered = true);
    _playHoverSound();
  }

  void _handleHoverEnd(PointerEvent event) {
    if (widget.disabled) return;
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final novaTheme = context.novaTheme;
    final themeColors = novaTheme.getButtonColors(widget.style);
    final effectiveTextColor = widget.foregroundColor ?? themeColors['text'];
    final effectiveGlowColor = themeColors['glow'];

    final List<Color> backgroundColors =
        widget.backgroundColors ??
        [
          themeColors['primary'] ?? novaTheme.primary,
          themeColors['secondary'] ?? novaTheme.secondary,
        ];

    final double effectiveGlowIntensity =
        widget.glowIntensity ??
        (_isHovered
            ? novaTheme.glowIntensity * 1.4
            : _isPressed
            ? novaTheme.glowIntensity * 1.6
            : novaTheme.glowIntensity);

    final double scanLineIntensity =
        themeColors['scanIntensity'] ?? novaTheme.scanLineIntensity;

    final double effectiveBorderRadius =
        widget.borderRadius ??
        (widget.circular ? widget.size / 2 : widget.size * 0.15);

    Widget contentWidget = AnimatedScale(
      scale: widget.pulseEffect ? _iconPulse : 1.0,
      duration: Duration(milliseconds: 100),
      child: Icon(
        widget.icon,
        color: effectiveTextColor,
        size: widget.size * 0.5,
      ),
    );

    if (widget.isLoading) {
      contentWidget = SizedBox(
        width: widget.size * 0.4,
        height: widget.size * 0.4,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
        ),
      );
    }

    BoxBorder? buttonBorder;
    switch (widget.borderStyle) {
      case NovaBorderStyle.solid:
        buttonBorder = Border.all(
          color: _isHovered ? effectiveTextColor : backgroundColors[0],
          width: widget.borderWidth ?? 2.0,
        );
        break;
      case NovaBorderStyle.double:
        buttonBorder = Border(
          top: BorderSide(
            color: backgroundColors[0],
            width: widget.borderWidth ?? 2.0,
          ),
          left: BorderSide(
            color: backgroundColors[0],
            width: widget.borderWidth ?? 2.0,
          ),
          right: BorderSide(
            color: backgroundColors[1],
            width: widget.borderWidth ?? 2.0,
          ),
          bottom: BorderSide(
            color: backgroundColors[1],
            width: widget.borderWidth ?? 2.0,
          ),
        );
        break;
      case NovaBorderStyle.none:
        buttonBorder = null;
        break;
      default:
        buttonBorder = Border.all(
          color: backgroundColors[0],
          width: widget.borderWidth ?? 2.0,
        );
    }

    return AnimatedOpacity(
      opacity: _hasBooted ? 1.0 : 0.0,
      duration: Duration(milliseconds: widget.bootAnimation ? 800 : 0),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return MouseRegion(
            onEnter: _handleHoverStart,
            onExit: _handleHoverEnd,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: widget.disabled ? null : widget.onPressed,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: effectiveGlowColor.withOpacity(
                          effectiveGlowIntensity *
                              (_isHovered || _isPressed ? 0.5 : 0.3),
                        ),
                        blurRadius: _isHovered || _isPressed ? 15.0 : 10.0,
                        spreadRadius: _isHovered || _isPressed ? 2.0 : 1.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(effectiveBorderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: backgroundColors,
                    ),
                    border: buttonBorder,
                  ),
                  child: Opacity(
                    opacity: widget.disabled ? 0.5 : 1.0,
                    child: Stack(
                      children: [
                        if (widget.circuitPattern)
                          Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: _circuitOpacity * 0.15,
                              duration: Duration(milliseconds: 300),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  effectiveBorderRadius -
                                      (widget.borderWidth ?? 2.0),
                                ),
                                child: CustomPaint(
                                  painter: CircuitPatternPainter(
                                    color: effectiveTextColor.withOpacity(0.5),
                                    patternDensity: 6,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        if (widget.scanLines)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                effectiveBorderRadius -
                                    (widget.borderWidth ?? 2.0),
                              ),
                              child: CustomPaint(
                                painter: ScanLinePainter(
                                  intensity: scanLineIntensity,
                                ),
                              ),
                            ),
                          ),

                        if (_isHovered && widget.hoverScanEffect)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                effectiveBorderRadius -
                                    (widget.borderWidth ?? 2.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [
                                      _scanPosition - 0.05,
                                      _scanPosition,
                                      _scanPosition + 0.05,
                                    ],
                                    colors: [
                                      Colors.transparent,
                                      effectiveTextColor.withOpacity(0.15),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        if (widget.borderStyle == NovaBorderStyle.dashed)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: DashedBorderPainter(
                                color:
                                    _isHovered
                                        ? effectiveTextColor
                                        : backgroundColors[0],
                                strokeWidth: widget.borderWidth ?? 2.0,
                                dashPattern: [5, 3],
                                dashOffset: _dashOffsets,
                                borderRadius: effectiveBorderRadius,
                              ),
                            ),
                          ),

                        if (widget.borderStyle == NovaBorderStyle.glow)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  effectiveBorderRadius,
                                ),
                                border: Border.all(
                                  color: effectiveTextColor.withOpacity(
                                    _isHovered ? 0.8 : 0.5,
                                  ),
                                  width: widget.borderWidth ?? 2.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: effectiveTextColor.withOpacity(
                                      (_isHovered ? 0.4 : 0.2) *
                                          effectiveGlowIntensity,
                                    ),
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        Center(child: contentWidget),

                        if (_isHovered && widget.hoverGlitch)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                effectiveBorderRadius,
                              ),
                              child: CustomPaint(
                                painter: GlitchPainter(
                                  isHover: true,
                                  textColor: effectiveTextColor,
                                ),
                              ),
                            ),
                          ),

                        if (_isPressed && !widget.disabled)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                effectiveBorderRadius,
                              ),
                              child: CustomPaint(
                                painter: GlitchPainter(
                                  isHover: false,
                                  textColor: effectiveTextColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
