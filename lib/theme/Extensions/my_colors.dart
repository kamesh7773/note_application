import 'package:flutter/material.dart';

@immutable
class MyColors extends ThemeExtension<MyColors> {
  const MyColors({this.googleFacebook, this.buttonColor, this.commanColor});

  //! Declaring varible for custom color for
  final Color? commanColor;
  final Color? buttonColor;
  final Color? googleFacebook;

  @override
  ThemeExtension<MyColors> copyWith({Color? commanColor, Color? buttonColor , Color? googleFacebook}) {
    return MyColors(
      commanColor: commanColor ?? this.commanColor,
      buttonColor: buttonColor ?? this.buttonColor,
      googleFacebook: buttonColor ?? this.googleFacebook,
    );
  }

  @override
  ThemeExtension<MyColors> lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) {
      return this;
    }
    return MyColors(
      commanColor: Color.lerp(commanColor, other.commanColor, t),
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t),
      googleFacebook: Color.lerp(googleFacebook, other.googleFacebook, t),
    );
  }

  //! variable Colors for Dark Theme.
  static const dark = MyColors(
    commanColor: Colors.white,
    buttonColor: Color.fromARGB(255, 100, 100, 100),
    googleFacebook: Color.fromARGB(255, 209, 206, 206),
  );

  //! variable Colors for light Theme.
  static final light = MyColors(
    commanColor: Colors.black,
    buttonColor: Colors.black,
    googleFacebook: Colors.grey.shade300,
  );
}
