import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A playful babysitting app palette with cooler pastel tones.
/// The goal: calm & welcoming, using pastel lilac/purple (primary),
/// plus a pastel mint/teal accent, with a pastel-blue background.
abstract class AppColors {
  // Light theme colors
  static const Color lightPrimary    = Color(0xFFE6CADD); // Pastel Lilac
  static const Color lightSecondary  = Color(0xFFB2EBF2); // Soft pastel mint/teal
  static const Color lightBackground = Color(0xFFEBF5FF); // Pastel blue background
  static const Color lightSurface    = Color(0xFFFFFFFF); 
  static const Color lightError      = Color(0xFFF48FB1); // Pastel pinkish-red

  // Dark theme colors (slightly deeper for contrast)
  static const Color darkPrimary    = Color(0xFF9575CD); // Deeper lilac
  static const Color darkSecondary  = Color(0xFF80CBC4); // Deeper mint/teal
  static const Color darkBackground = Color(0xFF1E1E1E); // Very dark grey
  static const Color darkSurface    = Color(0xFF2A2A2A);
  static const Color darkError      = Color(0xFFCF6679);  // Material dark pink-red
}

class AppTheme {
  // ------------------
  // LIGHT THEME
  // ------------------
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary:   AppColors.lightPrimary,       // Pastel lilac
      onPrimary: Colors.black,                 // Black text on light lilac for contrast
      secondary: AppColors.lightSecondary,     // Pastel mint/teal
      onSecondary: Colors.black,               // Black text on mint
      background: AppColors.lightBackground,   // Pastel blue background
      onBackground: Colors.black87,
      surface: AppColors.lightSurface,         // White for cards, etc.
      onSurface: Colors.black87,
      error: AppColors.lightError,             // Pastel pinkish-red
      onError: Colors.white,
    ),

    // The overall scaffold uses our pastel blue
    scaffoldBackgroundColor: AppColors.lightBackground,

    // Typography: playful fonts
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

    // Cards: white surface, rounded corners, subtle shadow
    cardTheme: CardTheme(
      color: AppColors.lightSurface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black12,
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,   // Pastel lilac
        foregroundColor: Colors.black,             // black text for clarity
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        elevation: 2,
      ),
    ),

    // FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.black, // black icon/text on lilac
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
    ),

    // AppBar 
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightPrimary,      // pastel lilac
      elevation: 3,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),

    // NavigationBar 
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      indicatorColor: AppColors.lightPrimary.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.all(
        GoogleFonts.quicksand(fontWeight: FontWeight.w600, color: Colors.black),
      ),
    ),
  );

  // ------------------
  // DARK THEME
  // ------------------
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary:   AppColors.darkPrimary,     // Deeper lilac
      onPrimary: Colors.white,             // White text on dark lilac
      secondary: AppColors.darkSecondary,  // Deeper mint/teal
      onSecondary: Colors.white,           // White text on dark teal
      background: AppColors.darkBackground,
      onBackground: Colors.white70,
      surface: AppColors.darkSurface,
      onSurface: Colors.white70,
      error: AppColors.darkError,
      onError: Colors.black,
    ),

    scaffoldBackgroundColor: AppColors.darkBackground,

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
        backgroundColor: AppColors.darkPrimary, // deeper lilac
        foregroundColor: Colors.white,          // white text
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        elevation: 2,
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: Colors.white, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      elevation: 3,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
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
