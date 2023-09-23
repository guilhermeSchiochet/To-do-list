import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey.shade50,
      primaryColor: Colors.black,
      splashColor: Colors.transparent,
      fontFamily: 'IBM',
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch:  const MaterialColor(0xFFFFFFFF, <int, Color>{
          50: Colors.white,
          100: Colors.white,
          200: Colors.white,
          300: Colors.white,
          400: Colors.white,
          500: Colors.white,
          600: Colors.white,
          700: Colors.white,
          800: Colors.white,
          900: Colors.white,
        }),
        backgroundColor: Colors.white, // cor de fundo do seu aplicativo
        errorColor: Colors.red, // cor de erro do seu aplicativo
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Colors.black,
      splashColor: Colors.transparent,
      fontFamily: 'IBM',
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
    );
  }
}