import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

import '../../../our_widgets/global.dart';

class PatientPrivateInfo extends StatelessWidget {
  final String patientID;

  const PatientPrivateInfo({super.key, required this.patientID});

  @override
  Widget build(BuildContext context) {
    final DB db = Get.find();

    CollectionReference patient = db.patients;

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
  EncryptData crypto = Get.find();
  return SingleChildScrollView(
    child: Column(children: [
      Text(
        'First name: ${crypto.decryptAES(data['first_name'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Last name: ${crypto.decryptAES(data['last_name'])}',
        style: const TextStyle(fontSize: 20),
      ),
      Container(
          child: data['fathers_name'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Father'
                    's name: ${crypto.decryptAES(data['fathers_name'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      const SizedBox(height: 15),
      Text(
        'ID: ${crypto.decryptAES(data['id'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Birth date: ${crypto.decryptAES(data['date_of_birth'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Age: ${crypto.decryptAES(data['age'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Address: ${crypto.decryptAES(data['address'])}/${crypto.decryptAES(data['houseNumber'])}, ${crypto.decryptAES(data['city'])}',
        style: const TextStyle(fontSize: 20),
      ),
      Container(
          child: data['postalCode'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Postal Code: ${crypto.decryptAES(data['postalCode'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      const SizedBox(height: 15),
      Text(
        'Counter of birth: ${crypto.decryptAES(data['countryBirth'])}',
        style: const TextStyle(fontSize: 20),
      ),
      Container(
          child: data['profession'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Profession: ${crypto.decryptAES(data['profession'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
    ]),
  );
}
