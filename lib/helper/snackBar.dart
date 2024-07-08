import 'package:flutter/material.dart';

class SnackBars {
  static void normalSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 50, 49, 49),
        content: Text(error),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
