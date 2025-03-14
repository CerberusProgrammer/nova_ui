import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nova_ui/components/buttons/nova_border_style.dart';
import 'package:nova_ui/components/buttons/nova_button.dart';
import 'package:nova_ui/components/buttons/nova_button_size.dart';
import 'package:nova_ui/components/buttons/nova_button_style.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';
import 'package:nova_ui/components/effects/circuit_pattern_painter.dart';
import 'package:nova_ui/components/effects/dash_border_painter.dart';
import 'package:nova_ui/components/effects/scan_line_painter.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';

class NovaDialog extends StatefulWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool barrierDismissible;
  final double? width;
  final double? height;
  final NovaButtonStyle? confirmButtonStyle;
  final NovaButtonStyle? cancelButtonStyle;
  final bool scanLines;
  final bool glitchEffect;
  final bool soundEffects;
  final bool bootAnimation;
  final bool idleAnimations;
  final bool circuitPattern;
  final NovaBorderStyle borderStyle;
  final double borderWidth;
  final double borderRadius;
  final double? glowIntensity;
  final NovaAnimationStyle animationStyle;
  final double animationSpeed;
  final double titleGlowIntensity;
  final bool titleFlicker;
  final bool typewriterAnimation;
  final List<Color>? backgroundColors;
  final Color? titleColor;
  final bool showHeaderBar;
  final IconData? icon;
  final bool emergencyLights;

  const NovaDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmText = 'CONFIRM',
    this.cancelText = 'CANCEL',
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
    this.width,
    this.height,
    this.confirmButtonStyle,
    this.cancelButtonStyle,
    this.scanLines = true,
    this.glitchEffect = true,
    this.soundEffects = false,
    this.bootAnimation = true,
    this.idleAnimations = true,
    this.circuitPattern = true,
    this.borderStyle = NovaBorderStyle.solid,
    this.borderWidth = 2.0,
    this.borderRadius = 4.0,
    this.glowIntensity,
    this.animationStyle = NovaAnimationStyle.standard,
    this.animationSpeed = 1.0,
    this.titleGlowIntensity = 1.0,
    this.titleFlicker = true,
    this.typewriterAnimation = true,
    this.backgroundColors,
    this.titleColor,
    this.showHeaderBar = true,
    this.icon,
    this.emergencyLights = false,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    String confirmText = 'CONFIRM',
    String? cancelText = 'CANCEL',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    double? width,
    double? height,
    // Use theme-aware button styles by default
    NovaButtonStyle? confirmButtonStyle,
    NovaButtonStyle? cancelButtonStyle,
    bool scanLines = true,
    bool glitchEffect = true,
    bool soundEffects = false,
    bool bootAnimation = true,
    bool idleAnimations = true,
    bool circuitPattern = true,
    NovaBorderStyle? borderStyle,
    double? borderWidth,
    double? borderRadius,
    double? glowIntensity,
    NovaAnimationStyle animationStyle = NovaAnimationStyle.standard,
    double animationSpeed = 1.0,
    double? titleGlowIntensity,
    bool titleFlicker = true,
    bool typewriterAnimation = true,
    List<Color>? backgroundColors,
    Color? titleColor,
    bool showHeaderBar = true,
    IconData? icon,
    bool emergencyLights = false,
  }) async {
    final novaTheme = context.novaTheme;

    final effectiveConfirmButtonStyle =
        confirmButtonStyle ??
        novaTheme.getButtonStyleByCurrentNovaTheme(novaTheme);
    final effectiveCancelButtonStyle =
        cancelButtonStyle ??
        novaTheme.getButtonStyleByCurrentNovaTheme(novaTheme);
    final effectiveBorderStyle = borderStyle ?? NovaBorderStyle.solid;
    final effectiveBorderWidth = borderWidth ?? 2.0;
    final effectiveBorderRadius = borderRadius ?? 4.0;
    final effectiveTitleGlowIntensity =
        titleGlowIntensity ?? novaTheme.textGlowIntensity;
    final effectiveGlowIntensity = glowIntensity ?? novaTheme.glowIntensity;

    final effectiveBackgroundColors =
        backgroundColors ??
        [novaTheme.surface, novaTheme.surface.withOpacity(0.9)];

    final effectiveTitleColor = titleColor ?? novaTheme.textPrimary;

    if (soundEffects) {
      HapticFeedback.mediumImpact();
    }

    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return NovaDialog(
          title: title,
          message: message,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: onConfirm ?? () => Navigator.of(context).pop(true),
          onCancel: onCancel ?? () => Navigator.of(context).pop(false),
          barrierDismissible: barrierDismissible,
          width: width,
          height: height,
          confirmButtonStyle: effectiveConfirmButtonStyle,
          cancelButtonStyle: effectiveCancelButtonStyle,
          scanLines: scanLines,
          glitchEffect: glitchEffect,
          soundEffects: soundEffects,
          bootAnimation: bootAnimation,
          idleAnimations: idleAnimations,
          circuitPattern: circuitPattern,
          borderStyle: effectiveBorderStyle,
          borderWidth: effectiveBorderWidth,
          borderRadius: effectiveBorderRadius,
          glowIntensity: effectiveGlowIntensity,
          animationStyle: animationStyle,
          animationSpeed: animationSpeed,
          titleGlowIntensity: effectiveTitleGlowIntensity,
          titleFlicker: titleFlicker,
          typewriterAnimation: typewriterAnimation,
          backgroundColors: effectiveBackgroundColors,
          titleColor: effectiveTitleColor,
          showHeaderBar: showHeaderBar,
          icon: icon,
          emergencyLights: emergencyLights,
        );
      },
    );
  }

  @override
  State<NovaDialog> createState() => _NovaDialogState();
}

class _NovaDialogState extends State<NovaDialog>
    with SingleTickerProviderStateMixin {
  bool _hasBooted = false;
  Timer? _animationTimer;
  double _circuitOpacity = 0.0;
  final List<double> _dashOffsets = [0, 0];
  bool _titleVisible = true;
  double _scanPosition = 0.0;
  int _displayTextLength = 0;
  bool _isAnimatingText = false;
  final List<double> _emergencyLightIntensity = [0.0, 0.0, 0.0];
  double _glitchProbability = 0.0;
  late AnimationController _entranceController;
  late Animation<double> _entranceAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds:
            (widget.bootAnimation ? 800 : 300) ~/ widget.animationSpeed,
      ),
    );

    _entranceAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: widget.bootAnimation ? Curves.easeOutBack : Curves.easeOutCirc,
    );

    // Start entrance animation
    _entranceController.forward();

    // Start boot animation if enabled
    if (widget.bootAnimation) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() => _hasBooted = true);
          _startIdleAnimations();

          // Start typewriter animation if enabled
          if (widget.typewriterAnimation && widget.message != null) {
            _startTypewriterAnimation();
          } else {
            _displayTextLength = widget.message?.length ?? 0;
          }
        }
      });
    } else {
      _hasBooted = true;
      _displayTextLength = widget.message?.length ?? 0;
      _startIdleAnimations();
    }
  }

  void _startIdleAnimations() {
    if (widget.idleAnimations &&
        widget.animationStyle != NovaAnimationStyle.none) {
      _animationTimer = Timer.periodic(Duration(milliseconds: 50), (_) {
        if (mounted) {
          setState(() {
            // Update border dash pattern for animated borders
            _dashOffsets[0] -= 0.5 * widget.animationSpeed;
            _dashOffsets[1] += 0.3 * widget.animationSpeed;

            // Update scan position for scan line effect
            _scanPosition =
                (_scanPosition + 0.03 * widget.animationSpeed) % 1.0;

            // Title flicker effect (rare)
            if (widget.titleFlicker && math.Random().nextDouble() > 0.98) {
              _titleVisible = !_titleVisible;
            } else {
              _titleVisible = true;
            }

            // Circuit pattern visibility
            if (widget.circuitPattern) {
              _circuitOpacity = math.min(
                1.0,
                _circuitOpacity + 0.05 * widget.animationSpeed,
              );
            }

            // Emergency lights animation (for alert style)
            if (widget.emergencyLights) {
              for (int i = 0; i < _emergencyLightIntensity.length; i++) {
                // Alternate flashing pattern
                if (i == DateTime.now().millisecondsSinceEpoch ~/ 500 % 3) {
                  _emergencyLightIntensity[i] = math.min(
                    1.0,
                    _emergencyLightIntensity[i] + 0.2,
                  );
                } else {
                  _emergencyLightIntensity[i] = math.max(
                    0.0,
                    _emergencyLightIntensity[i] - 0.1,
                  );
                }
              }
            }

            // Manage glitch probability over time for occasional effects
            if (widget.glitchEffect) {
              _glitchProbability =
                  0.03 +
                  0.05 * math.sin(DateTime.now().millisecondsSinceEpoch / 1000);
            }
          });
        }
      });
    }
  }

  void _startTypewriterAnimation() {
    _isAnimatingText = true;
    _displayTextLength = 0;

    // Animate the text typing character by character
    Timer.periodic(Duration(milliseconds: (50 ~/ widget.animationSpeed)), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_displayTextLength < (widget.message?.length ?? 0)) {
          _displayTextLength++;

          // Play typing sound occasionally
          if (widget.soundEffects && math.Random().nextDouble() > 0.7) {
            HapticFeedback.selectionClick();
          }
        } else {
          _isAnimatingText = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final novaTheme = context.novaTheme;
    final themeColors = novaTheme.getButtonColorsByCurrentNovaTheme(novaTheme);
    final effectiveTitleColor = widget.titleColor ?? novaTheme.textPrimary;
    final effectiveGlowColor = themeColors['glow'] ?? novaTheme.glow;
    final List<Color> backgroundColors =
        widget.backgroundColors ??
        [novaTheme.surface, novaTheme.surface.withOpacity(0.9)];

    final double effectiveGlowIntensity =
        widget.glowIntensity ?? (_hasBooted ? novaTheme.glowIntensity : 0.0);

    final double scanLineIntensity =
        themeColors['scanIntensity'] ?? novaTheme.scanLineIntensity;

    BoxBorder? dialogBorder;
    switch (widget.borderStyle) {
      case NovaBorderStyle.solid:
        dialogBorder = Border.all(
          color: novaTheme.primary,
          width: widget.borderWidth,
        );
        break;
      case NovaBorderStyle.double:
        dialogBorder = Border(
          top: BorderSide(color: novaTheme.primary, width: widget.borderWidth),
          left: BorderSide(color: novaTheme.primary, width: widget.borderWidth),
          right: BorderSide(
            color: novaTheme.secondary,
            width: widget.borderWidth,
          ),
          bottom: BorderSide(
            color: novaTheme.secondary,
            width: widget.borderWidth,
          ),
        );
        break;
      case NovaBorderStyle.dashed:
        dialogBorder = null;
        break;
      case NovaBorderStyle.glow:
        dialogBorder = Border.all(
          color: effectiveGlowColor.withOpacity(0.8),
          width: widget.borderWidth,
        );
        break;
      case NovaBorderStyle.none:
        dialogBorder = null;
        break;
    }

    final displayMessage =
        widget.message != null
            ? widget.message!.substring(0, _displayTextLength)
            : '';

    final showCursor =
        _isAnimatingText && (DateTime.now().millisecondsSinceEpoch % 800) > 400;

    return ScaleTransition(
      scale: _entranceAnimation,
      child: AnimatedOpacity(
        opacity: _hasBooted ? 1.0 : 0.0,
        duration: Duration(milliseconds: widget.bootAnimation ? 600 : 0),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            width: widget.width ?? 400,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              minHeight: 100,
              maxHeight:
                  widget.height ?? (MediaQuery.of(context).size.height * 0.8),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: backgroundColors,
              ),
              border: dialogBorder,
              boxShadow: [
                BoxShadow(
                  color: effectiveGlowColor.withOpacity(
                    effectiveGlowIntensity * 0.3,
                  ),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                if (widget.circuitPattern)
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: _circuitOpacity * 0.15,
                      duration: const Duration(milliseconds: 300),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius - widget.borderWidth,
                        ),
                        child: CustomPaint(
                          painter: CircuitPatternPainter(
                            color: novaTheme.primary.withOpacity(0.5),
                            patternDensity: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.scanLines)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius - widget.borderWidth,
                      ),
                      child: CustomPaint(
                        painter: ScanLinePainter(intensity: scanLineIntensity),
                      ),
                    ),
                  ),
                if (widget.emergencyLights)
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    height: 6,
                    child: Row(
                      children: [
                        for (int i = 0; i < 3; i++)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: novaTheme.error.withOpacity(
                                  _emergencyLightIntensity[i] * 0.8,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: novaTheme.error.withOpacity(
                                      _emergencyLightIntensity[i] * 0.6,
                                    ),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (widget.borderStyle == NovaBorderStyle.dashed)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DashedBorderPainter(
                        color: novaTheme.primary,
                        strokeWidth: widget.borderWidth,
                        dashPattern: const [5, 3],
                        dashOffset: _dashOffsets,
                        borderRadius: widget.borderRadius,
                      ),
                    ),
                  ),
                if (widget.borderStyle == NovaBorderStyle.glow)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        border: Border.all(
                          color: effectiveGlowColor.withOpacity(0.8),
                          width: widget.borderWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: effectiveGlowColor.withOpacity(
                              effectiveGlowIntensity * 0.4,
                            ),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.showHeaderBar)
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: novaTheme.accent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(widget.borderRadius),
                            topRight: Radius.circular(widget.borderRadius),
                          ),
                        ),
                      ),

                    // Título y contenido
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Encabezado con título e icono
                          Row(
                            children: [
                              if (widget.icon != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    widget.icon,
                                    color: effectiveTitleColor,
                                    size: 24,
                                  ),
                                ),
                              Expanded(
                                child: AnimatedOpacity(
                                  opacity: _titleVisible ? 1.0 : 0.7,
                                  duration: Duration(milliseconds: 50),
                                  child: Text(
                                    widget.title.toUpperCase(),
                                    style: novaTheme
                                        .getHeadingStyle(
                                          fontSize: 20,
                                          withGlow: true,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        )
                                        .copyWith(
                                          color: effectiveTitleColor,
                                          shadows: [
                                            Shadow(
                                              color: effectiveGlowColor
                                                  .withOpacity(
                                                    widget.titleGlowIntensity *
                                                        0.5,
                                                  ),
                                              blurRadius: 8.0,
                                            ),
                                          ],
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Contenido del diálogo
                          widget.content ??
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayMessage + (showCursor ? "_" : ""),
                                    style: novaTheme.getBodyStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),

                    // Espacio para los botones
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.cancelText != null)
                            NovaButton(
                              text: widget.cancelText!,
                              onPressed:
                                  widget.onCancel ??
                                  () => Navigator.of(context).pop(false),
                              style: widget.cancelButtonStyle!,
                              size: NovaButtonSize.small,
                              borderStyle: NovaBorderStyle.solid,
                              animationStyle: widget.animationStyle,
                            ),
                          SizedBox(width: 12),
                          NovaButton(
                            text: widget.confirmText,
                            onPressed:
                                widget.onConfirm ??
                                () => Navigator.of(context).pop(true),
                            style: widget.confirmButtonStyle!,
                            size: NovaButtonSize.small,
                            borderStyle: NovaBorderStyle.solid,
                            animationStyle: widget.animationStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Horizontal scan effect
                if (widget.scanLines)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: (widget.height ?? 250) * _scanPosition - 10,
                    height: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            effectiveGlowColor.withOpacity(0.15),
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
      ),
    );
  }
}
