import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class HomePageButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final IconData icon;

  const HomePageButton({
    Key? key,
    required this.text,
    required this.onClicked,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: OurSettings.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onClicked,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            Text(
              '  $text',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: OurSettings.buttonColor,
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
}
