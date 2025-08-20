
import 'package:flutter/material.dart';
import 'package:progros/core/appcolor.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ApplicationColors.lightPrimary,
    scaffoldBackgroundColor: ApplicationColors.lightBackground,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: ApplicationColors.lightText,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        color: ApplicationColors.lightText,
        fontFamily: 'Poppins',
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: ApplicationColors.lightPrimary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ApplicationColors.darkPrimary,
    scaffoldBackgroundColor: ApplicationColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: ApplicationColors.darkSurface,
      foregroundColor: ApplicationColors.darkText,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: ApplicationColors.darkText,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        color: ApplicationColors.darkSecondaryText,
        fontFamily: 'Poppins',
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: ApplicationColors.darkPrimary,
      surface: ApplicationColors.darkSurface,
    ),
  );
}
