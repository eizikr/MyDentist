import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const HomePageButton({
    required this.text,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: const StadiumBorder(),
          backgroundColor: const Color.fromARGB(255, 156, 224, 255),
        ),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: GoogleFonts.roboto(fontSize: 17, color: Colors.black),
          ),
        ),
      );
}

class BasicButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const BasicButton({
    super.key,
    required this.text,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: const Color.fromARGB(255, 156, 224, 255),
        ),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: GoogleFonts.roboto(fontSize: 17, color: Colors.black),
          ),
        ),
      );
}
