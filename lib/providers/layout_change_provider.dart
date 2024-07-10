import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayoutChangeProvider extends ChangeNotifier {
  bool _isGridView = true;

  bool get isGridView => _isGridView;

  void changeLayout() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _isGridView = !_isGridView;

    await prefs.setBool('isGridView', _isGridView);

    notifyListeners();
  }
}
