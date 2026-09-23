import 'package:flutter/material.dart';

/// App Colors and Theme Palettes:
/// - Neutral base (#F7F7F5 light, near-black #121212 dark)
/// - Muted spiritual accents (Sage, Sand, Terracotta, Indigo, Copper, Lavender, Rose, Slate)
/// - No gradients, no neon colors
class AppColors {
  // Light Palette
  static const Color lightBackground = Color(0xFFF7F7F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFEFEFED);
  static const Color lightTextPrimary = Color(0xFF1C1C1E);
  static const Color lightTextSecondary = Color(0xFF6E6E73);
  static const Color lightTextTertiary = Color(0xFFA0A0A5);
  static const Color lightBorder = Color(0xFFE5E5E2);
  static const Color lightDivider = Color(0xFFEBEBE8);

  // Dark Palette
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceSubtle = Color(0xFF282828);
  static const Color darkTextPrimary = Color(0xFFF2F2F2);
  static const Color darkTextSecondary = Color(0xFFA0A0A5);
  static const Color darkTextTertiary = Color(0xFF636366);
  static const Color darkBorder = Color(0xFF2C2C2E);
  static const Color darkDivider = Color(0xFF232325);

  // Muted Accent Options
  static const List<MutedAccent> accents = [
    MutedAccent(
      name: 'Sage',
      color: Color(0xFF5F7D6B),
      darkColor: Color(0xFF7D9E8B),
      hex: '0xFF5F7D6B',
    ),
    MutedAccent(
      name: 'Sand',
      color: Color(0xFFB5A67B),
      darkColor: Color(0xFFD4C79F),
      hex: '0xFFB5A67B',
    ),
    MutedAccent(
      name: 'Terracotta',
      color: Color(0xFFC87050),
      darkColor: Color(0xFFE08D6F),
      hex: '0xFFC87050',
    ),
    MutedAccent(
      name: 'Indigo',
      color: Color(0xFF4C5B96),
      darkColor: Color(0xFF7585C2),
      hex: '0xFF4C5B96',
    ),
    MutedAccent(
      name: 'Copper',
      color: Color(0xFFB87333),
      darkColor: Color(0xFFD99557),
      hex: '0xFFB87333',
    ),
    MutedAccent(
      name: 'Lavender',
      color: Color(0xFF7E729B),
      darkColor: Color(0xFFA397BF),
      hex: '0xFF7E729B',
    ),
    MutedAccent(
      name: 'Rose',
      color: Color(0xFFAC6B78),
      darkColor: Color(0xFFCF8E9B),
      hex: '0xFFAC6B78',
    ),
    MutedAccent(
      name: 'Slate',
      color: Color(0xFF566771),
      darkColor: Color(0xFF788A94),
      hex: '0xFF566771',
    ),
  ];

  static MutedAccent getAccent(int index) {
    if (index < 0 || index >= accents.length) return accents[0];
    return accents[index];
  }

  static Color parseHex(String hexString, {Color fallback = const Color(0xFF5F7D6B)}) {
    try {
      final buffer = StringBuffer();
      if (hexString.startsWith('#')) {
        buffer.write('ff');
        buffer.write(hexString.replaceFirst('#', ''));
      } else if (hexString.startsWith('0x') || hexString.startsWith('0X')) {
        buffer.write(hexString.substring(2));
      } else {
        buffer.write(hexString);
      }
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}

class MutedAccent {
  final String name;
  final Color color;
  final Color darkColor;
  final String hex;

  const MutedAccent({
    required this.name,
    required this.color,
    required this.darkColor,
    required this.hex,
  });
}
