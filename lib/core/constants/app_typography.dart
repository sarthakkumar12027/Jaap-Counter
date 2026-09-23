import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle headlineLarge(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle headlineMedium(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle counterDisplay(BuildContext context, {Color? color}) {
    return GoogleFonts.outfit(
      fontSize: 72,
      fontWeight: FontWeight.w500,
      letterSpacing: -1.0,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle mantraTitle(BuildContext context, {Color? color}) {
    return GoogleFonts.notoSans(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.2,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  static TextStyle labelSmall(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
