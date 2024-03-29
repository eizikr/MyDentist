import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class LoadingPage extends StatefulWidget {
  final String loadingText;
  const LoadingPage({required this.loadingText, super.key});
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: Container(
          child: loadingCircule(widget.loadingText),
        ),
      ),
    );
  }
}

Widget loadingCircule(String circuleText) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: OurSettings.mainColors[300],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          circuleText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )
      ],
    ),
  );
}
