import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class PatientComunicationInfo extends StatelessWidget {
  final String patientID;
  DateTime today = DateTime.now();

  PatientComunicationInfo({super.key, required this.patientID});

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
          }
          return loadingCircule();
        })));
  }
}

Widget privateInfoScreen(Map<String, dynamic> data) {
  return SingleChildScrollView(
    child: Column(children: [
      Text('Phone number: ${data['phone']}'),
      const SizedBox(height: 10),
      Text('Home phone: ${data['home_phone']}'),
      const SizedBox(height: 10),
      Text('Email1: ${data['email1']}'),
      const SizedBox(height: 10),
      Text('Email2: ${data['email2']}'),
      const SizedBox(height: 10),
      Text('Insurance Company: ${data['inisurance_company']}'),
      const SizedBox(height: 10),
      Text('Fax: ${data['fax']}'),
      const SizedBox(height: 10),
      Text('HMO: ${data['HMO']}'),
      const SizedBox(height: 10),
      Text('Treating Doctor: ${data['treating_doctor']}'),
    ]),
  );
}
