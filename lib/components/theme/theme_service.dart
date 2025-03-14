import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme.dart';

class ThemeService extends InheritedWidget {
  final NovaTheme currentTheme;
  final ValueChanged<NovaTheme> onThemeChanged;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const ThemeService({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
    required super.child,
  });

  static ThemeService of(BuildContext context) {
    final ThemeService? result =
        context.dependOnInheritedWidgetOfExactType<ThemeService>();
    assert(result != null, 'No ThemeService found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeService oldWidget) {
    return currentTheme != oldWidget.currentTheme;
  }

  static void changeTheme(BuildContext context, NovaTheme theme) {
    final themeService = ThemeService.of(context);
    themeService.onThemeChanged(theme);
  }
}
