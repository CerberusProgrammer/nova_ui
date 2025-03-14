import 'package:flutter/material.dart';
import 'package:nova_ui/components/nova_scaffold.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;

    return NovaScaffold(
      title: 'Nova UI Demo',
      digitalNoise: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.terminal, size: 80, color: theme.accent),
              const SizedBox(height: 24),
              Text('NOVA UI', style: theme.getHeadingStyle(fontSize: 32)),
              const SizedBox(height: 12),
              Text(
                'Retro-Futuristic Flutter Components',
                style: theme.getBodyStyle(fontSize: 18),
              ),
              const SizedBox(height: 48),
              _buildFeatureCard(
                context,
                icon: Icons.palette,
                title: 'Themeable',
                description: 'Fully customizable retro-futuristic themes',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                icon: Icons.auto_awesome,
                title: 'Animated',
                description: 'Built-in animations and effects',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                icon: Icons.view_module,
                title: 'Component Library',
                description: 'Explore various UI components',
              ),
              const SizedBox(height: 48),
              Text(
                'Use the drawer menu to navigate between components',
                style: theme.getBodyStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = context.novaTheme;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.glow.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: theme.accent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.getHeadingStyle(fontSize: 18)),
                const SizedBox(height: 4),
                Text(description, style: theme.getBodyStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
