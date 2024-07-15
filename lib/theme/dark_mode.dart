import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: "Lato",

  //! Appbar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF181818),
    centerTitle: true,
  ),

  //! ColorScheme Theme
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF181818),
    primary: const Color.fromARGB(255, 22, 22, 22),
    secondary: const Color.fromARGB(255, 34, 34, 34),
    inversePrimary: Colors.grey.shade300,
    outline: const Color.fromARGB(255, 116, 117, 117),
  ),

  //! textTheme Theme
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),

  //! TextSelection Theme
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionHandleColor: Color.fromRGBO(167, 180, 185, 1),
    selectionColor: Color.fromRGBO(122, 129, 132, 1),
  ),

  //! Icon Theme
  iconTheme: const IconThemeData(color: Colors.white),

  //! floatingActionButton Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade800,
    elevation: 20,
  ),

  //! SnackBar Theme
  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(color: Colors.white),
    backgroundColor: Color.fromARGB(255, 40, 40, 40),
  ),

  //! progressIndicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    circularTrackColor: Colors.white,
    linearTrackColor: Colors.lightBlue,
  ),
);
