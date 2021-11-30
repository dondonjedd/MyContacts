import 'package:flutter/material.dart';
class Themes {
  static final Themes _theme = Themes.internal();
  factory Themes() {
    return _theme;
  }
  Themes.internal();

  //theme for light mode
  getThemeLight() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: "Open sans",
    );
  }

  //theme for dark mode
  getThemeDark() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Open sans",
    );
  }
}