import 'package:flutter/material.dart';
import 'package:nova_ui/components/buttons/nova_border_style.dart';
import 'package:nova_ui/components/buttons/nova_button.dart';
import 'package:nova_ui/components/buttons/nova_button_style.dart';
import 'package:nova_ui/components/dialogs/nova_dialog.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';
import 'package:nova_ui/components/nova_scaffold.dart';
import 'package:nova_ui/components/theme/nova_theme_data.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;

    return NovaScaffold(
      title: 'Dialogs & Alerts',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Dialog Examples'),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildDialogButton(
                    context,
                    'Standard Dialog',
                    () => _showStandardDialog(context),
                  ),
                  _buildDialogButton(
                    context,
                    'Boot Animation',
                    () => _showBootAnimationDialog(context),
                  ),
                  _buildDialogButton(
                    context,
                    'Glitch Effect',
                    () => _showGlitchDialog(context),
                  ),
                  _buildDialogButton(
                    context,
                    'Emergency',
                    () => _showEmergencyDialog(context),
                  ),
                  _buildDialogButton(
                    context,
                    'Circuit Pattern',
                    () => _showCircuitPatternDialog(context),
                  ),
                  _buildDialogButton(
                    context,
                    'Theme Aware',
                    () => _showThemeAwareDialog(context),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              _buildSectionTitle(context, 'Dialog Features'),
              const SizedBox(height: 16),
              Text(
                '• Typewriter text animation\n'
                '• Boot sequence animation\n'
                '• Custom border styles\n'
                '• Theme-aware styling\n'
                '• Glitch effects\n'
                '• Scan line overlays\n'
                '• Custom content\n'
                '• Sound effects support\n',
                style: theme.getBodyStyle(fontSize: 16),
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

  Widget _buildDialogButton(
    BuildContext context,
    String title,
    VoidCallback onPressed,
  ) {
    final theme = context.novaTheme;

    return SizedBox(
      width: 200,
      child: NovaButton(
        text: title.toUpperCase(),
        onPressed: onPressed,
        style: theme.getButtonStyleByCurrentNovaTheme(theme),
        borderStyle: NovaBorderStyle.solid,
      ),
    );
  }

  void _showStandardDialog(BuildContext context) {
    NovaDialog.show(
      context: context,
      title: 'Standard Dialog',
      message:
          'This is a standard Nova dialog with default settings. It uses the current theme colors and adapts to theme changes.',
      confirmText: 'CONFIRM',
      cancelText: 'CANCEL',
      glitchEffect: false,
      scanLines: true,
      bootAnimation: false,
    );
  }

  void _showBootAnimationDialog(BuildContext context) {
    NovaDialog.show(
      context: context,
      title: 'System Boot',
      message:
          'Initializing systems...\nLoading kernel modules...\nConnecting to mainframe...\nEstablishing secure connection...\nSystem ready.',
      confirmText: 'PROCEED',
      cancelText: 'ABORT',
      bootAnimation: true,
      scanLines: true,
      typewriterAnimation: true,
      glitchEffect: false,
    );
  }

  void _showGlitchDialog(BuildContext context) {
    NovaDialog.show(
      context: context,
      title: 'WARNING: SYSTEM BREACH',
      message:
          'Critical security breach detected in main subsystem. Initiate emergency lockdown protocol immediately!',
      confirmText: 'LOCK DOWN',
      cancelText: 'IGNORE',
      glitchEffect: true,
      scanLines: true,
      bootAnimation: true,
      icon: Icons.warning_amber_rounded,
      borderStyle: NovaBorderStyle.glow,
      soundEffects: true,
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    NovaDialog.show(
      context: context,
      title: 'EMERGENCY ALERT',
      message:
          'Emergency protocol activated. All personnel evacuate immediately. This is not a drill.',
      confirmText: 'ACKNOWLEDGE',
      cancelText: null,
      borderStyle: NovaBorderStyle.solid,
      glitchEffect: true,
      emergencyLights: true,
      icon: Icons.warning_rounded,
      confirmButtonStyle: NovaButtonStyle.alert,
      soundEffects: true,
    );
  }

  void _showCircuitPatternDialog(BuildContext context) {
    NovaDialog.show(
      context: context,
      title: 'Circuit Analysis',
      message:
          'Neural network pathways optimized. Processing efficiency increased by 24.7%. Continue with implementation?',
      confirmText: 'IMPLEMENT',
      cancelText: 'REVIEW',
      circuitPattern: true,
      scanLines: false,
      bootAnimation: false,
      borderStyle: NovaBorderStyle.dashed,
      glowIntensity: 0.8,
      animationStyle: NovaAnimationStyle.subtle,
    );
  }

  void _showThemeAwareDialog(BuildContext context) {
    final theme = context.novaTheme;

    String themeName = 'Current';
    if (theme == NovaThemeData.terminal) {
      themeName = 'Terminal';
    } else if (theme == NovaThemeData.cyberpunk)
      themeName = 'Cyberpunk';
    else if (theme == NovaThemeData.hologram)
      themeName = 'Hologram';
    else if (theme == NovaThemeData.amber)
      themeName = 'Amber';
    else if (theme == NovaThemeData.matrix)
      themeName = 'Matrix';
    else if (theme == NovaThemeData.alert)
      themeName = 'Alert';
    else if (theme == NovaThemeData.tron)
      themeName = 'Tron';
    else if (theme == NovaThemeData.synthwave)
      themeName = 'Synthwave';

    NovaDialog.show(
      context: context,
      title: '$themeName Theme Dialog',
      message:
          'This dialog automatically adapts to the current theme. Try changing themes to see how it updates all UI elements including buttons and borders.',
      confirmText: 'AWESOME',
      cancelText: 'CLOSE',
      icon: Icons.palette_outlined,
      borderStyle: NovaBorderStyle.glow,
      scanLines: true,
      glitchEffect: false,
      bootAnimation: true,
    );
  }
}
