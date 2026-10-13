import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension ColorAlphaCompat on Color {
  Color withValues({double? alpha}) => withOpacity(alpha ?? this.alpha / 255);
}

class AppColors {
  static const Color bgPrimary = Color(0xFF000000);
  static const Color bgSecondary = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceElevated = Color(0xFF1A1A1A);
  static const Color crimson = Color(0xFF8052FF);
  static const Color neonRed = Color(0xFF9B7AFF);
  static const Color bloodRed = Color(0xFF5E3BC8);
  static const Color darkWine = Color(0xFF1D1635);
  static const Color champagne = Color(0xFFFFB829);
  static const Color teal = Color(0xFF15846E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9A9A9A);
  static const Color divider = Color(0xFF1C1C1C);
  static const Color gradientStart = Color(0xFF8052FF);
  static const Color gradientEnd = Color(0xFF000000);

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
    colors: [Color(0xFF090909), Color(0xFF000000), Color(0xFF141414)],
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
  static TextStyle get heroTitle => GoogleFonts.inter(
        fontSize: 82,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: -2.4,
        height: 0.95,
      );

  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: 52,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: -1.8,
        height: 1.05,
      );

  static TextStyle get subtitle => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w200,
        color: AppColors.textSecondary,
        letterSpacing: 0,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w200,
        color: AppColors.textSecondary,
        height: 1.55,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w200,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.champagne,
        letterSpacing: 2.2,
      );

  static TextStyle get navLink => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      );

  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: -0.8,
      );

  static TextStyle get statNumber => GoogleFonts.inter(
        fontSize: 56,
        fontWeight: FontWeight.w400,
        color: AppColors.crimson,
        letterSpacing: -1.6,
      );

  static TextStyle get statLabel => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      );

  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
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
        cardTheme: const CardTheme(color: AppColors.surface, elevation: 0),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            textStyle: AppTextStyles.buttonText,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.crimson,
            side: const BorderSide(color: AppColors.crimson),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            textStyle: AppTextStyles.buttonText,
          ),
        ),
      );
}
