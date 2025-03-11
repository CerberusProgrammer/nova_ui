import 'package:flutter/material.dart';

/// Font family options for Nova UI
enum NovaFontFamily {
  /// System default font
  system,

  /// Terminal-style monospace font (ShareTechMono)
  terminal,

  /// Pixelated retro font (VT323)
  pixel,

  /// Modern sci-fi geometric font (Orbitron)
  scifi,

  /// 8-bit style gaming font (PressStart2P)
  arcade,

  /// Geometric display font (MajorMonoDisplay)
  futureDisplay,
}

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

  /// Primary font family for headings and focus elements
  final NovaFontFamily primaryFontFamily;

  /// Secondary font family for body text
  final NovaFontFamily secondaryFontFamily;

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
    this.primaryFontFamily = NovaFontFamily.terminal,
    this.secondaryFontFamily = NovaFontFamily.system,
  });

  /// Get the actual font family name based on NovaFontFamily enum
  String getFontFamily(NovaFontFamily fontFamily) {
    switch (fontFamily) {
      case NovaFontFamily.terminal:
        return 'ShareTechMono';
      case NovaFontFamily.pixel:
        return 'VT323';
      case NovaFontFamily.scifi:
        return 'Orbitron';
      case NovaFontFamily.arcade:
        return 'PressStart2P';
      case NovaFontFamily.futureDisplay:
        return 'MajorMonoDisplay';
      case NovaFontFamily.system:
      default:
        return ''; // Uses system default
    }
  }

  /// Get text style with appropriate font and styling for headings
  TextStyle getHeadingStyle({
    double? fontSize,
    FontWeight fontWeight = FontWeight.bold,
    double letterSpacing = 1.2,
    bool withGlow = true,
  }) {
    return TextStyle(
      fontFamily: getFontFamily(primaryFontFamily),
      color: textPrimary,
      fontSize: fontSize ?? 24.0,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      shadows:
          withGlow
              ? [
                Shadow(
                  color: glow.withOpacity(textGlowIntensity * 0.5),
                  blurRadius: 8.0,
                ),
              ]
              : null,
    );
  }

  /// Get text style with appropriate font and styling for body text
  TextStyle getBodyStyle({
    double? fontSize,
    FontWeight fontWeight = FontWeight.normal,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: getFontFamily(secondaryFontFamily),
      color: textSecondary,
      fontSize: fontSize ?? 16.0,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
  }

  /// Get text style for buttons
  TextStyle getButtonTextStyle({
    required Color textColor,
    double? fontSize,
    FontWeight fontWeight = FontWeight.bold,
    double letterSpacing = 1.2,
    bool withGlow = true,
    double glowIntensity = 1.0,
  }) {
    return TextStyle(
      fontFamily: getFontFamily(primaryFontFamily),
      color: textColor,
      fontSize: fontSize ?? 16.0,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      shadows:
          withGlow
              ? [
                Shadow(
                  color: glow.withOpacity(textGlowIntensity * glowIntensity),
                  blurRadius: 8.0,
                ),
              ]
              : null,
    );
  }

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
    NovaFontFamily? primaryFontFamily,
    NovaFontFamily? secondaryFontFamily,
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
      primaryFontFamily: primaryFontFamily ?? this.primaryFontFamily,
      secondaryFontFamily: secondaryFontFamily ?? this.secondaryFontFamily,
    );
  }
}
