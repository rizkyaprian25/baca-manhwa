import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Tema: terang biru MangaIndo (light) + KuroYomi gelap (dark).
/// Font: Plus Jakarta Sans (body) + Space Grotesk (display).
/// `lib/core/theme/app_theme.dart`.
class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(TextTheme base) {
    final jakarta = GoogleFonts.plusJakartaSansTextTheme(base);
    final grotesk = GoogleFonts.spaceGroteskTextTheme(base);
    return jakarta.copyWith(
      displayLarge: grotesk.displayLarge,
      displayMedium: grotesk.displayMedium,
      displaySmall: grotesk.displaySmall,
      headlineLarge: grotesk.headlineLarge,
      headlineMedium: grotesk.headlineMedium,
      headlineSmall: grotesk.headlineSmall,
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: AppColors.lightScheme,
      scaffoldBackgroundColor: AppColors.lightSurface,
    );
    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      cardTheme: const CardThemeData(
        color: AppColors.lightSurfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFFE2EAF2)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: AppColors.darkScheme,
      scaffoldBackgroundColor: AppColors.darkSurface,
    );
    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      cardTheme: const CardThemeData(
        color: AppColors.darkSurfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
      ),
    );
  }
}
