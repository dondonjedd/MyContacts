import 'package:flutter/material.dart';
class Themes {
  static final Themes _theme = Themes.internal();
  factory Themes() {
    return _theme;
  }
  Themes.internal();

  getThemeLight() {

    return ThemeData(
      brightness: Brightness.light,
      fontFamily: "Open sans",
      primaryColor: Colors.green,
    );
  }

  getThemeDark() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Open sans",
      primaryColor: Colors.blueGrey,
    );
  }
}