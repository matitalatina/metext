import 'package:flutter/material.dart';

class GradientBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final gradient = brightness == Brightness.dark ?
    [Colors.blue.shade900, Colors.deepPurple.shade800] :
    [Colors.deepOrange, Colors.red];
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient)),
    );
  }
}
