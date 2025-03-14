import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme.dart';
import 'package:nova_ui/components/theme/nova_theme_data.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/theme/theme_service.dart';
import 'package:nova_ui/config/app_routes.dart';

class NovaScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const NovaScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final novaTheme = context.novaTheme;

    return Scaffold(
      backgroundColor: novaTheme.background,
      appBar: AppBar(
        backgroundColor: novaTheme.surface,
        title: Text(
          title,
          style: TextStyle(
            color: novaTheme.textPrimary,
            fontFamily: novaTheme.getFontFamily(novaTheme.primaryFontFamily),
          ),
        ),
        iconTheme: IconThemeData(color: novaTheme.textPrimary),
        actions: actions,
      ),
      drawer: _buildDrawer(context, novaTheme),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }

  Drawer _buildDrawer(BuildContext context, NovaTheme theme) {
    return Drawer(
      backgroundColor: theme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.primary,
              boxShadow: [
                BoxShadow(
                  color: theme.glow.withAlpha(
                    ((theme.glowIntensity * 0.5) * 255).toInt(),
                  ),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
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
          _buildThemeSelectionGrid(context, theme),
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

    return ListTile(
      leading: Icon(icon, color: isSelected ? theme.accent : theme.textPrimary),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? theme.accent : theme.textPrimary,
          fontFamily: theme.getFontFamily(theme.secondaryFontFamily),
        ),
      ),
      tileColor: isSelected ? theme.primary.withOpacity(0.2) : null,
      onTap: () {
        if (currentRoute != route) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildThemeSelectionGrid(
    BuildContext context,
    NovaTheme currentTheme,
  ) {
    final themes = [
      {'theme': NovaThemeData.terminal, 'name': 'Terminal'},
      {'theme': NovaThemeData.cyberpunk, 'name': 'Cyberpunk'},
      {'theme': NovaThemeData.hologram, 'name': 'Hologram'},
      {'theme': NovaThemeData.amber, 'name': 'Amber'},
      {'theme': NovaThemeData.matrix, 'name': 'Matrix'},
      {'theme': NovaThemeData.alert, 'name': 'Alert'},
      {'theme': NovaThemeData.tron, 'name': 'Tron'},
      {'theme': NovaThemeData.synthwave, 'name': 'Synthwave'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            themes.map((themeData) {
              final theme = themeData['theme'] as NovaTheme;
              final name = themeData['name'] as String;
              final isSelected = currentTheme == theme;

              return GestureDetector(
                onTap: () {
                  ThemeService.changeTheme(context, theme);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 80,
                  height: 35,
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
                  child: Center(
                    child: Text(
                      name.substring(0, 3),
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
