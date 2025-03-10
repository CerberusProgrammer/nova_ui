import 'package:flutter/material.dart';

/// The style variants available for [NovaButton]
enum NovaButtonStyle {
  /// Classic blue CRT terminal style with scan lines
  terminal,

  /// Red alert style with pulsing effect
  alert,

  /// Green matrix-inspired digital rain style
  matrix,

  /// Purple/pink neon cyberpunk style
  neon,

  /// Orange/yellow warning style
  warning,

  /// White/blue holographic style
  hologram,

  /// Amber monochrome vintage computer style
  amber,

  /// Tron-inspired blue glow style
  tron,
}

// Get the color scheme based on the selected style
Map<String, dynamic> getColorScheme(NovaButtonStyle style) {
  switch (style) {
    case NovaButtonStyle.terminal:
      // Muted teal-green terminal (clean and minimal)
      return {
        'primary': Color(0xFF2D8D82),
        'secondary': Color(0xFF1F6159),
        'text': Colors.white,
        'glow': Color(0x302D8D82),
        'scanIntensity': 0.08,
      };
    case NovaButtonStyle.alert:
      // Muted burgundy alert style (Alien Isolation inspired)
      return {
        'primary': Color(0xFF9A3B4A),
        'secondary': Color(0xFF7A2F3C),
        'text': Colors.white,
        'glow': Color(0x309A3B4A),
        'scanIntensity': 0.1,
      };
    case NovaButtonStyle.matrix:
      // Pastel green (more elegant take on matrix)
      return {
        'primary': Color(0xFF4E9F78),
        'secondary': Color(0xFF3C7D5E),
        'text': Colors.white,
        'glow': Color(0x304E9F78),
        'scanIntensity': 0.08,
      };
    case NovaButtonStyle.neon:
      // Softer neon purple (more elegant cyberpunk)
      return {
        'primary': Color(0xFF8E6AC7),
        'secondary': Color(0xFF735AA3),
        'text': Colors.white,
        'glow': Color(0x308E6AC7),
        'scanIntensity': 0.06,
      };
    case NovaButtonStyle.warning:
      // Amber/yellow warning (WALL-E inspired but more elegant)
      return {
        'primary': Color(0xFFD1994F),
        'secondary': Color(0xFFB07C3E),
        'text': Color(0xFF1A1A1A),
        'glow': Color(0x30D1994F),
        'scanIntensity': 0.04,
      };
    case NovaButtonStyle.hologram:
      // Subtle blue hologram (Mr. Incredible style but cleaner)
      return {
        'primary': Color(0xFF5C8EC7),
        'secondary': Color(0xFF4978AD),
        'text': Colors.white,
        'glow': Color(0x305C8EC7),
        'scanIntensity': 0.05,
      };
    case NovaButtonStyle.amber:
      // Muted amber tone (vintage computing with elegance)
      return {
        'primary': Color(0xFFCD9D57),
        'secondary': Color(0xFFB38545),
        'text': Color(0xFF1A1A1A),
        'glow': Color(0x30CD9D57),
        'scanIntensity': 0.06,
      };
    case NovaButtonStyle.tron:
      // Soft blue TRON style (elegant and minimal)
      return {
        'primary': Color(0xFF4FBDCF),
        'secondary': Color(0xFF3A95A7),
        'text': Colors.white,
        'glow': Color(0x304FBDCF),
        'scanIntensity': 0.07,
      };
  }
}
