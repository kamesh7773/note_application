import 'package:flutter/material.dart';

class LayoutChangeProvider extends ChangeNotifier {
  bool _gridView = true;

  void changeLayout() {
    _gridView = !_gridView;
    notifyListeners();
  }
}
