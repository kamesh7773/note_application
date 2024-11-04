import 'package:flutter/material.dart';

class ToggleProvider extends ChangeNotifier {
  // Variable declarations
  bool _showPassword = true;
  bool _isChecked = false;
  bool _notesAutoDelete = true;
  bool _longPressToSelect = true;

  // Getters
  bool get showPassword => _showPassword;
  bool get isChecked => _isChecked;
  bool get notesAutoDelete => _notesAutoDelete;
  bool get longPressToSelect => _longPressToSelect;

  // Method to toggle password visibility
  void showPasswordMethod() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  // Method to toggle radio button state
  void isCheckedMethod() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  // Method to disable auto-deletion of notes after 7 days
  void autoDeleteNotes() {
    _notesAutoDelete = false;
    notifyListeners();
  }

  // Method to disable long-press note selection
  void longPressToSelectNotes() {
    _longPressToSelect = false;
    notifyListeners();
  }
}
