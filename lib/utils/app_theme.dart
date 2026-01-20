import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF1F8E9);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF2E7D32);
  static const Color lightSecondary = Color(0xFF43A047);
  static const Color lightTextPrimary = Color(0xFF1B5E20);
  static const Color lightTextSecondary = Color(0xFF558B2F);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0B2211);
  static const Color darkSurface = Color(0xFF15331E);
  static const Color darkPrimary = Color(0xFF43A047);
  static const Color darkSecondary = Color(0xFF66BB6A);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.white70;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        surface: lightSurface,
        background: lightBackground,
        onPrimary: Colors.white,
        onSurface: lightTextPrimary,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.light().textTheme,
      ).apply(bodyColor: lightTextPrimary, displayColor: lightTextPrimary),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextPrimary),
      ),
      iconTheme: const IconThemeData(color: lightPrimary),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        surface: darkSurface,
        background: darkBackground,
        onPrimary: Colors.white,
        onSurface: darkTextPrimary,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: darkTextPrimary, displayColor: darkTextPrimary),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      iconTheme: const IconThemeData(color: darkPrimary),
    );
  }
}
