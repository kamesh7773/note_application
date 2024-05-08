import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  // Appbar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade300,
    centerTitle: true,
  ),
  // ColorScheme Theme
  colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      primary: Colors.grey.shade200,
      secondary: Colors.grey.shade400,
      inversePrimary: Colors.grey.shade800,
      outline: Colors.black),
  // textTheme Theme
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.grey[800],
        displayColor: Colors.black,
      ),
  // TextSelection Theme
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color.fromARGB(255, 166, 213, 235),
  ),
  // floatingActionButton Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade200,
    elevation: 16,
  ),
  // Icon Theme
  iconTheme: const IconThemeData(color: Colors.black),
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
