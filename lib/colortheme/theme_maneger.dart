import 'package:dass/colortheme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  static Future<ThemeProvider> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final theme = isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    return ThemeProvider(theme);
  }

  void toggleTheme() async {
    print("Current theme: ${_themeData.brightness}");
    if (_themeData.brightness == Brightness.light) {
      _themeData = AppThemes.darkTheme; // Use AppThemes to get dark theme
      await _saveThemePreference(true);
      debugPrint("Dark mode");
    } else {
      _themeData = AppThemes.lightTheme;
      await _saveThemePreference(false);
      debugPrint("light mode");
    }
    notifyListeners();
    debugPrint("Notified ?"); // Notify listeners to rebuild the UI
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }
}
