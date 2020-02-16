import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Image.asset(
      brightness == Brightness.dark ?
      "assets/icons/metext-logo-white.png" :
      "assets/icons/metext-logo-black.png",
      height: 200,
    );
  }
}