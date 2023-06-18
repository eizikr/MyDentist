import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';

class PatientStatusInfo extends StatelessWidget {
  final String patientID;
  final DateTime today = DateTime.now();
  final EncryptData crypto = Get.find();
  final DB db = Get.find();
  late Map<String, dynamic> data;

  PatientStatusInfo({super.key, required this.patientID});

  @override
  Widget build(BuildContext context) {
    CollectionReference patient = db.patients;

    return FutureBuilder<DocumentSnapshot>(
        future: patient.doc(patientID).get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            data = snapshot.data!.data() as Map<String, dynamic>;
            return privateInfoScreen(data);
          }

          return const LoadingPage(loadingText: 'Loading Patient Info');
        })));
  }

  Widget privateInfoScreen(Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            child: data['status'] != ''
                ? Text(
                    'Status: ${crypto.decryptAES(data['status'])}',
                    style: const TextStyle(fontSize: 20),
                  )
                : null),
        Container(
            child: data['remarks'] != ''
                ? Column(children: [
                    const SizedBox(height: 15),
                    Text(
                      'General Remarks: ${crypto.decryptAES(data['remarks'])}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ])
                : null),
      ]),
    );
  }
}
