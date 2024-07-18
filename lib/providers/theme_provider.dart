import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  //! The ThemeProvider constructor is always invoked when the application starts because the ThemeProvider class is used in the ChangeNotifierProvider.
  //! we need to ensure the theme value need to be retrived and pass it to the ThemeProvider class before application is started. To achieve this, we make
  //! the main() method async and fetch all the SharedPreferences values and pass it to the ThemeProvider class before calling runApp(). This way, 
  //! the SharedPreferences values are retrieved successfully before the application get started ensuring that our application has the correct 
  //! themeData from SharedPreferences.
  ThemeProvider(this._isDarkMode);

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
  //! [ This method get called from main() method ]
  static Future<bool> currentTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
}
