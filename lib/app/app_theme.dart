
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color navy = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF151B28);
  static const Color blue = Color(0xFF126BFF);
  static const Color cyan = Color(0xFF21D4F5);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: navy,

      colorScheme: const ColorScheme.dark(
        primary: blue,
        secondary: cyan,
        surface: surface,
        error: Color(0xFFFF5C68),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      progressIndicatorTheme:
          const ProgressIndicatorThemeData(
        color: cyan,
      ),
    );
  }
}
