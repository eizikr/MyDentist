import 'package:flutter/material.dart';

enum PasswordStrengh {
  low,
  fair,
  good,
  excellent,
}

class ourSettings {
  static const Color backgroundColor = Color(0xFFB3E5FC);
  static const Color appbarColor = Color(0xFF81D4FA);
  static const PasswordStrengh passwordStrengh = PasswordStrengh.low;

  static const MaterialColor backgroundColors = MaterialColor(
    0xFF29B6F6,
    <int, Color>{
      50: Color(0xFFE1F5FE),
      100: Color(0xFFB3E5FC),
      200: Color(0xFF81D4FA),
      300: Color(0xFF4FC3F7),
      400: Color(0xFF29B6F6),
      500: Color(0xFF03A9F4),
      600: Color(0xFF039BE5),
      700: Color(0xFF0288D1),
      800: Color(0xFF0277BD),
      900: Color(0xFF01579B),
    },
  );
}
