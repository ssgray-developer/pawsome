import 'package:flutter/material.dart';

class AppColors {
  static Color primary = HexColor.fromHex('#2AAA8A');
  static Color secondary = HexColor.fromHex('#69f0ce');
  static Color grey = HexColor.fromHex('#a39d9d');
  static Color white = HexColor.fromHex('#FFFFFF');
  static Color black = Colors.black;
  static Color red = Colors.red;
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
