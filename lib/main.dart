import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nova_ui/buttons/nova_border_style.dart';
import 'package:nova_ui/buttons/nova_button.dart';
import 'package:nova_ui/buttons/nova_button_style.dart';
import 'package:nova_ui/buttons/nova_icon_button.dart';
import 'package:nova_ui/loaders/nova_bar_progress.dart';
import 'package:nova_ui/theme/nova_theme.dart';
import 'package:nova_ui/theme/nova_theme_data.dart';
import 'package:nova_ui/theme/nova_theme_provider.dart';
import 'package:nova_ui/effects/nova_animation_style.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NovaThemeProvider(
      theme: NovaThemeData.terminal,
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: NovaThemeData.terminal.background,
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: NovaThemeData.terminal.textPrimary),
            titleLarge: TextStyle(color: NovaThemeData.terminal.textPrimary),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentTheme = NovaThemeData.terminal;
  bool _isLoading = false;
  double _progressValue = 0.0;
  Timer? _progressTimer;
  String _loadingText = "System initializing...";

  void _changeTheme(NovaTheme newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  void _startLoading() {
    _progressTimer?.cancel();

    setState(() {
      _isLoading = true;
      _progressValue = 0.0;
      _loadingText = "System initializing...";
    });

    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _progressValue += 0.01;

        if (_progressValue < 0.3) {
          _loadingText = "System initializing...";
        } else if (_progressValue < 0.6) {
          _loadingText = "Loading core modules...";
        } else if (_progressValue < 0.9) {
          _loadingText = "Configuring subsystems...";
        } else {
          _loadingText = "System ready";
        }

        if (_progressValue >= 1.0) {
          _progressValue = 0.0;
        }
      });
    });
  }

  void _stopLoading() {
    _progressTimer?.cancel();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NovaThemeProvider(
      theme: _currentTheme,
      child: Builder(
        builder: (context) {
          final theme = context.novaTheme;

          return Scaffold(
            backgroundColor: theme.background,
            appBar: AppBar(
              backgroundColor: theme.surface,
              title: Text(
                'NovaUI Demo',
                style: TextStyle(color: theme.textPrimary),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NovaButton(text: "LAUNCH", onPressed: () {}),
                  SizedBox(height: 20),
                  NovaIconButton(icon: Icons.play_arrow, onPressed: () {}),
                  SizedBox(height: 20),
                  NovaButton(
                    text: _isLoading ? "CANCEL" : "INITIALIZE",
                    onPressed: () {
                      if (_isLoading) {
                        _stopLoading();
                      } else {
                        _startLoading();
                      }
                    },
                    animationStyle: NovaAnimationStyle.dramatic,
                    borderStyle: NovaBorderStyle.dashed,
                    style:
                        _isLoading
                            ? NovaButtonStyle.alert
                            : NovaButtonStyle.terminal,
                  ),
                  SizedBox(height: 30),
                  NovaBarProgress(
                    value: _progressValue,
                    animationDuration: Duration(milliseconds: 300),
                    textLabel: _loadingText,
                    showPercentage: true,
                    scanLines: true,
                    borderStyle: NovaBorderStyle.solid,
                    glitchEffect: true,
                  ),
                  SizedBox(height: 30),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildThemeButton(NovaThemeData.terminal, 'Terminal'),
                      _buildThemeButton(NovaThemeData.cyberpunk, 'Cyberpunk'),
                      _buildThemeButton(NovaThemeData.hologram, 'Hologram'),
                      _buildThemeButton(NovaThemeData.amber, 'Amber'),
                      _buildThemeButton(NovaThemeData.matrix, 'Matrix'),
                      _buildThemeButton(NovaThemeData.alert, 'Alert'),
                      _buildThemeButton(NovaThemeData.tron, 'Tron'),
                      _buildThemeButton(NovaThemeData.synthwave, 'Synthwave'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeButton(NovaTheme theme, String label) {
    bool isSelected = _currentTheme == theme;

    return GestureDetector(
      onTap: () => _changeTheme(theme),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.primary,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? theme.accent : Colors.transparent,
            width: 2,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: theme.glow.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: theme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
