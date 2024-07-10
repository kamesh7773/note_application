import 'package:flutter/material.dart';

class LayoutChangeProvider extends ChangeNotifier {
  bool _isGridView = true;

  bool get isGridView => _isGridView;

  void changeLayout() {
    _isGridView = !_isGridView;
    notifyListeners();
  }
}
