import 'package:flutter/material.dart';

final ThemeData cornflowerBlueTheme = ThemeData(
  // Primary color - Cornflower Blue
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6495ED),
    primary: const Color(0xFF6495ED),         // Cornflower blue
    primaryContainer: const Color(0xFF4171D5),// Darker variant
    secondary: const Color(0xFF82B1FF),       // Soft lighter blue
    secondaryContainer: const Color(0xFF5C93E0),
    background: const Color(0xFFF0F4FF),      // Very light blue background
    surface: Colors.white,
    onPrimary: Colors.white,                   // Text on primary buttons
    onSecondary: Colors.white,
    onBackground: const Color(0xFF1A1A1A),    // Dark text
    onSurface: const Color(0xFF1A1A1A),
    brightness: Brightness.light,
  ),

  scaffoldBackgroundColor: const Color(0xFFF0F4FF),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF6495ED),
    foregroundColor: Colors.white,
    elevation: 3,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.5,
    ),
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    shadowColor: Colors.black.withOpacity(0.15),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6495ED),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      elevation: 3,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF6495ED),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1A1A1A),
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1A1A1A),
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1A1A1A),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Color(0xFF333333),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFF555555),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: Color(0xFF777777),
    ),
    labelLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xFF6495ED),
    ),
  ),



  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFE6EEFF),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF6495ED), width: 2),
    ),
  ),

  dividerColor: const Color(0xFFB0C4DE),

  iconTheme: const IconThemeData(
    color: Color(0xFF6495ED),
    size: 24,
  ),

  // For progress indicators, etc
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF6495ED),
  ),
);
