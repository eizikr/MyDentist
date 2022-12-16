import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget loadingCircule({String circuleText = "loading..."}) {
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
  ));
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
    timeInSecForIosWeb: 5,
  );
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

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
          child: loadingCircule(),
        ),
      ),
    );
  }
}
