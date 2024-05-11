import 'package:flutter/material.dart';

ThemeData getLightTheme() {
  return ThemeData(
    primarySwatch: Colors.deepOrange,
    fontFamily: 'Montserrat',
  );
}

ThemeData getDarkTheme() {
  final theme = ThemeData(
    primarySwatch: Colors.lime,
    brightness: Brightness.dark,
    fontFamily: 'Montserrat',
  );
  return theme.copyWith(colorScheme: theme.colorScheme.copyWith(secondary: Colors.lightGreenAccent));
}