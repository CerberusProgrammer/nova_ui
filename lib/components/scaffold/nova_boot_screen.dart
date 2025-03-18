import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';

class NovaBootScreen extends StatelessWidget {
  final double bootProgress;
  final String statusMessage;

  const NovaBootScreen({
    super.key,
    required this.bootProgress,
    required this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: theme.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: theme.glow.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SYSTEM BOOT",
                style: theme.getHeadingStyle(fontSize: 20, withGlow: true),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: bootProgress,
                backgroundColor: theme.background,
                color: theme.primary,
              ),
              const SizedBox(height: 12),
              Text(statusMessage, style: theme.getBodyStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
