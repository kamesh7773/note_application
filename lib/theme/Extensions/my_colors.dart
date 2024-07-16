import 'package:flutter/material.dart';

@immutable
class MyColors extends ThemeExtension<MyColors> {
  const MyColors({
    this.googleFacebook,
    this.buttonColor,
    this.commanColor,
    this.drawerListTileColor,
    this.toggleSwitch,
  });

  //! Declaring varible for custom color for
  final Color? commanColor;
  final Color? buttonColor;
  final Color? googleFacebook;
  final Color? drawerListTileColor;
  final Color? toggleSwitch;

  @override
  ThemeExtension<MyColors> copyWith({
    Color? commanColor,
    Color? buttonColor,
    Color? googleFacebook,
    Color? drawerListTileColor,
    Color? toggleSwitch,
  }) {
    return MyColors(
      commanColor: commanColor ?? this.commanColor,
      buttonColor: buttonColor ?? this.buttonColor,
      googleFacebook: buttonColor ?? this.googleFacebook,
      drawerListTileColor: buttonColor ?? this.drawerListTileColor,
      toggleSwitch: buttonColor ?? this.toggleSwitch,
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
      drawerListTileColor:
          Color.lerp(drawerListTileColor, other.drawerListTileColor, t),
      toggleSwitch: Color.lerp(toggleSwitch, other.toggleSwitch, t),
    );
  }

  //! variable Colors for Dark Theme.
  static final dark = MyColors(
    commanColor: Colors.white,
    buttonColor: const Color.fromARGB(255, 100, 100, 100),
    googleFacebook: const Color.fromARGB(255, 209, 206, 206),
    drawerListTileColor: Colors.grey[400],
    toggleSwitch: Colors.white,
  );

  //! variable Colors for light Theme.
  static final light = MyColors(
    commanColor: Colors.black,
    buttonColor: Colors.black,
    googleFacebook: Colors.grey.shade300,
    drawerListTileColor: Colors.grey[400],
    toggleSwitch: Colors.black,
  );
}
