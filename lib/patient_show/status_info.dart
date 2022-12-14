import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets.dart';

class PatientStatusInfo extends StatelessWidget {
  final String patientID;
  final DateTime today = DateTime.now();

  PatientStatusInfo({super.key, required this.patientID});

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
            return privateInfoScreen(data);
            //Center(child: Text('First name: ${data['first_name']}'));
          }
          return loadingCircule();
        })));
  }
}

Widget privateInfoScreen(Map<String, dynamic> data) {
  return SingleChildScrollView(
    child: Column(children: [
      Text('Status: ${data['status']}'),
      SizedBox(height: 10),
      Text('General Remarks: ${data['remarks']}'),
    ]),
  );
}
