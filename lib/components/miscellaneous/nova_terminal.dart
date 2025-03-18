import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';

/// A retro-futuristic terminal component that displays text in a sci-fi way
class NovaTerminal extends StatefulWidget {
  /// Width of the terminal
  final double width;

  /// Height of the terminal
  final double height;

  /// Text to display in the terminal
  final List<String> lines;

  /// Animation style controlling intensity
  final NovaAnimationStyle animationStyle;

  /// Animation speed multiplier (1.0 = normal)
  final double typingSpeed;

  /// Color of the terminal text (uses theme accent if null)
  final Color? textColor;

  /// Glow intensity (0.0 to 1.0)
  final double glowIntensity;

  /// Whether to show scanlines effect
  final bool scanLines;

  /// Whether to use typing effect
  final bool typingEffect;

  /// Whether to show blinking cursor
  final bool blinkingCursor;

  /// Whether to show glitch effects
  final bool glitchEffects;

  /// Whether to show a title bar
  final bool showTitleBar;

  /// Custom title text
  final String? title;

  /// Whether to auto-scroll to bottom
  final bool autoScroll;

  const NovaTerminal({
    super.key,
    this.width = 300.0,
    this.height = 200.0,
    required this.lines,
    this.animationStyle = NovaAnimationStyle.standard,
    this.typingSpeed = 1.0,
    this.textColor,
    this.glowIntensity = 0.7,
    this.scanLines = true,
    this.typingEffect = true,
    this.blinkingCursor = true,
    this.glitchEffects = true,
    this.showTitleBar = true,
    this.title,
    this.autoScroll = true,
  });

  @override
  State<NovaTerminal> createState() => _NovaTerminalState();
}

class _NovaTerminalState extends State<NovaTerminal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final math.Random _random = math.Random();
  int _visibleCharCount = 0;
  int _visibleLineCount = 0;
  Timer? _typingTimer;
  bool _showCursor = true;
  Timer? _cursorTimer;
  int _glitchLine = -1;
  int _glitchChar = -1;
  Timer? _glitchTimer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.repeat();

    if (widget.typingEffect) {
      _startTyping();
    } else {
      _visibleLineCount = widget.lines.length;
      _visibleCharCount = _getTotalCharCount();
    }

    if (widget.blinkingCursor) {
      _cursorTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
        setState(() {
          _showCursor = !_showCursor;
        });
      });
    }

    if (widget.glitchEffects) {
      _startGlitchEffect();
    }
  }

  @override
  void didUpdateWidget(NovaTerminal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.typingSpeed != widget.typingSpeed && widget.typingEffect) {
      _typingTimer?.cancel();
      _startTyping();
    }

    // Auto-scroll when lines change
    if (widget.autoScroll &&
        widget.lines.length != oldWidget.lines.length &&
        _scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    _glitchTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startTyping() {
    final charDelay = 60 / widget.typingSpeed;
    _visibleLineCount = 1;

    _typingTimer = Timer.periodic(Duration(milliseconds: charDelay.round()), (
      _,
    ) {
      setState(() {
        _visibleCharCount++;

        if (_visibleCharCount >= _getCharCountUpToLine(_visibleLineCount) &&
            _visibleLineCount < widget.lines.length) {
          _visibleLineCount++;

          // Auto-scroll when new line appears
          if (widget.autoScroll && _scrollController.hasClients) {
            Future.delayed(const Duration(milliseconds: 50), () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        }

        if (_visibleCharCount >= _getTotalCharCount()) {
          _typingTimer?.cancel();
        }
      });
    });
  }

  void _startGlitchEffect() {
    _glitchTimer = Timer.periodic(const Duration(milliseconds: 3000), (_) {
      setState(() {
        if (_random.nextDouble() < 0.3) {
          // Apply glitch effect to a random line
          if (_visibleLineCount > 0) {
            _glitchLine = _random.nextInt(_visibleLineCount);
            _glitchChar = _random.nextInt(
              math.max(1, widget.lines[_glitchLine].length),
            );
          }

          // Clear glitch after a short delay
          Future.delayed(
            Duration(milliseconds: 150 + _random.nextInt(400)),
            () {
              if (mounted) {
                setState(() {
                  _glitchLine = -1;
                  _glitchChar = -1;
                });
              }
            },
          );
        }
      });
    });
  }

  int _getTotalCharCount() {
    int count = 0;
    for (final line in widget.lines) {
      count += line.length;
    }
    return count;
  }

  int _getCharCountUpToLine(int lineIndex) {
    int count = 0;
    for (int i = 0; i < lineIndex && i < widget.lines.length; i++) {
      count += widget.lines[i].length;
    }
    return count;
  }

  int _getCurrentVisibleLineLength() {
    if (_visibleLineCount == 0) return 0;
    if (_visibleLineCount > widget.lines.length) return 0;

    int previousLinesCount = _getCharCountUpToLine(_visibleLineCount - 1);
    return _visibleCharCount - previousLinesCount;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;
    final textColor = widget.textColor ?? theme.accent;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: textColor.withOpacity(0.7), width: 1),
            boxShadow: [
              BoxShadow(
                color: textColor.withOpacity(0.2 * widget.glowIntensity),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showTitleBar) ...[
                Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.title ?? 'TERMINAL',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Expanded(
                child: Stack(
                  children: [
                    if (widget.scanLines)
                      CustomPaint(
                        size: Size(
                          widget.width,
                          widget.height - (widget.showTitleBar ? 24 : 0),
                        ),
                        painter: _ScanLinePainter(
                          scanLineOpacity: 0.05,
                          animationValue: _controller.value,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      // Use SingleChildScrollView for scrolling
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: _buildTerminalContent(textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTerminalContent(Color textColor) {
    final visibleLines = widget.lines.take(_visibleLineCount).toList();
    final List<Widget> lineWidgets = [];

    for (int i = 0; i < visibleLines.length; i++) {
      if (i >= widget.lines.length) continue;

      String line = visibleLines[i];

      if (i == _visibleLineCount - 1 && widget.typingEffect) {
        // For the current typing line, only show characters up to visible count
        final visibleLen = _getCurrentVisibleLineLength();
        if (visibleLen < line.length) {
          line = line.substring(0, visibleLen);
        }
      }

      // Apply glitch effect if this is the glitched line
      if (i == _glitchLine && _glitchChar >= 0 && _glitchChar < line.length) {
        final glitchChars = '!@#\$%^&*+=-_';
        final beforeGlitch = line.substring(0, _glitchChar);
        final afterGlitch =
            _glitchChar + 1 < line.length
                ? line.substring(_glitchChar + 1)
                : '';
        final glitchChar = glitchChars[_random.nextInt(glitchChars.length)];

        lineWidgets.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                beforeGlitch,
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'monospace',
                  package: 'nova_ui',
                ),
              ),
              Text(
                glitchChar,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  package: 'nova_ui',
                  backgroundColor: textColor,
                ),
              ),
              Text(
                afterGlitch,
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'monospace',
                  package: 'nova_ui',
                ),
              ),
            ],
          ),
        );
      } else {
        // Normal line
        lineWidgets.add(
          Text(
            line,
            style: TextStyle(
              color: textColor,
              fontFamily: 'monospace',
              package: 'nova_ui',
              shadows:
                  widget.glowIntensity > 0
                      ? [
                        Shadow(
                          color: textColor.withOpacity(
                            0.7 * widget.glowIntensity,
                          ),
                          blurRadius: 4,
                        ),
                      ]
                      : null,
            ),
          ),
        );
      }
    }

    // Add cursor to the last visible line
    if (widget.blinkingCursor &&
        _showCursor &&
        _visibleLineCount > 0 &&
        lineWidgets.isNotEmpty) {
      final cursorWidget = Container(
        width: 8,
        height: 14,
        color: textColor.withOpacity(0.7),
      );

      lineWidgets[lineWidgets.length - 1] = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [lineWidgets.last, cursorWidget],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: lineWidgets,
    );
  }
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
  bool shouldRepaint(_ScanLinePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
