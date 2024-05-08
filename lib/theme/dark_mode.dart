import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  // Appbar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade800,
    centerTitle: true,
  ),
  // ColorScheme Theme
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade800,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade300,
    outline: const Color.fromARGB(255, 121, 205, 191),
  ),
  // textTheme Theme
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
  // TextSelection Theme
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color.fromARGB(255, 122, 129, 132),
  ),
  // floatingActionButton Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade700,
    elevation: 20,
  ),
  // Icon Theme
  iconTheme: const IconThemeData(color: Colors.white),
  // SnackBar Theme
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: const TextStyle(color: Colors.white),
    backgroundColor: Colors.grey.shade700,
  ),
  // progressIndicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    linearTrackColor: Colors.lightBlue,
  ),
);
