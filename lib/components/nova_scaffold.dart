import 'package:flutter/material.dart';
import 'package:nova_ui/components/buttons/nova_border_style.dart';
import 'package:nova_ui/components/scaffold/nova_appbar.dart';
import 'package:nova_ui/components/theme/nova_theme.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/scaffold/nova_drawer.dart';
import 'package:nova_ui/components/scaffold/nova_footer.dart';
import 'package:nova_ui/components/scaffold/nova_boot_screen.dart';
import 'package:nova_ui/components/scaffold/decorations/nova_angle_painter.dart';
import 'package:nova_ui/components/scaffold/decorations/nova_circuit_painter.dart';
import 'package:nova_ui/components/scaffold/decorations/nova_hexagon_painter.dart';
import 'package:nova_ui/components/scaffold/decorations/nova_noise_painter.dart';

class NovaScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showHeader;
  final bool showFooter;
  final bool scanLines;
  final bool circuitPattern;
  final NovaBorderStyle borderStyle;
  final double borderWidth;
  final double glowIntensity;
  final bool showAngleDecoration;
  final bool showFrameLines;
  final bool bootAnimation;
  final bool hexagonalPattern;
  final bool digitalNoise;
  final bool pulseEffect;

  const NovaScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showHeader = true,
    this.showFooter = true,
    this.scanLines = true,
    this.circuitPattern = false,
    this.borderStyle = NovaBorderStyle.glow,
    this.borderWidth = 2.0,
    this.glowIntensity = 0.7,
    this.showAngleDecoration = true,
    this.showFrameLines = true,
    this.bootAnimation = false,
    this.hexagonalPattern = false,
    this.digitalNoise = false,
    this.pulseEffect = false,
  });

  @override
  State<NovaScaffold> createState() => _NovaScaffoldState();
}

class _NovaScaffoldState extends State<NovaScaffold>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animController;
  double _bootProgress = 0.0;
  bool _isBooted = false;
  int _statusLineIndex = 0;
  final List<String> _bootMessages = [
    "INITIALIZING SYSTEM...",
    "LOADING MODULES...",
    "CONFIGURING INTERFACE...",
    "CALIBRATING DISPLAY...",
    "SYNCHRONIZING DATA...",
    "SYSTEM READY",
  ];
  double _pulseValue = 0.0;
  bool _showNoise = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (widget.bootAnimation) {
      _runBootSequence();
    } else {
      _isBooted = true;
    }

    if (widget.pulseEffect || widget.digitalNoise) {
      _startVisualEffects();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _startVisualEffects() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _pulseValue = widget.pulseEffect ? (_pulseValue + 0.02) % 1.0 : 0.0;
          _showNoise = widget.digitalNoise ? !_showNoise : false;
        });
        _startVisualEffects();
      }
    });
  }

  void _runBootSequence() {
    Future.delayed(Duration.zero, () {
      setState(() => _bootProgress = 0.0);
      _startBootAnimation();
    });
  }

  void _startBootAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_bootProgress < 1.0) {
        setState(() {
          _bootProgress += 0.02;
          if (_bootProgress > _statusLineIndex * 0.2 &&
              _statusLineIndex < _bootMessages.length - 1) {
            _statusLineIndex++;
          }
        });
        _startBootAnimation();
      } else {
        setState(() => _isBooted = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final novaTheme = context.novaTheme;

    if (!_isBooted) {
      return NovaBootScreen(
        bootProgress: _bootProgress,
        statusMessage: _bootMessages[_statusLineIndex],
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: NovaDrawer(showCircuitPattern: widget.circuitPattern),
      body: Stack(
        children: [
          Container(color: novaTheme.background),

          _buildBackgroundDecorations(novaTheme),

          Column(
            children: [
              if (widget.showHeader)
                NovaAppBar(
                  title: widget.title,
                  actions: widget.actions,
                  glowIntensity: widget.glowIntensity,
                  onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),

              if (widget.showFrameLines)
                Container(height: widget.borderWidth, color: novaTheme.primary),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: _getBodyDecoration(novaTheme),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Stack(
                      children: [
                        widget.body,

                        if (widget.showAngleDecoration)
                          ..._buildCornerDecorations(novaTheme),
                      ],
                    ),
                  ),
                ),
              ),

              if (widget.showFrameLines)
                Container(height: widget.borderWidth, color: novaTheme.primary),

              if (widget.showFooter) NovaFooter(),
            ],
          ),

          if (widget.floatingActionButton != null)
            Positioned(
              right: 16,
              bottom: widget.showFooter ? 50 : 16,
              child: widget.floatingActionButton!,
            ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations(NovaTheme theme) {
    return Stack(
      children: [
        if (widget.circuitPattern)
          IgnorePointer(
            child: Opacity(
              opacity: 0.06,
              child: CustomPaint(
                painter: NovaCircuitPainter(
                  color: theme.patternColor,
                  density: 0.7 + _pulseValue * 0.3,
                ),
                child: Container(),
              ),
            ),
          ),

        if (widget.hexagonalPattern)
          IgnorePointer(
            child: Opacity(
              opacity: 0.04,
              child: CustomPaint(
                painter: NovaHexagonPainter(color: theme.patternColor),
                child: Container(),
              ),
            ),
          ),

        if (widget.digitalNoise && _showNoise)
          IgnorePointer(
            child: CustomPaint(
              painter: NovaNoisePainter(
                color: theme.textPrimary,
                opacity: 0.03,
              ),
              child: Container(),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildCornerDecorations(NovaTheme theme) {
    return [
      Positioned(
        left: 0,
        top: 0,
        child: SizedBox(
          width: 24,
          height: 24,
          child: CustomPaint(painter: NovaAnglePainter(color: theme.primary)),
        ),
      ),
      Positioned(
        right: 0,
        top: 0,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(3.14159),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CustomPaint(painter: NovaAnglePainter(color: theme.primary)),
          ),
        ),
      ),
      Positioned(
        left: 0,
        bottom: 0,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(3.14159),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CustomPaint(painter: NovaAnglePainter(color: theme.primary)),
          ),
        ),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(3.14159),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CustomPaint(painter: NovaAnglePainter(color: theme.primary)),
          ),
        ),
      ),
    ];
  }

  BoxDecoration _getBodyDecoration(NovaTheme theme) {
    BoxBorder? border;

    switch (widget.borderStyle) {
      case NovaBorderStyle.solid:
        border = Border.all(color: theme.primary, width: widget.borderWidth);
        break;
      case NovaBorderStyle.double:
        border = Border(
          top: BorderSide(color: theme.primary, width: widget.borderWidth),
          left: BorderSide(color: theme.primary, width: widget.borderWidth),
          right: BorderSide(color: theme.secondary, width: widget.borderWidth),
          bottom: BorderSide(color: theme.secondary, width: widget.borderWidth),
        );
        break;
      case NovaBorderStyle.glow:
        border = Border.all(
          color: theme.glow.withOpacity(0.8),
          width: widget.borderWidth,
        );
        break;
      case NovaBorderStyle.dashed:
      case NovaBorderStyle.none:
        border = null;
        break;
    }

    return BoxDecoration(
      color: theme.background,
      border: border,
      boxShadow:
          widget.borderStyle == NovaBorderStyle.glow
              ? [
                BoxShadow(
                  color: theme.glow.withOpacity(widget.glowIntensity * 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
              : null,
    );
  }
}
