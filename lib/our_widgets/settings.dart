import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum PasswordStrengh {
  low,
  fair,
  good,
  excellent,
}

class OurSettings {
  static const Color backgroundColor = Color(0xFF81D4FA);
  static const Color appbarColor = Color.fromARGB(255, 99, 204, 253);
  static const Color textFieldColor = Color.fromARGB(47, 28, 72, 129);
  static const Color buttonColor = Color.fromARGB(255, 156, 224, 255);
  static const PasswordStrengh passwordStrengh = PasswordStrengh.low;
  static const MaterialColor mainColors = MaterialColor(
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
      900: Color(0xFF4FC3F7),
    },
  );
  // fonts: roboto, montserrat, lato, Open Sans, poppins
  static TextStyle titleFont = GoogleFonts.caveat(
    fontSize: 55,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
    color: Colors.blueGrey.shade900,
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 4,
        offset: const Offset(2, 2),
      ),
    ],
  );
  static TextStyle buttonsTextFont = GoogleFonts.poppins(
    fontSize: 17,
    color: Colors.black,
  );
}
