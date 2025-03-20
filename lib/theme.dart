// lib/theme.dart
import 'package:flutter/material.dart';
// If you want custom Google Fonts:
import 'package:google_fonts/google_fonts.dart';

/// A simple utility class to hold color constants.
/// Feel free to rename or expand as needed.
abstract class AppColors {
  // Light theme colors
  static const Color lightPrimary = Color(0xFFFFAB40);  // Vibrant Orange
  static const Color lightSecondary = Color(0xFF80DEEA); // Bright Teal
  static const Color lightBackground = Color(0xFFFFFDE7); // Light Cream
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFEF5350);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFFFFAB40);  // We can reuse orange but slightly adapt if needed
  static const Color darkSecondary = Color(0xFF80DEEA); 
  static const Color darkBackground = Color(0xFF1E1E1E); // Dark grey
  static const Color darkSurface = Color(0xFF2A2A2A);
  static const Color darkError = Color(0xFFF44336);
}

class AppTheme {
  // LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // If you want to do colorScheme-based theming, define a color scheme:
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.lightSecondary,
      onSecondary: Colors.white,
      background: AppColors.lightBackground,
      onBackground: Colors.black87,
      surface: AppColors.lightSurface,
      onSurface: Colors.black87,
      error: AppColors.lightError,
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.lightBackground,

    // Use Material 3 design
    useMaterial3: true,

    // Typography: playful fonts, e.g. Poppins for headings, Quicksand for body
    textTheme: TextTheme(
      headlineSmall: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyMedium: GoogleFonts.quicksand(
        fontSize: 14,
        color: Colors.black87,
      ),
      labelLarge: GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),

    // Rounded corners and gentle shadows for cards
    cardTheme: CardTheme(
      color: AppColors.lightSurface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black12,
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        elevation: 2,
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      elevation: 3,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // NavigationBar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      indicatorColor: AppColors.lightPrimary.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.all(
        GoogleFonts.quicksand(fontWeight: FontWeight.w600),
      ),
    ),

    // You can also customize Switch, Checkbox, etc. as needed
  );

  // DARK THEME
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: Colors.black87,
      secondary: AppColors.darkSecondary,
      onSecondary: Colors.black87,
      background: AppColors.darkBackground,
      onBackground: Colors.white70,
      surface: AppColors.darkSurface,
      onSurface: Colors.white70,
      error: AppColors.darkError,
      onError: Colors.black87,
    ),

    scaffoldBackgroundColor: AppColors.darkBackground,
    useMaterial3: true,

    textTheme: TextTheme(
      headlineSmall: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
      bodyMedium: GoogleFonts.quicksand(
        fontSize: 14,
        color: Colors.white70,
      ),
      labelLarge: GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    ),

    cardTheme: CardTheme(
      color: AppColors.darkSurface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black26,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        elevation: 2,
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      elevation: 3,
      iconTheme: const IconThemeData(color: Colors.black87),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      indicatorColor: AppColors.darkPrimary.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.all(
        GoogleFonts.quicksand(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    ),
  );
}
