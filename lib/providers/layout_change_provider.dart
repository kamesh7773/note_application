import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayoutChangeProvider extends ChangeNotifier {
  bool _isGridView = true;
  final bool _isGridViewForTrash = true;

  bool get isGridView => _isGridView;
  bool get isGridViewForTrash => _isGridViewForTrash;

  //! Update the Layout based on User Selection.
  void changeLayout() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _isGridView = !_isGridView;

    await prefs.setBool('isGridView', _isGridView);

    notifyListeners();
  }

  //! Update the AppBar() after Selecting the Notes.
  void listener() {
    notifyListeners();
  }
}
