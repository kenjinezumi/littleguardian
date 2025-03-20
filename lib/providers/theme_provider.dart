// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system; // default to system

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool useDark) {
    themeMode = useDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSystemDefault() {
    themeMode = ThemeMode.system;
    notifyListeners();
  }

  void setSystemMode() {
    themeMode = ThemeMode.system;
    notifyListeners();
  }
  
}
