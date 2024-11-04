import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayoutChangeProvider extends ChangeNotifier {
  bool _isGridView = true;
  final bool _isGridViewForTrash = true;

  bool get isGridView => _isGridView;
  bool get isGridViewForTrash => _isGridViewForTrash;

  LayoutChangeProvider(this._isGridView);

  //! Change the layout based on user selection
  void changeLayout() {
    _isGridView = !_isGridView;
    _saveToPrefs();
    notifyListeners();
  }

  //! Save the user's selected layout in SharedPreferences
  Future<void> _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isGridView', _isGridView);
  }

  //! Retrieve the current layout from SharedPreferences
  static Future<bool> currentLayout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isGridView') ?? false;
  }
}
