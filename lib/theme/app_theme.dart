import 'package:flutter/material.dart';

class AppTheme {
  // Main Colors
  static const Color background = Color(0xFFF7F9FC);

  static const Color surface = Color(0xFFFFFFFF);

  static const Color surfaceSoft = Color(0xFFF0F5FF);

  // Primary Blue
  static const Color primary = Color(0xFF2563EB);

  static const Color primaryLight = Color(0xFF60A5FA);

  // Supporting Colors
  static const Color mint = Color(0xFF22C7A0);

  static const Color lavender = Color(0xFF8B9CF6);

  // Text Colors
  static const Color textPrimary = Color(0xFF172033);

  static const Color textSecondary = Color(0xFF667085);

  static ThemeData dark() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          secondary: mint,
          surface: surface,
          onSurface: textPrimary,
        );

    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.light,

      colorScheme: scheme,

      scaffoldBackgroundColor: background,

      splashFactory: InkSparkle.splashFactory,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        hintStyle: const TextStyle(color: textSecondary),

        labelStyle: const TextStyle(color: textSecondary),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: primary,
          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),

          elevation: 0,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE8EDF5)),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFFE8EDF5),
        thickness: 1,
      ),
    );
  }
}
