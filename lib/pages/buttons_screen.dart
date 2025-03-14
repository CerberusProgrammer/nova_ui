import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nova_ui/components/buttons/nova_border_style.dart';
import 'package:nova_ui/components/buttons/nova_button.dart';
import 'package:nova_ui/components/buttons/nova_button_style.dart';
import 'package:nova_ui/components/buttons/nova_icon_button.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';
import 'package:nova_ui/components/loaders/nova_bar_progress.dart';
import 'package:nova_ui/components/nova_scaffold.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  bool _isLoading = false;
  double _progressValue = 0.0;
  Timer? _progressTimer;
  String _loadingText = "System initializing...";

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startLoading() {
    _progressTimer?.cancel();

    setState(() {
      _isLoading = true;
      _progressValue = 0.0;
      _loadingText = "System initializing...";
    });

    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
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
  Widget build(BuildContext context) {
    return NovaScaffold(
      title: 'Buttons & Controls',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Standard Buttons'),
              const SizedBox(height: 24),
              _buildButtonRow([
                NovaButton(
                  text: "TERMINAL",
                  style: NovaButtonStyle.terminal,
                  onPressed: () {},
                ),
                NovaButton(
                  text: "MATRIX",
                  style: NovaButtonStyle.matrix,
                  onPressed: () {},
                ),
                NovaButton(
                  text: "NEON",
                  style: NovaButtonStyle.neon,
                  onPressed: () {},
                ),
              ]),
              const SizedBox(height: 16),
              _buildButtonRow([
                NovaButton(
                  text: "WARNING",
                  style: NovaButtonStyle.warning,
                  onPressed: () {},
                ),
                NovaButton(
                  text: "ALERT",
                  style: NovaButtonStyle.alert,
                  onPressed: () {},
                ),
                NovaButton(
                  text: "HOLOGRAM",
                  style: NovaButtonStyle.hologram,
                  onPressed: () {},
                ),
              ]),
              const SizedBox(height: 16),
              _buildButtonRow([
                NovaButton(
                  text: "AMBER",
                  style: NovaButtonStyle.amber,
                  onPressed: () {},
                ),
                NovaButton(
                  text: "TRON",
                  style: NovaButtonStyle.tron,
                  onPressed: () {},
                ),
              ]),

              const SizedBox(height: 40),
              _buildSectionTitle(context, 'Border Styles'),
              const SizedBox(height: 24),
              _buildButtonRow([
                NovaButton(
                  text: "SOLID",
                  borderStyle: NovaBorderStyle.solid,
                  onPressed: () {},
                ),
                NovaButton(
                  text: "DASHED",
                  borderStyle: NovaBorderStyle.dashed,
                  onPressed: () {},
                ),
                NovaButton(
                  text: "DOUBLE",
                  borderStyle: NovaBorderStyle.double,
                  onPressed: () {},
                ),
              ]),
              const SizedBox(height: 16),
              _buildButtonRow([
                NovaButton(
                  text: "GLOW",
                  borderStyle: NovaBorderStyle.glow,
                  onPressed: () {},
                ),
                NovaButton(
                  text: "NONE",
                  borderStyle: NovaBorderStyle.none,
                  onPressed: () {},
                ),
              ]),

              const SizedBox(height: 40),
              _buildSectionTitle(context, 'Animation Styles'),
              const SizedBox(height: 24),
              _buildButtonRow([
                NovaButton(
                  text: "STANDARD",
                  animationStyle: NovaAnimationStyle.standard,
                  onPressed: () {},
                ),
                NovaButton(
                  text: "DRAMATIC",
                  animationStyle: NovaAnimationStyle.dramatic,
                  onPressed: () {},
                ),
              ]),
              const SizedBox(height: 16),

              const SizedBox(height: 40),
              _buildSectionTitle(context, 'Icon Buttons'),
              const SizedBox(height: 24),
              _buildButtonRow([
                NovaIconButton(
                  icon: Icons.play_arrow,
                  onPressed: () {},
                  style: NovaButtonStyle.terminal,
                ),
                NovaIconButton(
                  icon: Icons.pause,
                  onPressed: () {},
                  style: NovaButtonStyle.matrix,
                ),
                NovaIconButton(
                  icon: Icons.stop,
                  onPressed: () {},
                  style: NovaButtonStyle.alert,
                ),
                NovaIconButton(
                  icon: Icons.skip_next,
                  onPressed: () {},
                  style: NovaButtonStyle.neon,
                ),
              ]),

              const SizedBox(height: 40),
              _buildSectionTitle(context, 'Progress Bars'),
              const SizedBox(height: 24),
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
              const SizedBox(height: 24),
              NovaBarProgress(
                value: _progressValue,
                animationDuration: const Duration(milliseconds: 300),
                textLabel: _loadingText,
                showPercentage: true,
                scanLines: true,
                borderStyle: NovaBorderStyle.solid,
                glitchEffect: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = context.novaTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: theme.getHeadingStyle(fontSize: 20)),
        const SizedBox(height: 8),
        Container(height: 2, width: 60, color: theme.primary),
      ],
    );
  }

  Widget _buildButtonRow(List<Widget> buttons) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.start,
      children: buttons,
    );
  }
}
