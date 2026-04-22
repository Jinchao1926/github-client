import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: LightColors.primary,
        onPrimary: Colors.white,
        surface: LightColors.background,
        onSurface: LightColors.primaryText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: LightColors.secondaryBackground,
        foregroundColor: LightColors.primaryText,
        elevation: 0,
        centerTitle: false,
      ),
      scaffoldBackgroundColor: LightColors.background,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: LightColors.tertiaryBackground,
        selectedItemColor: LightColors.primary,
        unselectedItemColor: LightColors.secondaryText,
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 14),
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LightColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: LightColors.primary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LightColors.primary,
          side: BorderSide(color: LightColors.arrowColor),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: LightColors.primaryText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: LightColors.primaryText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: LightColors.primaryText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: LightColors.primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: LightColors.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: LightColors.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: LightColors.primaryText, fontSize: 16),
        bodyMedium: TextStyle(color: LightColors.primaryText, fontSize: 14),
        bodySmall: TextStyle(color: LightColors.secondaryText, fontSize: 12),
        labelLarge: TextStyle(
          color: LightColors.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: LightColors.primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: LightColors.secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: DarkColors.primary,
        onPrimary: Colors.white,
        surface: DarkColors.background,
        onSurface: DarkColors.primaryText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DarkColors.secondaryBackground,
        foregroundColor: DarkColors.primaryText,
        elevation: 0,
        centerTitle: false,
      ),
      scaffoldBackgroundColor: DarkColors.background,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DarkColors.tertiaryBackground,
        selectedItemColor: DarkColors.primary,
        unselectedItemColor: DarkColors.secondaryText,
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 14),
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DarkColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: DarkColors.primary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DarkColors.primary,
          side: BorderSide(color: DarkColors.arrowColor),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: DarkColors.primaryText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: DarkColors.primaryText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: DarkColors.primaryText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: DarkColors.primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: DarkColors.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: DarkColors.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: DarkColors.primaryText, fontSize: 16),
        bodyMedium: TextStyle(color: DarkColors.primaryText, fontSize: 14),
        bodySmall: TextStyle(color: DarkColors.secondaryText, fontSize: 12),
        labelLarge: TextStyle(
          color: DarkColors.primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: DarkColors.primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: DarkColors.secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
