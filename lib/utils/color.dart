import 'package:flutter/material.dart';

class UtilColor {
  static Color getColorFromHex(String? hexColor) {
    if (hexColor != null) {
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return Color(int.tryParse(hexColor, radix: 16) ?? 255);
    }
    return Colors.black;
  }

  ///Singleton factory
  static final UtilColor _instance = UtilColor._internal();

  factory UtilColor() {
    return _instance;
  }

  UtilColor._internal();
}

extension ColorToHex on Color {
  String get toHex {
    return value.toRadixString(16);
  }
}
