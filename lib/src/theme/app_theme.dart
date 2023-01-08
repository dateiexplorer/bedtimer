import 'package:flutter/material.dart';

import 'custom_color_scheme.dart';

class AppTheme {
  static const backgroundColor = Color(0xFF1D1E25);
  static const foregroundColor = Color(0xFFECECEC);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        background: backgroundColor,
        brightness: Brightness.dark,
        primary: Colors.deepPurple,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        iconTheme: IconThemeData(
          color: foregroundColor,
        ),
        actionsIconTheme: IconThemeData(
          color: foregroundColor,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        // Make borders more rounded.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        // Choose a slightly lighter color than the background color.
        color: const Color(0xFF272831),
        textStyle: const TextStyle(
          color: foregroundColor,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF272831),
      ),
      cardColor: backgroundColor,
      iconTheme: const IconThemeData(
        color: foregroundColor,
      ),
      textTheme: const TextTheme(
        labelLarge: TextStyle(
          color: foregroundColor,
        ),
        labelMedium: TextStyle(
          color: foregroundColor,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        labelSmall: TextStyle(
          color: foregroundColor,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
        bodyLarge: TextStyle(
          color: foregroundColor,
        ),
        bodyMedium: TextStyle(
          color: foregroundColor,
        ),
        bodySmall: TextStyle(
          color: foregroundColor,
        ),
        headlineLarge: TextStyle(
          color: foregroundColor,
        ),
        headlineMedium: TextStyle(
          color: Colors.deepPurple,
          fontSize: 16.0,
        ),
        headlineSmall: TextStyle(
          color: foregroundColor,
        ),
        displayLarge: TextStyle(
          color: foregroundColor,
        ),
        displayMedium: TextStyle(
          color: foregroundColor,
        ),
        displaySmall: TextStyle(
          color: foregroundColor,
        ),
        titleLarge: TextStyle(
          color: foregroundColor,
        ),
        titleMedium: TextStyle(
          color: foregroundColor,
        ),
        titleSmall: TextStyle(
          color: foregroundColor,
        ),
      ),
      extensions: const [
        CustomColors(
          wheelBackgroundColor: Color(0xFF272831),
          secondaryBackgroundColor: Color(0xFF272831),
        ),
      ],
    );
  }

  // This app doesn't provide a separate dark theme. It's default theme is
  // already dark.
  static ThemeData get dark {
    return ThemeData();
  }
}
