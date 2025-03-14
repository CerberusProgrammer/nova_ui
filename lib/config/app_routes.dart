import 'package:flutter/material.dart';
import 'package:nova_ui/pages/buttons_screen.dart';
import 'package:nova_ui/pages/dialogs_screen.dart';
import 'package:nova_ui/pages/home_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String buttons = '/buttons';
  static const String dialogs = '/dialogs';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    buttons: (context) => const ButtonsScreen(),
    dialogs: (context) => const DialogsScreen(),
  };
}
