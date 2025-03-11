import 'package:flutter/material.dart';
import 'package:nova_ui/buttons/nova_button_style.dart';

/// The central theme class for Nova UI components.
/// Handles retro-futuristic styling across the entire component library.
class NovaTheme {
  /// Primary color used for main elements
  final Color primary;

  /// Secondary/darker variant of the primary color
  final Color secondary;

  /// Accent color for highlights and important UI elements
  final Color accent;

  /// Main text color
  final Color textPrimary;

  /// Secondary text color for less important text
  final Color textSecondary;

  /// Background color for containers and surfaces
  final Color background;

  /// Surface color for cards, dialogs, etc.
  final Color surface;

  /// Color used for dividers and borders
  final Color divider;

  /// Glow color for neon/holographic effects
  final Color glow;

  /// Error/negative action color
  final Color error;

  /// Success/positive action color
  final Color success;

  /// Warning color
  final Color warning;

  /// Info color
  final Color info;

  /// Scan line intensity for CRT effects (0.0 to 1.0)
  final double scanLineIntensity;

  /// Glow intensity for illumination effects (0.0 to 1.0)
  final double glowIntensity;

  /// Text glow intensity (0.0 to 1.0)
  final double textGlowIntensity;

  /// Pattern color for circuit patterns and background details
  final Color patternColor;

  /// Brightness of the theme
  final Brightness brightness;

  const NovaTheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.background,
    required this.surface,
    required this.divider,
    required this.glow,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    this.scanLineIntensity = 0.08,
    this.glowIntensity = 0.6,
    this.textGlowIntensity = 0.8,
    required this.patternColor,
    required this.brightness,
  });

  NovaTheme copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? background,
    Color? surface,
    Color? divider,
    Color? glow,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
    double? scanLineIntensity,
    double? glowIntensity,
    double? textGlowIntensity,
    Color? patternColor,
    Brightness? brightness,
  }) {
    return NovaTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      divider: divider ?? this.divider,
      glow: glow ?? this.glow,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      scanLineIntensity: scanLineIntensity ?? this.scanLineIntensity,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      textGlowIntensity: textGlowIntensity ?? this.textGlowIntensity,
      patternColor: patternColor ?? this.patternColor,
      brightness: brightness ?? this.brightness,
    );
  }

  NovaTheme lerp(NovaTheme other, double t) {
    return NovaTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      scanLineIntensity:
          lerpDouble(scanLineIntensity, other.scanLineIntensity, t)!,
      glowIntensity: lerpDouble(glowIntensity, other.glowIntensity, t)!,
      textGlowIntensity:
          lerpDouble(textGlowIntensity, other.textGlowIntensity, t)!,
      patternColor: Color.lerp(patternColor, other.patternColor, t)!,
      brightness: t < 0.5 ? brightness : other.brightness,
    );
  }

  static double? lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  Map<String, dynamic> getButtonColors(NovaButtonStyle style) {
    switch (style) {
      case NovaButtonStyle.terminal:
        return {
          'primary': primary,
          'secondary': secondary,
          'text': textPrimary,
          'glow': glow.withAlpha((0.3 * 255).toInt()),
          'scanIntensity': scanLineIntensity,
        };
      case NovaButtonStyle.alert:
        return {
          'primary': error,
          'secondary': error.withAlpha((0.8 * 255).toInt()),
          'text': textPrimary,
          'glow': error.withAlpha((0.3 * 255).toInt()),
          'scanIntensity': scanLineIntensity,
        };
      case NovaButtonStyle.matrix:
        return {
          'primary': success.withAlpha((0.8 * 255).toInt()),
          'secondary': success.withAlpha((0.6 * 255).toInt()),
          'text': success,
          'glow': success.withAlpha((0.3 * 255).toInt()),
          'scanIntensity': scanLineIntensity * 1.2,
        };
      case NovaButtonStyle.neon:
        return {
          'primary': accent,
          'secondary': accent.withAlpha((0.8 * 255).toInt()),
          'text': textPrimary,
          'glow': accent.withAlpha((0.3 * 255).toInt()),
          'scanIntensity': scanLineIntensity * 0.8,
        };
      case NovaButtonStyle.warning:
        return {
          'primary': warning,
          'secondary': warning.withAlpha((0.8 * 255).toInt()),
          'text': brightness == Brightness.dark ? Colors.black : Colors.white,
          'glow': warning.withAlpha((0.3 * 255).toInt()),
          'scanIntensity': scanLineIntensity * 0.6,
        };
      case NovaButtonStyle.hologram:
        return {
          'primary': info,
          'secondary': info.withAlpha((0.8 * 255).toInt()),
          'text': textPrimary,
          'glow': info.withAlpha((0.3 * 255).toInt()),
          'scanIntensity': scanLineIntensity * 0.7,
        };
      case NovaButtonStyle.amber:
        final amberColor = Color(0xFFCD9D57);
        return {
          'primary': amberColor,
          'secondary': amberColor.withAlpha((0.8 * 255).toInt()),
          'text': brightness == Brightness.dark ? Colors.black : Colors.white,
          'glow': amberColor.withAlpha((0.3 * 255).toInt()),
          'scanIntensity': scanLineIntensity * 0.8,
        };
      case NovaButtonStyle.tron:
        final tronBlue = Color(0xFF4FBDCF);
        return {
          'primary': tronBlue,
          'secondary': tronBlue.withAlpha((0.8 * 255).toInt()),
          'text': textPrimary,
          'glow': tronBlue.withAlpha((0.3 * 255).toInt()),
          'scanIntensity': scanLineIntensity * 0.9,
        };
    }
  }
}
