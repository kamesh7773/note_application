import 'package:flutter/material.dart';

class ToggleProvider extends ChangeNotifier {
  // variable's delcartion.
  bool _showPassword = true;
  bool _isChecked = false;
  bool _notesAutoDelete = true;
  bool _longPressToSelect = true;

  // declaring getters.
  bool get showPassword => _showPassword;
  bool get isChecked => _isChecked;
  bool get notesAutoDelete => _notesAutoDelete;
  bool get longPressToSelect => _longPressToSelect;

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

  // Method that Hide the Auto Delete Notes after 7 days.
  void autoDeleteNotes() {
    _notesAutoDelete = false;
    notifyListeners();
  }

  // Method that checked/unchecked the RadioBtn.
  void longPressToSelectNotes() {
    _longPressToSelect = false;
    notifyListeners();
  }
}
