import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_dentist/our_widgets/settings.dart';

Widget loadingCircule(String circuleText) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: Colors.blue[300],
        ),
        const SizedBox(
          height: 20,
        ), // add some space between the progress indicator and the title
        Text(circuleText)
      ],
    ),
  );
}

Widget loadingDialog() {
  return AlertDialog(
    content: CircularProgressIndicator(
      color: Colors.blue[300],
    ),
  );
}

bool isPatientExists(String id) {
  DocumentSnapshot<Map<String, dynamic>> document = (FirebaseFirestore.instance
      .collection('Patients')
      .get()) as DocumentSnapshot<Map<String, dynamic>>;
  if (document.exists) return true;
  return false;
}

Future<bool?> errorToast(String myMsg) {
  return Fluttertoast.showToast(
    msg: myMsg,
    gravity: ToastGravity.TOP,
    fontSize: 10.0,
    webShowClose: true,
    backgroundColor: Colors.red,
    toastLength: Toast.LENGTH_LONG,
    webPosition: "center",
    webBgColor: "red",
    timeInSecForIosWeb: 2,
  );
}

Future<bool?> successToast(String myMsg) {
  return Fluttertoast.showToast(
    msg: myMsg,
    gravity: ToastGravity.TOP,
    fontSize: 10.0,
    webShowClose: true,
    backgroundColor: Colors.black,
    toastLength: Toast.LENGTH_LONG,
    webPosition: "center",
    webBgColor: "linear-gradient(to right, #00b09b, #96c93d)",
    timeInSecForIosWeb: 2,
  );
}

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
