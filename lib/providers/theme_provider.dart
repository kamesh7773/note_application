import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:note_application/theme/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
//! varibale declartion.
  String _level = "System";
  String _theme = "System";
  ThemeData _themeData = NoteAppTheme.lightMode;

  //! SystemLightDarkProvider Class Construtor.
  ThemeProvider(String savedLevel) {
    // initlizing radio button value that is retrived from Shared Preference at the start of application.
    _level = savedLevel;
    _theme = savedLevel;
    // after initlizing the radio button value we called the setTheme() method so application Theme can be set according the initlized radio value.
    setTheme();
    // this line of code is executed the SetTheme() method when Android System Brightness Changes.
    // But here we useing this code when user have set the App Theme as "System", if "System" is selected then if System theme got change and SetTheme() method
    // get called and if privous theme is selected as Dark and System Theme change to light and SetTheme() method check the current theme and change the theme
    // of application.
    PlatformDispatcher.instance.onPlatformBrightnessChanged = setTheme;
  }

  String get level => _level;
  String get theme => _theme;
  ThemeData get themeData => _themeData;

  //! Method that toggle the RadioButton by User Intraction.
  void toggleRadiobtn(value) {
    _level = value;
    notifyListeners();
  }

  //! Method that change the Theme.
  void setTheme() {
    _theme = _level;
    // If User have Selected the "System" Theme.
    if (_level == "System") {
      if (PlatformDispatcher.instance.platformBrightness == Brightness.light) {
        _themeData = NoteAppTheme.lightMode;
      } else {
        _themeData = NoteAppTheme.darkMode;
      }
    }
    // If User have Selected the "Light" Theme.
    else if (_level == "Light") {
      _themeData = NoteAppTheme.lightMode;
    }
    // If User have Selected the "Dark" Theme.
    else if (_level == "Dark") {
      _themeData = NoteAppTheme.darkMode;
    }
    // else return nothing.
    else {
      return;
    }
    _saveToPrefs();
    notifyListeners();
  }

  //! This Method save user selected Radio Button Level in SharedPreferences.
  void _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("savedTheme", _level);
  }

  //! Retriving the Privious Saved Radio Button Level From SharedPreferences.
  //! [ This method get called from main() method ]
  static Future<String> currentTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('savedTheme') ?? "System";
  }
}
