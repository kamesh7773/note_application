import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayoutChangeProvider extends ChangeNotifier {
  late bool _isGridView;
  final bool _isGridViewForTrash = true;

  bool get isGridView => _isGridView;
  bool get isGridViewForTrash => _isGridViewForTrash;

  LayoutChangeProvider({bool isGridView = true}) {
    _isGridView = isGridView;
  }

  //! Change the Layout based on User Selection.
  void changeLayout() {
    _isGridView = !_isGridView;
    _saveToPrefs();
    notifyListeners();
  }
  

  //! This Method save user selected current Layout in SharedPreferences.
  Future<void> _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isGridView', _isGridView);
  }

  //! Retriving the Current Theme From SharedPreferences.
  static Future<bool> currentLayout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isGridView') ?? false;
  }
}
