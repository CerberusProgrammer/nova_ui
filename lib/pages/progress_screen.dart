import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nova_ui/components/buttons/nova_border_style.dart';
import 'package:nova_ui/components/buttons/nova_button.dart';
import 'package:nova_ui/components/buttons/nova_button_size.dart';
import 'package:nova_ui/components/buttons/nova_button_style.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';
import 'package:nova_ui/components/effects/nova_bar_loading_effect.dart';
import 'package:nova_ui/components/loaders/nova_bar_progress.dart';
import 'package:nova_ui/components/nova_scaffold.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/dialogs/nova_dialog.dart';

const double _kSmallPadding = 12.0;
const double _kNormalPadding = 16.0;
const double _kLargePadding = 24.0;
const double _kBorderRadius = 8.0;
const double _kSmallSpacing = 8.0;

const double _kVerySmallScreenWidth = 360.0;
const double _kSmallScreenWidth = 400.0;
const double _kMediumScreenWidth = 600.0;
const double _kLargeScreenWidth = 800.0;

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // Progress values for different examples
  double _standardProgress = 0.0;
  double _terminalProgress = 0.0;
  double _digitalProgress = 0.0;
  double _randomProgress = 0.0;
  double _dialogProgress = 0.0;

  // Timer instances
  Timer? _standardTimer;
  Timer? _terminalTimer;
  Timer? _digitalTimer;
  Timer? _randomTimer;
  Timer? _centerTimer;
  Timer? _dialogTimer;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    // Podríamos inicializar alguna configuración aquí si fuera necesario
  }

  @override
  void dispose() {
    // Cancelar todos los timers para evitar memory leaks
    _cancelAllTimers();
    super.dispose();
  }

  /// Cancela todos los timers activos
  void _cancelAllTimers() {
    _standardTimer?.cancel();
    _terminalTimer?.cancel();
    _digitalTimer?.cancel();
    _randomTimer?.cancel();
    _centerTimer?.cancel();
    _dialogTimer?.cancel();
  }

  /// Toggle para la barra de progreso estándar
  void _toggleStandardProgress() {
    if (_standardTimer != null) {
      _standardTimer?.cancel();
      _standardTimer = null;
      setState(() => _standardProgress = 0.0);
    } else {
      _standardTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
        setState(() {
          _standardProgress += 0.01;
          if (_standardProgress >= 1.0) _standardProgress = 0.0;
        });
      });
    }
  }

  /// Toggle para la barra de progreso de terminal
  void _toggleTerminalProgress() {
    if (_terminalTimer != null) {
      _terminalTimer?.cancel();
      _terminalTimer = null;
      setState(() => _terminalProgress = 0.0);
    } else {
      _terminalTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() {
          _terminalProgress += 0.02;
          if (_terminalProgress >= 1.0) {
            _terminalProgress = 1.0;
            _terminalTimer?.cancel();
            _terminalTimer = null;
          }
        });
      });
    }
  }

  /// Toggle para la barra de progreso digital
  void _toggleDigitalProgress() {
    if (_digitalTimer != null) {
      _digitalTimer?.cancel();
      _digitalTimer = null;
      setState(() => _digitalProgress = 0.0);
    } else {
      _digitalTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
        setState(() => _digitalProgress = Random().nextDouble());
      });
    }
  }

  /// Toggle para la barra de progreso random
  void _toggleRandomProgress() {
    if (_randomTimer != null) {
      _randomTimer?.cancel();
      _randomTimer = null;
      setState(() => _randomProgress = 0.0);
    } else {
      _randomTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
        setState(() {
          _randomProgress += Random().nextDouble() * 0.2;
          if (_randomProgress >= 1.0) {
            _randomProgress = 1.0;
            _randomTimer?.cancel();
            _randomTimer = null;
          }
        });
      });
    }
  }

  void _showDialogWithProgress(BuildContext context) {
    if (_isDialogOpen) return;
    _isDialogOpen = true;
    _dialogProgress = 0.0;

    _dialogTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted || !_isDialogOpen) {
        _dialogTimer?.cancel();
        _dialogTimer = null;
        return;
      }

      setState(() {
        _dialogProgress += 0.01;
        if (_dialogProgress >= 1.0) {
          _dialogTimer?.cancel();
          _dialogTimer = null;
          _isDialogOpen = false;
          Navigator.of(context).pop();
        }
      });
    });

    NovaDialog.show(
      context: context,
      title: 'DATA DOWNLOAD',
      message:
          'Downloading necessary cybernetic files. Please wait while the process completes.',
      confirmText: 'ABORT',
      cancelText: null,
      bootAnimation: false,
      scanLines: true,
      glitchEffect: _dialogProgress > 0.7,
      animationStyle: NovaAnimationStyle.subtle,
      borderStyle: NovaBorderStyle.glow,
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: NovaBarProgress(
              value: _dialogProgress,
              height: 16,
              barCount: 12,
              glowIntensity: 0.8,
              loadingEffect: NovaBarLoadingEffect.sequential,
              borderStyle: NovaBorderStyle.solid,
            ),
          );
        },
      ),
      onConfirm: () {
        _dialogTimer?.cancel();
        _dialogTimer = null;
        _isDialogOpen = false;
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < _kMediumScreenWidth;

    return NovaScaffold(
      title: 'Progress Indicators',
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(
              isSmallScreen ? _kNormalPadding : _kLargePadding,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (isSmallScreen ? 32 : 48),
                  maxWidth: 1200,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInteractiveProgressSection(context),
                    const SizedBox(height: _kLargePadding),
                    _buildVerticalProgressSection(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construye una tarjeta contenedora con estilo consistente
  Widget _buildCard({required Widget child, required BuildContext context}) {
    final theme = context.novaTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < _kMediumScreenWidth;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? _kSmallPadding : _kNormalPadding),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(_kBorderRadius),
        border: Border.all(color: theme.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.glow.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }

  /// Construye la sección de demostraciones interactivas
  Widget _buildInteractiveProgressSection(BuildContext context) {
    final theme = context.novaTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < _kMediumScreenWidth;

    return _buildCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "INTERACTIVE PROGRESS DEMOS",
            style: theme.getHeadingStyle(fontSize: isSmallScreen ? 14 : 16),
          ),
          const SizedBox(height: _kNormalPadding),
          Wrap(
            spacing: _kNormalPadding,
            runSpacing: _kNormalPadding,
            alignment: WrapAlignment.center,
            children: [
              _buildProgressButton(
                "Standard",
                _standardProgress,
                _toggleStandardProgress,
                NovaButtonStyle.terminal,
                theme,
              ),
              _buildProgressButton(
                "Terminal",
                _terminalProgress,
                _toggleTerminalProgress,
                NovaButtonStyle.matrix,
                theme,
              ),
              _buildProgressButton(
                "Digital",
                _digitalProgress,
                _toggleDigitalProgress,
                NovaButtonStyle.amber,
                theme,
              ),
            ],
          ),
          const SizedBox(height: _kNormalPadding),
          Wrap(
            spacing: _kNormalPadding,
            runSpacing: _kNormalPadding,
            alignment: WrapAlignment.center,
            children: [
              _buildProgressButton(
                "Random",
                _randomProgress,
                _toggleRandomProgress,
                NovaButtonStyle.alert,
                theme,
              ),
              NovaButton(
                text: "Dialog",
                style: NovaButtonStyle.hologram,
                size: NovaButtonSize.medium,
                borderStyle: NovaBorderStyle.solid,
                onPressed: () => _showDialogWithProgress(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construye un botón con una barra de progreso asociada
  Widget _buildProgressButton(
    String label,
    double value,
    VoidCallback onPressed,
    NovaButtonStyle style,
    dynamic theme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NovaBarProgress(
          value: value,
          height: 12,
          width: 120,
          barCount: 8,
          borderStyle: NovaBorderStyle.none,
        ),
        const SizedBox(height: _kSmallSpacing),
        NovaButton(
          text: label,
          style: style,
          size: NovaButtonSize.small,
          borderStyle: NovaBorderStyle.solid,
          onPressed: onPressed,
        ),
      ],
    );
  }

  Widget _buildVerticalProgressSection(BuildContext context) {
    final theme = context.novaTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < _kMediumScreenWidth;

    return _buildCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MULTI-TASK PROCESSING",
            style: theme.getHeadingStyle(fontSize: isSmallScreen ? 14 : 16),
          ),
          const SizedBox(height: _kNormalPadding),
          _buildVerticalProgressRows(context),
        ],
      ),
    );
  }

  /// Organiza las barras de progreso verticales según el tamaño de pantalla
  Widget _buildVerticalProgressRows(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = context.novaTheme;

    // Configuración de tareas para consistencia
    final tasks = [
      {'label': 'TASK 1', 'value': 0.25, 'style': NovaButtonStyle.terminal},
      {'label': 'TASK 2', 'value': 0.78, 'style': NovaButtonStyle.matrix},
      {'label': 'TASK 3', 'value': 0.44, 'style': NovaButtonStyle.amber},
      {'label': 'TASK 4', 'value': 0.9, 'style': NovaButtonStyle.alert},
    ];

    if (screenWidth < _kSmallScreenWidth) {
      // Pantalla muy pequeña: 2x2 grid
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildVerticalProgress(
                tasks[0]['label'] as String,
                tasks[0]['value'] as double,
                theme,
                tasks[0]['style'] as NovaButtonStyle,
              ),
              _buildVerticalProgress(
                tasks[1]['label'] as String,
                tasks[1]['value'] as double,
                theme,
                tasks[1]['style'] as NovaButtonStyle,
              ),
            ],
          ),
          const SizedBox(height: _kLargePadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildVerticalProgress(
                tasks[2]['label'] as String,
                tasks[2]['value'] as double,
                theme,
                tasks[2]['style'] as NovaButtonStyle,
              ),
              _buildVerticalProgress(
                tasks[3]['label'] as String,
                tasks[3]['value'] as double,
                theme,
                tasks[3]['style'] as NovaButtonStyle,
              ),
            ],
          ),
        ],
      );
    } else if (screenWidth < _kMediumScreenWidth) {
      // Pantalla pequeña: 3+1 layout
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildVerticalProgress(
                tasks[0]['label'] as String,
                tasks[0]['value'] as double,
                theme,
                tasks[0]['style'] as NovaButtonStyle,
              ),
              _buildVerticalProgress(
                tasks[1]['label'] as String,
                tasks[1]['value'] as double,
                theme,
                tasks[1]['style'] as NovaButtonStyle,
              ),
              _buildVerticalProgress(
                tasks[2]['label'] as String,
                tasks[2]['value'] as double,
                theme,
                tasks[2]['style'] as NovaButtonStyle,
              ),
            ],
          ),
          const SizedBox(height: _kLargePadding),
          Center(
            child: _buildVerticalProgress(
              tasks[3]['label'] as String,
              tasks[3]['value'] as double,
              theme,
              tasks[3]['style'] as NovaButtonStyle,
            ),
          ),
        ],
      );
    } else {
      // Pantalla mediana y grande: fila única
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            tasks
                .map(
                  (task) => _buildVerticalProgress(
                    task['label'] as String,
                    task['value'] as double,
                    theme,
                    task['style'] as NovaButtonStyle,
                  ),
                )
                .toList(),
      );
    }
  }

  /// Construye una barra de progreso vertical individual
  Widget _buildVerticalProgress(
    String label,
    double value,
    dynamic theme,
    NovaButtonStyle style,
  ) {
    final percentage = (value * 100).toInt();
    final colors = getColorScheme(style);
    final screenWidth = MediaQuery.of(context).size.width;

    // Ajuste dinámico del tamaño según el ancho de la pantalla
    late final double barWidth;
    late final double barHeight;
    late final double fontSize;

    if (screenWidth < _kVerySmallScreenWidth) {
      barWidth = 12.0;
      barHeight = 80.0;
      fontSize = 8.0;
    } else if (screenWidth < _kSmallScreenWidth) {
      barWidth = 14.0;
      barHeight = 100.0;
      fontSize = 9.0;
    } else if (screenWidth < _kMediumScreenWidth) {
      barWidth = 16.0;
      barHeight = 120.0;
      fontSize = 10.0;
    } else if (screenWidth < _kLargeScreenWidth) {
      barWidth = 18.0;
      barHeight = 140.0;
      fontSize = 11.0;
    } else {
      barWidth = 20.0;
      barHeight = 150.0;
      fontSize = 12.0;
    }

    // Usar AnimatedContainer para suavizar cambios
    return SizedBox(
      width: barWidth + 20, // Añadir margen para evitar desbordamiento
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.getBodyStyle(fontSize: fontSize),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _kSmallSpacing),
          SizedBox(
            width: barWidth,
            height: barHeight,
            child: Stack(
              children: [
                // Fondo de la barra
                Container(
                  width: barWidth,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: theme.background,
                    border: Border.all(color: theme.divider, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Barra de progreso animada
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: barHeight * value,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(3),
                    ),
                    child: Container(color: colors['primary']),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: _kSmallSpacing),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.getBodyStyle(fontSize: fontSize),
            child: Text("$percentage%"),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> getColorScheme(NovaButtonStyle style) {
    final theme = context.novaTheme;

    // Mapa de colores según el estilo
    switch (style) {
      case NovaButtonStyle.terminal:
        return {'primary': Colors.green};
      case NovaButtonStyle.matrix:
        return {'primary': Colors.lightGreen};
      case NovaButtonStyle.amber:
        return {'primary': Colors.amber};
      case NovaButtonStyle.alert:
        return {'primary': theme.error};
      case NovaButtonStyle.hologram:
        return {'primary': Colors.cyanAccent};
      default:
        return {'primary': theme.primary};
    }
  }
}
