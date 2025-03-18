import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme.dart';
import 'package:nova_ui/components/theme/nova_theme_data.dart';
import 'package:nova_ui/components/theme/theme_service.dart';

class NovaThemeSelector extends StatelessWidget {
  final NovaTheme currentTheme;

  const NovaThemeSelector({super.key, required this.currentTheme});

  @override
  Widget build(BuildContext context) {
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
