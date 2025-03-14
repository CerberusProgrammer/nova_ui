import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/scaffold/decorations/nova_angle_painter.dart';

class NovaAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback onMenuPressed;
  final double glowIntensity;

  const NovaAppBar({
    super.key,
    required this.title,
    this.actions,
    required this.onMenuPressed,
    this.glowIntensity = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.glow.withOpacity(glowIntensity * 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(left: 0, top: 0, child: _buildAngle(16, 16, theme.accent)),
          Positioned(
            right: 0,
            top: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: _buildAngle(16, 16, theme.accent),
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: theme.textPrimary),
                onPressed: onMenuPressed,
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RichText(
                    text: TextSpan(
                      text: "> ",
                      style: TextStyle(
                        color: theme.accent,
                        fontFamily: theme.getFontFamily(
                          theme.primaryFontFamily,
                        ),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: title.toUpperCase(),
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontFamily: theme.getFontFamily(
                              theme.primaryFontFamily,
                            ),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: theme.glow.withOpacity(
                                  theme.textGlowIntensity * 0.5,
                                ),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: " _",
                          style: TextStyle(
                            color: theme.accent,
                            fontFamily: theme.getFontFamily(
                              theme.primaryFontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (actions != null) ...actions!,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAngle(double width, double height, Color color) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: NovaAnglePainter(color: color)),
    );
  }
}
