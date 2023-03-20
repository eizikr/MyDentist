import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class EditPatientInfo extends StatelessWidget {
  final String patientID;
  final DateTime today = DateTime.now();

  EditPatientInfo({super.key, required this.patientID});

  @override
  Widget build(BuildContext context) {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patients');

    return FutureBuilder<DocumentSnapshot>(
        future: patient.doc(patientID).get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return editPatientInfoScreen(data);
          }
          return loadingCircule('Loading status...');
        })));
  }
}

Widget editPatientInfoScreen(Map<String, dynamic> data) {
  final myController = TextEditingController();

  return SingleChildScrollView(
    child: Column(children: [
      TextField(
        controller: myController,
        decoration: InputDecoration(
          labelText: 'Phone number: ${data['phone']}',
        ),
      ),
    ]),
  );
}
