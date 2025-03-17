// lib/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Light color scheme with pastel teal as primary
  static final ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF65C8BA), // pastel teal
    primary: const Color(0xFF65C8BA),
    secondary: const Color(0xFFFEE8B0), // pastel peach/yellow
    surface: Colors.white,
    background: Color(0xFFF5F5F5),
    brightness: Brightness.light,
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: _colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: _colorScheme.background,
    textTheme: const TextTheme(
      displaySmall: TextStyle(fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 14),
    ),
    // Example ElevatedButton style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
      ),
    ),
    // Example OutlinedTextField style
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    // NavigationBar theme for bottom nav
    navigationBarTheme: const NavigationBarThemeData(
      height: 60,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}
