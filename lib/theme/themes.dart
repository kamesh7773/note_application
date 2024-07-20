import 'package:flutter/material.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';

class NoteAppTheme {
  NoteAppTheme._();

  //? ----------------
  //? LIGHT MODE THEME
  //? ----------------

  static final ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Lato",

    //! Extension's
    extensions: <ThemeExtension<dynamic>>[
      MyColors.light,
    ],

    //! Appbar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade300,
      centerTitle: true,
    ),

    //! ColorScheme Theme
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade300,
      primary: Colors.grey.shade200,
      secondary: Colors.grey.shade400,
      inversePrimary: Colors.grey.shade800,
      outline: Colors.black,
    ),

    //! textTheme Theme
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.grey[800],
          displayColor: Colors.black,
        ),

    //! Textfrom Feild Theme
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
      ),
      labelStyle: const TextStyle(color: Colors.black),
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
        ),
      ),
    ),

    //! TextSelection Theme
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionHandleColor: Color.fromARGB(255, 70, 69, 69),
      selectionColor: Color.fromARGB(255, 166, 213, 235),
    ),

    //! floatingActionButton Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey.shade200,
      elevation: 16,
    ),

    //! Icon Theme
    iconTheme: const IconThemeData(color: Colors.black),

    //! SnackBar Theme
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(color: Colors.white),
      backgroundColor: Colors.black,
    ),

    //! progressIndicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      linearTrackColor: Colors.lightBlue,
    ),

    //! Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade300,
    ),

    //! Diolog box Theme
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade300,
    ),

    //! Radio btn Theme
    radioTheme: const RadioThemeData(
      fillColor: WidgetStatePropertyAll(Colors.black),
    ),

    //! Text Btn Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.black,
      ),
    ),
  );

  //? ---------------
  //? DARK MODE THEME
  //? ---------------

  static final ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Lato",

    //! Extension's
    extensions: <ThemeExtension<dynamic>>[
      MyColors.dark,
    ],

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

    //! Textfrom Feild Theme
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
      ),
      labelStyle: const TextStyle(color: Colors.white),
      fillColor: const Color.fromARGB(255, 100, 100, 100),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 100, 100, 100),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 100, 100, 100),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 100, 100, 100),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 100, 100, 100),
        ),
      ),
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

    //! Chip Theme
    chipTheme: const ChipThemeData(
      backgroundColor: Color.fromARGB(255, 100, 100, 100),
    ),

    //! Diolog box Theme
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromARGB(255, 34, 33, 33),
    ),

    //! Radio btn Theme
    radioTheme: const RadioThemeData(
      fillColor: WidgetStatePropertyAll(Colors.white),
    ),

    //! Text Btn Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
      ),
    ),
  );
}
