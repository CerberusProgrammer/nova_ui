import 'package:flutter/material.dart';
import 'package:nova_ui/theme/nova_theme.dart';

/// Contains pre-defined retro-futuristic theme presets for Nova UI
class NovaThemeData {
  /// Terminal theme - Inspired by classic computer terminals
  /// Dark green on black with subtle neon effects
  static const NovaTheme terminal = NovaTheme(
    primary: Color(0xFF2D8D82),
    secondary: Color(0xFF1F6159),
    accent: Color(0xFF50E3C2),
    textPrimary: Color(0xFFE0F2F1),
    textSecondary: Color(0xFFB2DFDB),
    background: Color(0xFF0A0F0E),
    surface: Color(0xFF162422),
    divider: Color(0xFF2D8D82),
    glow: Color(0xFF50E3C2),
    error: Color(0xFFE57373),
    success: Color(0xFF81C784),
    warning: Color(0xFFFFB74D),
    info: Color(0xFF4FC3F7),
    scanLineIntensity: 0.08,
    glowIntensity: 0.6,
    textGlowIntensity: 0.3,
    patternColor: Color(0xFF50E3C2),
    brightness: Brightness.dark,
  );

  /// Cyberpunk theme - Neon purples and blues with high contrast
  static const NovaTheme cyberpunk = NovaTheme(
    primary: Color(0xFF8E6AC7),
    secondary: Color(0xFF735AA3),
    accent: Color(0xFFFF71CE),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFCCCCCC),
    background: Color(0xFF0D0221),
    surface: Color(0xFF1A0B36),
    divider: Color(0xFF8E6AC7),
    glow: Color(0xFFFF71CE),
    error: Color(0xFFFF4081),
    success: Color(0xFF05FFA1),
    warning: Color(0xFFFFD300),
    info: Color(0xFF01CDFE),
    scanLineIntensity: 0.06,
    glowIntensity: 0.8,
    textGlowIntensity: 0.5,
    patternColor: Color(0xFF01CDFE),
    brightness: Brightness.dark,
  );

  /// Holographic theme - Blue-white transparent effects
  static const NovaTheme hologram = NovaTheme(
    primary: Color(0xFF5C8EC7),
    secondary: Color(0xFF4978AD),
    accent: Color(0xFF88CCFF),
    textPrimary: Color(0xFFE6F3FF),
    textSecondary: Color(0xFFC0E0FF),
    background: Color(0xFF0A1929),
    surface: Color(0xFF0F2A42),
    divider: Color(0xFF5C8EC7),
    glow: Color(0xFF88CCFF),
    error: Color(0xFFFF6B6B),
    success: Color(0xFF5BF1CD),
    warning: Color(0xFFFFD166),
    info: Color(0xFF118AB2),
    scanLineIntensity: 0.05,
    glowIntensity: 0.7,
    textGlowIntensity: 0.6,
    patternColor: Color(0xFF88CCFF),
    brightness: Brightness.dark,
  );

  /// Amber monochrome theme - Vintage computing aesthetic
  static const NovaTheme amber = NovaTheme(
    primary: Color(0xFFCD9D57),
    secondary: Color(0xFFB38545),
    accent: Color(0xFFFFBF69),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF333333),
    background: Color(0xFFF7ECD9),
    surface: Color(0xFFFFEFD6),
    divider: Color(0xFFB38545),
    glow: Color(0xFFCD9D57),
    error: Color(0xFFC23B22),
    success: Color(0xFF497E76),
    warning: Color(0xFFD17A22),
    info: Color(0xFF17657D),
    scanLineIntensity: 0.06,
    glowIntensity: 0.5,
    textGlowIntensity: 0.2,
    patternColor: Color(0xFFB38545),
    brightness: Brightness.light,
  );

  /// Matrix theme - Digital green aesthetic
  static const NovaTheme matrix = NovaTheme(
    primary: Color(0xFF4E9F78),
    secondary: Color(0xFF3C7D5E),
    accent: Color(0xFF00FF41),
    textPrimary: Color(0xFF00FF41),
    textSecondary: Color(0xFF0D8033),
    background: Color(0xFF080C08),
    surface: Color(0xFF0F190F),
    divider: Color(0xFF3C7D5E),
    glow: Color(0xFF00FF41),
    error: Color(0xFFFF3333),
    success: Color(0xFF00FF41),
    warning: Color(0xFFFFBA08),
    info: Color(0xFF3BCEAC),
    scanLineIntensity: 0.09,
    glowIntensity: 0.7,
    textGlowIntensity: 0.6,
    patternColor: Color(0xFF00FF41),
    brightness: Brightness.dark,
  );

  /// Alert theme - Red/amber emergency system look
  static const NovaTheme alert = NovaTheme(
    primary: Color(0xFF9A3B4A),
    secondary: Color(0xFF7A2F3C),
    accent: Color(0xFFFF5A5F),
    textPrimary: Color(0xFFFFEEEE),
    textSecondary: Color(0xFFFFCCCC),
    background: Color(0xFF1F0A0D),
    surface: Color(0xFF2D1215),
    divider: Color(0xFF9A3B4A),
    glow: Color(0xFFFF5A5F),
    error: Color(0xFFFF5A5F),
    success: Color(0xFF3AAFB9),
    warning: Color(0xFFFFB400),
    info: Color(0xFF64A1D0),
    scanLineIntensity: 0.1,
    glowIntensity: 0.8,
    textGlowIntensity: 0.4,
    patternColor: Color(0xFFFF5A5F),
    brightness: Brightness.dark,
  );

  /// Tron theme - Blue glow on dark aesthetic
  static const NovaTheme tron = NovaTheme(
    primary: Color(0xFF4FBDCF),
    secondary: Color(0xFF3A95A7),
    accent: Color(0xFF05D9E8),
    textPrimary: Color(0xFFDEF3F6),
    textSecondary: Color(0xFFAFE3E9),
    background: Color(0xFF010A13),
    surface: Color(0xFF01141F),
    divider: Color(0xFF4FBDCF),
    glow: Color(0xFF05D9E8),
    error: Color(0xFFFF3864),
    success: Color(0xFF00F0B5),
    warning: Color(0xFFF6AE2D),
    info: Color(0xFF19647E),
    scanLineIntensity: 0.07,
    glowIntensity: 0.9,
    textGlowIntensity: 0.7,
    patternColor: Color(0xFF05D9E8),
    brightness: Brightness.dark,
  );

  /// Synthwave theme - Purple/pink/blue vibrant sunset aesthetic
  static const NovaTheme synthwave = NovaTheme(
    primary: Color(0xFF7B2CBF),
    secondary: Color(0xFF5A189A),
    accent: Color(0xFFF72585),
    textPrimary: Color(0xFFF1F1F1),
    textSecondary: Color(0xFFCFCFCF),
    background: Color(0xFF10002B),
    surface: Color(0xFF240046),
    divider: Color(0xFF7B2CBF),
    glow: Color(0xFFF72585),
    error: Color(0xFFFF4D6D),
    success: Color(0xFF3BF4FB),
    warning: Color(0xFFFFB703),
    info: Color(0xFF4CC9F0),
    scanLineIntensity: 0.05,
    glowIntensity: 0.8,
    textGlowIntensity: 0.6,
    patternColor: Color(0xFFF72585),
    brightness: Brightness.dark,
  );

  /// Neo-brutalism theme - High contrast with bold colors
  static const NovaTheme neoBrutalism = NovaTheme(
    primary: Color(0xFF1746A2),
    secondary: Color(0xFF0F3173),
    accent: Color(0xFF5F9DF7),
    textPrimary: Color(0xFF1B1B1B),
    textSecondary: Color(0xFF4F4F4F),
    background: Color(0xFFF9F7F7),
    surface: Color(0xFFFFFFFF),
    divider: Color(0xFF1746A2),
    glow: Color(0xFF5F9DF7),
    error: Color(0xFFFF5252),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFFC107),
    info: Color(0xFF2196F3),
    scanLineIntensity: 0.03,
    glowIntensity: 0.4,
    textGlowIntensity: 0.1,
    patternColor: Color(0xFF1746A2),
    brightness: Brightness.light,
  );

  /// Dark minimal theme - Clean dark interface with subtle highlights
  static const NovaTheme darkMinimal = NovaTheme(
    primary: Color(0xFF455A64),
    secondary: Color(0xFF37474F),
    accent: Color(0xFF80DEEA),
    textPrimary: Color(0xFFECEFF1),
    textSecondary: Color(0xFFB0BEC5),
    background: Color(0xFF121212),
    surface: Color(0xFF212121),
    divider: Color(0xFF455A64),
    glow: Color(0xFF80DEEA),
    error: Color(0xFFCF6679),
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFCA28),
    info: Color(0xFF4DD0E1),
    scanLineIntensity: 0.04,
    glowIntensity: 0.5,
    textGlowIntensity: 0.2,
    patternColor: Color(0xFF455A64),
    brightness: Brightness.dark,
  );
}
