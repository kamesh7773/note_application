import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_application/theme/Extensions/my_colors.dart';

class ProgressIndicators {
  static void showProgressIndicator(BuildContext context) {
    //! Access Theme Extension Colors.
    final myColors = Theme.of(context).extension<MyColors>();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: true, //! Please set this to false once you debug your code
          child: Center(
            child: LoadingAnimationWidget.prograssiveDots(
              color: myColors!.commanColor!,
              size: 50,
            ),
          ),
        );
      },
    );
  }
}
