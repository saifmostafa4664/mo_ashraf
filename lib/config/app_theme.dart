import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color bgPrimary = Color(0xFF08070F);
  static const Color bgSecondary = Color(0xFF0E0C1C);
  static const Color surface = Color(0xFF171428);
  static const Color surfaceElevated = Color(0xFF211C38);
  static const Color crimson = Color(0xFFFF3D81);
  static const Color neonRed = Color(0xFFFF6A9F);
  static const Color bloodRed = Color(0xFF8F1C52);
  static const Color darkWine = Color(0xFF2A1132);
  static const Color champagne = Color(0xFFFFB238);
  static const Color teal = Color(0xFF22E5FF);
  static const Color textPrimary = Color(0xFFF4F2FB);
  static const Color textSecondary = Color(0xFFAAA2C9);
  static const Color divider = Color(0xFF28233F);
  static const Color gradientStart = Color(0xFF3A1E8A);
  static const Color gradientEnd = Color(0xFF08070F);

  static const LinearGradient crimsonGradient = LinearGradient(
    colors: [bloodRed, crimson, champagne],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [bgPrimary, bgSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xD9111016), Color(0x99111016), Color(0xE618171F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static List<BoxShadow> crimsonGlow({double blur = 20, double opacity = 0.3}) {
    return [
      BoxShadow(
        color: crimson.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: 0,
      ),
    ];
  }
}

class AppTextStyles {
  static TextStyle get heroTitle => GoogleFonts.syne(
    fontSize: 72,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static TextStyle get sectionTitle => GoogleFonts.syne(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static TextStyle get subtitle => GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0,
  );

  static TextStyle get body => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.8,
  );

  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.8,
  );

  static TextStyle get label => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.crimson,
    letterSpacing: 1.8,
  );

  static TextStyle get navLink => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0,
  );

  static TextStyle get cardTitle => GoogleFonts.syne(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static TextStyle get statNumber => GoogleFonts.syne(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    color: AppColors.crimson,
  );

  static TextStyle get statLabel => GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 1.2,
  );

  static TextStyle get buttonText => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.8,
  );
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.crimson,
      secondary: AppColors.neonRed,
      surface: AppColors.surface,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heroTitle,
      displayMedium: AppTextStyles.sectionTitle,
      titleLarge: AppTextStyles.cardTitle,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.body,
      labelLarge: AppTextStyles.label,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgPrimary.withValues(alpha: 0.8),
      elevation: 0,
    ),
    cardTheme: const CardThemeData(color: AppColors.surface, elevation: 0),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.crimson),
      ),
      labelStyle: AppTextStyles.body,
      hintStyle: AppTextStyles.body.copyWith(
        color: AppColors.textSecondary.withValues(alpha: 0.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.crimson,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.crimson,
        side: const BorderSide(color: AppColors.crimson),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.buttonText,
      ),
    ),
  );
}
