import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nova_ui/effects/nova_animation_style.dart';
import 'package:nova_ui/buttons/nova_border_style.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:nova_ui/buttons/nova_button_size.dart';
import 'package:nova_ui/buttons/nova_button_style.dart';
import 'package:nova_ui/effects/dash_border_painter.dart';
import 'package:nova_ui/effects/scan_line_painter.dart';
import 'package:nova_ui/effects/glitch_effect_painter.dart';
import 'package:nova_ui/effects/circuit_pattern_painter.dart';
import 'package:nova_ui/theme/nova_theme_provider.dart';

/// A highly customizable retro-futuristic button for the NoVa UI design system.
class NovaButton extends StatefulWidget {
  /// The text to display on the button
  final String text;

  /// The icon to display alongside the text (optional)
  final IconData? icon;

  /// The callback when button is pressed
  final VoidCallback onPressed;

  /// The style preset for the button
  final NovaButtonStyle style;

  /// The size preset for the button
  final NovaButtonSize size;

  /// Whether to show scan lines effect
  final bool scanLines;

  /// Whether to enable the pulsing glow effect
  final bool pulseEffect;

  /// Whether to show a loading state
  final bool isLoading;

  /// Whether to play sound effects on interaction
  final bool soundEffects;

  /// Whether to show a "boot up" animation when first displayed
  final bool bootAnimation;

  /// Whether to show idle animations even when not interacting
  final bool idleAnimations;

  /// Custom border width
  final double? borderWidth;

  /// Custom border radius
  final double? borderRadius;

  /// Custom glow intensity (0.0 to 1.0)
  final double? glowIntensity;

  /// Direction of the icon relative to text
  final TextDirection iconDirection;

  /// Space between icon and text
  final double iconSpacing;

  /// Whether button is disabled
  final bool disabled;

  /// The duration of the press animation
  final Duration pressAnimationDuration;

  /// Whether to show a glitch effect on hover
  final bool hoverGlitch;

  /// Whether to show a scan effect on hover
  final bool hoverScanEffect;

  /// Whether to show text flicker effect
  final bool textFlicker;

  /// Border style for the button
  final NovaBorderStyle borderStyle;

  /// Animation style (controls intensity of all animations)
  final NovaAnimationStyle animationStyle;

  /// Whether to show background circuit pattern
  final bool circuitPattern;

  /// Speed multiplier for animations (1.0 = normal)
  final double animationSpeed;

  /// Text glow intensity (0.0 to 1.0)
  final double textGlowIntensity;

  /// Custom foreground color
  final Color? foregroundColor;

  /// Custom background colors
  final List<Color>? backgroundColors;

  const NovaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.style = NovaButtonStyle.terminal,
    this.size = NovaButtonSize.medium,
    this.scanLines = true,
    this.pulseEffect = true,
    this.isLoading = false,
    this.soundEffects = false,
    this.bootAnimation = true,
    this.idleAnimations = true,
    this.borderWidth = 2,
    this.borderRadius = 0,
    this.glowIntensity,
    this.iconDirection = TextDirection.ltr,
    this.iconSpacing = 8.0,
    this.disabled = false,
    this.pressAnimationDuration = const Duration(milliseconds: 150),
    this.hoverGlitch = true,
    this.hoverScanEffect = true,
    this.textFlicker = true,
    this.borderStyle = NovaBorderStyle.none,
    this.animationStyle = NovaAnimationStyle.standard,
    this.circuitPattern = true,
    this.animationSpeed = 1.0,
    this.textGlowIntensity = 1.0,
    this.foregroundColor,
    this.backgroundColors,
  });

  @override
  State<NovaButton> createState() => _NovaButtonState();
}

class _NovaButtonState extends State<NovaButton>
    with SingleTickerProviderStateMixin {
  // Core animations
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  // State tracking
  bool _isHovered = false;
  bool _isPressed = false;
  bool _hasBooted = false;

  // For hover scan effect
  double _scanPosition = 0.0;

  // For text flicker
  bool _textVisible = true;
  double _textGlowValue = 1.0;

  // For border animation
  final List<double> _dashOffsets = [0, 0];

  // For circuit animation
  double _circuitOpacity = 0.0;

  // Timer for repeating animations
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();

    // Main controller for press animations
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
      end: _getAnimationIntensity(0.95, 0.98, 0.92),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start boot animation after small delay
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

    // Set up repeating animations if needed
    _setupRepeatingAnimations();
  }

  @override
  void didUpdateWidget(NovaButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation speed if it changed
    if (oldWidget.animationSpeed != widget.animationSpeed) {
      _controller.duration = Duration(
        milliseconds:
            (widget.pressAnimationDuration.inMilliseconds /
                    widget.animationSpeed)
                .round(),
      );
    }

    // Reset the animations if needed
    if (oldWidget.idleAnimations != widget.idleAnimations ||
        oldWidget.animationStyle != widget.animationStyle) {
      _setupRepeatingAnimations();
    }
  }

  // Get animation intensity based on animation style
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
        return 1.0; // No animation
    }
  }

  void _setupRepeatingAnimations() {
    // Cancel existing timer if any
    _animationTimer?.cancel();

    if (widget.idleAnimations &&
        widget.animationStyle != NovaAnimationStyle.none &&
        !widget.disabled) {
      // Set up timer for animations that need regular updates
      _animationTimer = Timer.periodic(Duration(milliseconds: 50), (_) {
        if (mounted) {
          setState(() {
            // Update border dash pattern
            _dashOffsets[0] -= 0.5 * widget.animationSpeed;
            _dashOffsets[1] += 0.3 * widget.animationSpeed;

            // Update scan position for hover effect
            if (_isHovered && widget.hoverScanEffect) {
              _scanPosition =
                  (_scanPosition + 0.05 * widget.animationSpeed) % 1.0;
            }

            // Text flicker effect (rare)
            if (widget.textFlicker && math.Random().nextDouble() > 0.98) {
              _textVisible = !_textVisible;
            } else {
              _textVisible = true;
            }

            // Text glow pulsing (subtle)
            _textGlowValue =
                0.8 +
                0.2 * math.sin(DateTime.now().millisecondsSinceEpoch / 1000);

            // Update circuit opacity for hover effect
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

  // Update the _startIdleAnimations() method to stop using repeat animation:
  void _startIdleAnimations() {
    // We'll keep the timer for other animations but not pulse the button
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
    final dimensions = getDimensions(widget.size, widget.borderRadius);
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
            ? novaTheme.glowIntensity * 1.3
            : _isPressed
            ? novaTheme.glowIntensity * 1.5
            : novaTheme.glowIntensity);

    final double scanLineIntensity =
        themeColors['scanIntensity'] ?? novaTheme.scanLineIntensity;

    Widget contentWidget = Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: widget.iconDirection,
      children: <Widget>[
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: dimensions['iconSize'],
            color: effectiveTextColor,
          ),
          SizedBox(
            width: widget.size == NovaButtonSize.icon ? 0 : widget.iconSpacing,
          ),
        ],
        if (widget.size != NovaButtonSize.icon)
          AnimatedOpacity(
            opacity: _textVisible ? 1.0 : 0.5,
            duration: Duration(milliseconds: 50),
            child: Text(
              widget.text.toUpperCase(),
              style: TextStyle(
                color: effectiveTextColor,
                fontSize: dimensions['fontSize'],
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: effectiveGlowColor.withOpacity(
                      novaTheme.textGlowIntensity *
                          widget.textGlowIntensity *
                          _textGlowValue,
                    ),
                    blurRadius: 8.0,
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    // Loading state
    if (widget.isLoading) {
      contentWidget = Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: dimensions['fontSize'] * 1.4,
            height: dimensions['fontSize'] * 1.4,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                effectiveTextColor ?? Colors.white,
              ),
            ),
          ),
          if (widget.textFlicker && math.Random().nextDouble() > 0.9)
            Text(
              "...",
              style: TextStyle(
                color: effectiveTextColor,
                fontSize: dimensions['fontSize'] * 0.8,
              ),
            ),
        ],
      );
    }

    // Border style based on configuration
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
                  width: dimensions['width'],
                  height: dimensions['height'],
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
                    borderRadius: BorderRadius.circular(
                      dimensions['borderRadius'],
                    ),
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
                        // Circuit pattern background (if enabled)
                        if (widget.circuitPattern)
                          Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: _circuitOpacity * 0.15,
                              duration: Duration(milliseconds: 300),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  dimensions['borderRadius'] -
                                      (widget.borderWidth ?? 2.0),
                                ),
                                child: CustomPaint(
                                  painter: CircuitPatternPainter(
                                    color: effectiveTextColor.withOpacity(0.5),
                                    patternDensity: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Scan lines effect
                        if (widget.scanLines)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                dimensions['borderRadius'] -
                                    (widget.borderWidth ?? 2.0),
                              ),
                              child: CustomPaint(
                                painter: ScanLinePainter(
                                  intensity: scanLineIntensity,
                                ),
                              ),
                            ),
                          ),

                        // Hover scan effect (horizontal scanning line)
                        if (_isHovered && widget.hoverScanEffect)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                dimensions['borderRadius'] -
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

                        // Animated dashed border (if selected)
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
                                borderRadius: dimensions['borderRadius'],
                              ),
                            ),
                          ),

                        // Glowing border (if selected)
                        if (widget.borderStyle == NovaBorderStyle.glow)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  dimensions['borderRadius'],
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

                        // Button content
                        Center(child: contentWidget),

                        // Hover glitch effect
                        if (_isHovered && widget.hoverGlitch)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                dimensions['borderRadius'],
                              ),
                              child: CustomPaint(
                                painter: GlitchPainter(
                                  isHover: true,
                                  textColor: effectiveTextColor,
                                ),
                              ),
                            ),
                          ),

                        // Digital noise/glitch effect on press
                        if (_isPressed && !widget.disabled)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                dimensions['borderRadius'],
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
