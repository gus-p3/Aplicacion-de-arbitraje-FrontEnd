import 'package:flutter/material.dart';
import '../utils/environment.dart';

class AppThemes {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: Environment.primaryColor,
    colorScheme: ColorScheme.light(
      primary: Environment.primaryColor,
      secondary: Environment.secondaryColor,
      tertiary: Environment.accentColor,
      background: const Color(0xFFF8FAFC),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Environment.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Environment.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF64748B),
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const double defaultBorderRadius = 12.0;
}