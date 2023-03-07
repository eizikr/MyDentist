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
          return loadingCircule('Loading comunication info...');
        })));
  }
}

Widget privateInfoScreen(Map<String, dynamic> data) {
  return SingleChildScrollView(
    child: Column(children: [
      Text(
        'Phone number: ${data['phone']}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Home phone: ${data['home_phone']}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Email1: ${data['email1']}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Email2: ${data['email2']}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Insurance Company: ${data['inisurance_company']}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Fax: ${data['fax']}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'HMO: ${data['HMO']}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Treating Doctor: ${data['treating_doctor']}',
        style: const TextStyle(fontSize: 20),
      ),
    ]),
  );
}
