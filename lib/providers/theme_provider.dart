import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late bool _isDarkMode;
  bool get isDarkMode => _isDarkMode;

  //! Here we are accessing the
  ThemeProvider({bool isDarkMode = false}) {
    _isDarkMode = isDarkMode;
  }

  //! Change the Theme based on User Selection.
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveToPrefs();
    notifyListeners();
  }

  //! This Method save user selected current Theme in SharedPreferences.
  Future<void> _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  //! Retriving the Current Theme From SharedPreferences.
  static Future<bool> currentTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
}
