import 'package:flutter/material.dart';

class ToggleProvider extends ChangeNotifier {
  // variable's delcartion.
  bool _showPassword = true;
  bool _isChecked = false;

  // declaring getters.
  bool get showPassword => _showPassword;
  bool get isChecked => _isChecked;

  // Method that hide/show the password.
  void showPasswordMethod() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  // Method that checked/unchecked the RadioBtn.
  void isCheckedMethod() {
    _isChecked = !_isChecked;
    notifyListeners();
  }
}
