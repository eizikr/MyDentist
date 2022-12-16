import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class PatientPrivateInfo extends StatelessWidget {
  final String patientID;
  final DateTime today = DateTime.now();

  PatientPrivateInfo({super.key, required this.patientID});

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
          return loadingCircule('Loading private info...');
        })));
  }
}

Widget privateInfoScreen(Map<String, dynamic> data) {
  return SingleChildScrollView(
    child: Column(children: [
      Text('First name: ${data['first_name']}',
          style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 15),
      Text('Last name: ${data['last_name']}',
          style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 15),
      Text('Father' 's name: ${data['fathers_name']}',
          style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 15),
      Text('ID: ${data['id']}', style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 15),
      Text('age: ${data['date_of_birth']}',
          style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 15),
      Text(
          'Address: ${data['address']}/${data['houseNumber']}, ${data['city']}',
          style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 15),
      Text('Postal Code: ${data['postalCode']}',
          style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 15),
      Text('Counter of birth: ${data['countryBirth']}',
          style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 15),
      Text(
        'Profession: ${data['profession']}',
        style: const TextStyle(fontSize: 20),
      ),
    ]),
  );
}
