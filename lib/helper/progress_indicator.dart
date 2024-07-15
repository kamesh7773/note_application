import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProgressIndicators {
  static void showProgressIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: true, // Please set this to false once you debug your code
          child: Center(
            child: LoadingAnimationWidget.prograssiveDots(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade300
                  : Colors.black,
              size: 50,
            ),
          ),
        );
      },
    );
  }
}
