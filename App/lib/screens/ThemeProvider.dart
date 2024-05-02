import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    _saveThemePreference(isOn);
  }

  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', isDark);
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    themeMode = prefs.getBool('darkTheme') ?? false ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
