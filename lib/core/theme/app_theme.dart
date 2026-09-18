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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0xFFE4E8EE), width: 0.8),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: const BorderSide(color: Color(0xFFE0E5EC), width: 0.6),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightOnSurface,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          side: const WidgetStatePropertyAll(BorderSide.none),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFE8EDF3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      dialogTheme: const DialogThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: Color(0x1FFFFFFF), width: 0.8),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: const BorderSide(color: Color(0x1FFFFFFF), width: 0.6),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          side: const WidgetStatePropertyAll(BorderSide.none),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      dialogTheme: const DialogThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
