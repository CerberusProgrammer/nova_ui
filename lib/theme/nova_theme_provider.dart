import 'package:flutter/material.dart';
import 'package:nova_ui/theme/nova_theme.dart';
import 'package:nova_ui/theme/nova_theme_data.dart';

/// Provider for NovaTheme that can be accessed throughout the app
class NovaThemeProvider extends InheritedWidget {
  final NovaTheme theme;

  const NovaThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  static NovaThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NovaThemeProvider>();
  }

  static NovaTheme themeOf(BuildContext context) {
    final provider = NovaThemeProvider.of(context);
    return provider?.theme ??
        NovaThemeData.terminal; // Default to terminal theme
  }

  @override
  bool updateShouldNotify(NovaThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}

/// Extension method to easily get the NovaTheme
extension NovaThemeExtension on BuildContext {
  NovaTheme get novaTheme => NovaThemeProvider.themeOf(this);
}
