import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade300,
  ),
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.grey.shade800,
      secondary: Colors.grey.shade700,
      inversePrimary: Colors.grey.shade300),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.grey[300],
        displayColor: Colors.white,
      ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade200,
    elevation: 16,
  ),
);
