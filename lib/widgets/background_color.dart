import 'package:flutter/material.dart';

Color getBackgroundColor(BuildContext context) {
  final brightness = Theme.of(context).brightness;
  return brightness == Brightness.dark
      ? Color.fromARGB(255, 31, 18, 51)
      : Colors.white;
}
