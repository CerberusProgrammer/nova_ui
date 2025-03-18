import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/config/app_routes.dart';
import 'package:nova_ui/components/scaffold/nova_theme_selector.dart';
import 'package:nova_ui/components/scaffold/decorations/nova_angle_painter.dart';
import 'package:nova_ui/components/scaffold/decorations/nova_circuit_painter.dart';

class NovaDrawer extends StatelessWidget {
  final bool showCircuitPattern;

  const NovaDrawer({super.key, this.showCircuitPattern = true});

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;

    return Drawer(
      width: 280,
      backgroundColor: theme.surface,
      child: Column(
        children: [
          _buildHeader(context, theme),
          _buildNavItems(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NovaTheme theme) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: theme.primary,
        boxShadow: [
          BoxShadow(
            color: theme.glow.withOpacity(theme.glowIntensity * 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (showCircuitPattern)
            Opacity(
              opacity: 0.15,
              child: CustomPaint(
                painter: NovaCircuitPainter(color: theme.accent),
                size: const Size(280, 160),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NOVA UI',
                  style: theme.getHeadingStyle(fontSize: 28, withGlow: true),
                ),
                const SizedBox(height: 8),
                Text(
                  'Component Library',
                  style: theme.getBodyStyle(fontSize: 16),
                ),
                const Spacer(),
                Text('Version 0.1.0', style: theme.getBodyStyle(fontSize: 12)),
              ],
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 30,
              height: 30,
              child: CustomPaint(
                painter: NovaAnglePainter(color: theme.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItems(BuildContext context, NovaTheme theme) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildNavigationItem(
            context: context,
            icon: Icons.home,
            title: 'Home',
            route: AppRoutes.home,
            theme: theme,
          ),
          _buildNavigationItem(
            context: context,
            icon: Icons.smart_button,
            title: 'Buttons',
            route: AppRoutes.buttons,
            theme: theme,
          ),
          _buildNavigationItem(
            context: context,
            icon: Icons.chat_bubble,
            title: 'Dialogs',
            route: AppRoutes.dialogs,
            theme: theme,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('THEMES', style: theme.getHeadingStyle(fontSize: 16)),
          ),
          NovaThemeSelector(currentTheme: theme),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required NovaTheme theme,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? theme.primary.withOpacity(0.2) : Colors.transparent,
        border: Border.all(
          color: isSelected ? theme.accent : Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? theme.accent : theme.textPrimary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? theme.accent : theme.textPrimary,
            fontFamily: theme.getFontFamily(theme.secondaryFontFamily),
          ),
        ),
        onTap: () {
          if (currentRoute != route) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
