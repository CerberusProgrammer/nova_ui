import 'package:flutter/material.dart';
import 'package:nova_ui/buttons/nova_border_style.dart';
import 'package:nova_ui/buttons/nova_button.dart';
import 'package:nova_ui/buttons/nova_icon_button.dart';
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

  void _changeTheme(NovaTheme newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
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
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NovaButton(text: "LAUNCH", onPressed: () {}),
                  NovaIconButton(icon: Icons.play_arrow, onPressed: () {}),
                  NovaButton(
                    text: "INITIALIZE",
                    onPressed: () {},
                    animationStyle: NovaAnimationStyle.dramatic,
                    borderStyle: NovaBorderStyle.dashed,
                  ),
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
