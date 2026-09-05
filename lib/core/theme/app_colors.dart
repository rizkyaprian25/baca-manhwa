import 'package:flutter/material.dart';

/// Tokens warna: terang biru MangaIndo (light) + KuroYomi gelap (dark).
/// `lib/core/theme/app_colors.dart`.
class AppColors {
  AppColors._();

  // Brand (dark)
  static const Color primary = Color(0xFFD0BCFF);
  static const Color onPrimary = Color(0xFF3C0091);
  static const Color primaryContainer = Color(0xFFA078FF);
  static const Color onPrimaryContainer = Color(0xFF340080);
  static const Color inversePrimary = Color(0xFF6D3BD7);

  static const Color secondary = Color(0xFF4EDEA3);
  static const Color onSecondary = Color(0xFF003824);
  static const Color secondaryContainer = Color(0xFF00A572);

  static const Color tertiary = Color(0xFF7BD0FF);
  static const Color tertiaryContainer = Color(0xFF009BD1);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);

  // Dark surfaces
  static const Color darkSurface = Color(0xFF0F131C);
  static const Color darkOnSurface = Color(0xFFDFE2EE);
  static const Color darkOnSurfaceVariant = Color(0xFFCBC3D7);
  static const Color darkSurfaceLowest = Color(0xFF0A0E16);
  static const Color darkSurfaceLow = Color(0xFF181C24);
  static const Color darkSurfaceContainer = Color(0xFF1C2028);
  static const Color darkSurfaceHigh = Color(0xFF262A33);
  static const Color darkSurfaceBright = Color(0xFF353942);
  static const Color darkOutline = Color(0xFF958EA0);

  // Light — biru MangaIndo
  static const Color lightPrimary = Color(0xFF2F80D6);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFD9EAFB);
  static const Color lightSurface = Color(0xFFF1F6FB);
  static const Color lightOnSurface = Color(0xFF14202E);
  static const Color lightSurfaceContainer = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFE4EDF5);
  static const Color lightOutline = Color(0xFF9AA9B8);

  /// Hitam pekat khusus mode baca AMOLED.
  static const Color readerBlack = Color(0xFF000000);

  /// Warna badge bahasa chapter.
  static const Color langIdBadge = Color(0xFF00A572);
  static const Color langEnBadge = Color(0xFF009BD1);

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    inversePrimary: inversePrimary,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    tertiary: tertiary,
    tertiaryContainer: tertiaryContainer,
    error: error,
    onError: onError,
    surface: darkSurface,
    onSurface: darkOnSurface,
    onSurfaceVariant: darkOnSurfaceVariant,
    surfaceContainerLowest: darkSurfaceLowest,
    surfaceContainerLow: darkSurfaceLow,
    surfaceContainer: darkSurfaceContainer,
    surfaceContainerHigh: darkSurfaceHigh,
    surfaceContainerHighest: darkSurfaceBright,
    outline: darkOutline,
  );

  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: lightPrimary,
    onPrimary: lightOnPrimary,
    primaryContainer: lightPrimaryContainer,
    onPrimaryContainer: Color(0xFF0B3D66),
    secondary: Color(0xFF1FAA59),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFD5F2E3),
    onSecondaryContainer: Color(0xFF0B4630),
    tertiary: Color(0xFFF2994A),
    error: Color(0xFFD64545),
    onError: Colors.white,
    surface: lightSurface,
    onSurface: lightOnSurface,
    onSurfaceVariant: Color(0xFF5A6B7D),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF7FAFD),
    surfaceContainer: Colors.white,
    surfaceContainerHigh: lightSurfaceHigh,
    surfaceContainerHighest: Color(0xFFD8E5F1),
    outline: lightOutline,
  );
}
