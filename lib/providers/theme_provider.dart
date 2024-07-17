import 'package:flutter/material.dart';
import 'package:note_application/theme/themes.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  ThemeData _themeData = NoteAppTheme.lightMode;

  bool get isDark => _isDark;
  ThemeData get themeData => _themeData;

  void changeTheme() {
    if (_isDark) {
      _themeData = NoteAppTheme.lightMode;
      _isDark = false;
    } else {
      _themeData = NoteAppTheme.darkMode;
      _isDark = true;
    }
    notifyListeners();
  }
}
