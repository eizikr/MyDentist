import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget loadingCircule() {
  return const Center(
    child: CircularProgressIndicator(
      strokeWidth: 8.0,
      color: Colors.blue,
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
