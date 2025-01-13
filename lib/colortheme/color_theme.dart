import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.grey.shade200,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade200,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey.shade200, // Button text color
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black, // Cursor color in light theme
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[900],
    scaffoldBackgroundColor: AppColors.background, // Dark blue-gray
    colorScheme: ColorScheme.dark(
      primary: Colors.grey.shade900,
      secondary: Colors.grey.shade700,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background, // Dark blue-gray
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.buttonText, // White button text
        backgroundColor:
            AppColors.highlightedButton, // Aqua/teal button background
      ),
    ),
    textTheme: TextTheme(
      bodyLarge:
          TextStyle(color: AppColors.primaryText), // Light cyan/aqua text
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white, // Cursor color in dark theme
    ),
  );
}

class AppColors {
  static const Color background = Color(0xFF1C1F26); // Dark blue-gray
  static const Color primaryText = Color(0xFF00B4D8); // Light cyan/aqua
  static const Color secondaryText = Color(0xFFB0BEC5); // Light gray
  static const Color highlightedButton = Color(0xFF0077B6); // Aqua/teal
  static const Color buttonText = Color(0xFFFFFFFF); // White
  static const Color inactiveIcon = Color(0xFF5F6A72); // Medium gray
  static const Color powerIcon = Color(0xFF00B4D8); // Aqua/teal
}
