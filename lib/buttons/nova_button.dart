import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:nova_ui/buttons/nova_button_size.dart';
import 'package:nova_ui/buttons/nova_button_style.dart';
import 'package:nova_ui/effects/dash_border_painter.dart';
import 'package:nova_ui/effects/scan_line_painter.dart';
import 'package:nova_ui/effects/glitch_effect_painter.dart';
import 'package:nova_ui/effects/circuit_pattern_painter.dart';

/// Border style options for [NovaButton]
enum NovaBorderStyle {
  /// Solid border
  solid,

  /// Dashed border (animated)
  dashed,

  /// Double border
  double,

  /// Glowing border
  glow,

  /// No border
  none,
}

/// Animation style for [NovaButton]
enum NovaAnimationStyle {
  /// Subtle animations
  subtle,

  /// Standard level of animations (default)
  standard,

  /// Dramatic, eye-catching animations
  dramatic,

  /// No animations
  none,
}

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
    this.idleAnimations = false,
    this.borderWidth,
    this.borderRadius,
    this.glowIntensity,
    this.iconDirection = TextDirection.ltr,
    this.iconSpacing = 8.0,
    this.disabled = false,
    this.pressAnimationDuration = const Duration(milliseconds: 150),
    this.hoverGlitch = true,
    this.hoverScanEffect = true,
    this.textFlicker = true, // Enable text flicker by default
    this.borderStyle = NovaBorderStyle.solid,
    this.animationStyle = NovaAnimationStyle.standard,
    this.circuitPattern = true, // Enable circuit pattern by default
    this.animationSpeed = 1.0,
    this.textGlowIntensity = 1.0,
    this.foregroundColor,
    this.backgroundColors,
  });

  @override
  _NovaButtonState createState() => _NovaButtonState();
}

class _NovaButtonState extends State<NovaButton>
    with SingleTickerProviderStateMixin {
  // Core animations
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _idlePulseAnimation;

  // Secondary controllers for complex animations
  late AnimationController _hoverController;

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

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: _getAnimationIntensity(1.5, 1.3, 1.8),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: _getAnimationIntensity(1.5, 1.3, 1.8),
          end: 1.0,
        ),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // For idle pulsing animations
    _idlePulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
              _scanPosition += 0.03 * widget.animationSpeed;
              if (_scanPosition > 1.0) _scanPosition = 0.0;
            }

            // Text flicker effect (rare)
            if (widget.textFlicker && math.Random().nextDouble() > 0.98) {
              _textVisible = !_textVisible;
              Future.delayed(Duration(milliseconds: 70), () {
                if (mounted) setState(() => _textVisible = true);
              });
            }

            // Text glow pulsing (subtle)
            _textGlowValue =
                1.0 +
                math.sin(DateTime.now().millisecondsSinceEpoch / 500) * 0.2;

            // Update circuit opacity for hover effect
            if (widget.circuitPattern) {
              if (_isHovered) {
                _circuitOpacity = math.min(1.0, _circuitOpacity + 0.05);
              } else {
                _circuitOpacity = math.max(0.0, _circuitOpacity - 0.05);
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
      _controller.repeat(reverse: true);
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
      // In a real implementation, you would play an actual sound here
      // using something like the audioplayers package
    }
  }

  void _playHoverSound() {
    if (widget.soundEffects && !widget.disabled) {
      HapticFeedback.selectionClick();
      // In a real implementation, you would play an actual sound here
      // using something like the audioplayers package
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
    final colors = getColorScheme(widget.style);
    final dimensions = getDimensions(widget.size, widget.borderRadius);

    // Use custom colors if provided
    final effectiveTextColor = widget.foregroundColor ?? colors['text'];
    final effectiveGlowColor = colors['glow'];

    final List<Color> backgroundColors =
        widget.backgroundColors ??
        [
          colors['primary'] ?? Colors.blue,
          colors['secondary'] ?? Colors.blue.shade800,
        ];

    // Calculate glow intensity based on state and configuration
    final double effectiveGlowIntensity =
        widget.glowIntensity ??
        (_isHovered
            ? 0.8
            : _isPressed
            ? 1.0
            : 0.6);

    // Button content with text/icon
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
                    blurRadius: 3.0 * widget.textGlowIntensity * _textGlowValue,
                    color: effectiveGlowColor ?? Colors.blue.withOpacity(0.7),
                    offset: Offset(0, 0),
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
                    borderRadius: BorderRadius.circular(
                      dimensions['borderRadius'],
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: backgroundColors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: effectiveGlowColor.withOpacity(
                          effectiveGlowIntensity * 0.7,
                        ),
                        blurRadius:
                            widget.pulseEffect
                                ? 10.0 * _glowAnimation.value
                                : (_isPressed
                                    ? 15.0
                                    : _isHovered
                                    ? 10.0
                                    : 5.0),
                        spreadRadius:
                            widget.pulseEffect
                                ? 2.0 * _glowAnimation.value
                                : (_isPressed
                                    ? 3.0
                                    : _isHovered
                                    ? 2.0
                                    : 0.0),
                      ),
                    ],
                    border:
                        widget.borderStyle != NovaBorderStyle.dashed
                            ? buttonBorder
                            : null,
                  ),
                  child: Opacity(
                    opacity: widget.disabled ? 0.5 : 1.0,
                    child: Stack(
                      children: [
                        // Circuit pattern background (appears on hover)
                        if (widget.circuitPattern)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                dimensions['borderRadius'],
                              ),
                              child: AnimatedOpacity(
                                opacity: _circuitOpacity * 0.2,
                                duration: Duration(milliseconds: 200),
                                child: CustomPaint(
                                  painter: CircuitPatternPainter(
                                    color:
                                        effectiveTextColor?.withOpacity(0.4) ??
                                        Colors.white.withOpacity(0.4),
                                    patternDensity: 15,
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
                                dimensions['borderRadius'],
                              ),
                              child: CustomPaint(
                                painter: ScanLinePainter(
                                  intensity: colors['scanIntensity'] ?? 0.08,
                                ),
                              ),
                            ),
                          ),

                        // Dashed border effect (animated)
                        if (widget.borderStyle == NovaBorderStyle.dashed)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: DashedBorderPainter(
                                color:
                                    _isHovered
                                        ? effectiveTextColor ?? Colors.white
                                        : backgroundColors[0],
                                strokeWidth: widget.borderWidth ?? 2.0,
                                dashPattern: [8, 4],
                                dashOffset: _dashOffsets,
                                borderRadius: dimensions['borderRadius'],
                              ),
                            ),
                          ),

                        // Hover scan effect (horizontal line that travels up/down)
                        if (_isHovered && widget.hoverScanEffect && !_isPressed)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: dimensions['height'] * _scanPosition - 1,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    effectiveTextColor?.withOpacity(0.7) ??
                                        Colors.white.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),

                        // Button content
                        Center(child: contentWidget),

                        // Hover glitch effect
                        if (_isHovered &&
                            !_isPressed &&
                            widget.hoverGlitch &&
                            !widget.disabled)
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
