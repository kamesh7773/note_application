import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  // Appbar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 26, 26, 26),
    centerTitle: true,
  ),
  // ColorScheme Theme
  colorScheme: ColorScheme.dark(
    background: const Color.fromARGB(255, 26, 26, 26),
    inversePrimary: Colors.grey.shade300,
    outline: const Color.fromARGB(255, 116, 117, 117),
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
    backgroundColor: Colors.grey.shade800,
    elevation: 20,
  ),
  // Icon Theme
  iconTheme: const IconThemeData(color: Colors.white),
  // SnackBar Theme
  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(color: Colors.white),
    backgroundColor: Color.fromARGB(255, 40, 40, 40),
  ),
  // progressIndicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    linearTrackColor: Colors.lightBlue,
  ),
);
