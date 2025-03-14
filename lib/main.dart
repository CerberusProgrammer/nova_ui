import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_data.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/theme/theme_service.dart';
import 'package:nova_ui/config/app_routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var _currentTheme = NovaThemeData.terminal;

  @override
  Widget build(BuildContext context) {
    return NovaThemeProvider(
      theme: _currentTheme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nova UI Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: _currentTheme.background,
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: _currentTheme.textPrimary),
            titleLarge: TextStyle(color: _currentTheme.textPrimary),
          ),
        ),
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.home,
        navigatorKey: ThemeService.navigatorKey,
        builder: (context, child) {
          return ThemeService(
            currentTheme: _currentTheme,
            onThemeChanged: (newTheme) {
              setState(() {
                _currentTheme = newTheme;
              });
            },
            child: child!,
          );
        },
      ),
    );
  }
}
