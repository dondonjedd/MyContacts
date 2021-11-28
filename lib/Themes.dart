import 'package:flutter/material.dart';
class Themes {
  static final Themes _theme = Themes.internal();
  factory Themes() {
    return _theme;
  }
  Themes.internal();

  getThemeLight() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.green,
    );
  }

  getThemeDark() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey,
    );
  }
}