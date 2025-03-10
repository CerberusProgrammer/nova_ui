import 'package:flutter/material.dart';
import 'package:nova_ui/buttons/nova_animation_style.dart';
import 'package:nova_ui/buttons/nova_button.dart';
import 'package:nova_ui/buttons/nova_button_style.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text('Hello World!'),
                  SizedBox(height: 20),
                  NovaButton(text: "LAUNCH", onPressed: () {}),
                  NovaButton(
                    animationStyle: NovaAnimationStyle.subtle,
                    text: "CUSTOM",
                    style: NovaButtonStyle.hologram,
                    borderWidth: 3.0,
                    glowIntensity: 1.0,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
