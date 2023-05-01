import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class PatientComunicationInfo extends StatelessWidget {
  final String patientID;
  DateTime today = DateTime.now();

  PatientComunicationInfo({super.key, required this.patientID});

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
          }
          return loadingCircule('Loading comunication info...');
        })));
  }
}

Widget privateInfoScreen(Map<String, dynamic> data) {
  EncryptData crypto = Get.find();
  return SingleChildScrollView(
    child: Column(children: [
      Text(
        'Phone number: ${crypto.decryptAES(data['phone'])}',
        style: const TextStyle(fontSize: 20),
      ),
      Container(
          child: data['home_phone'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Home phone: ${crypto.decryptAES(data['home_phone'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      const SizedBox(height: 15),
      Container(
          child: data['email1'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Email1: ${crypto.decryptAES(data['email1'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      const SizedBox(height: 15),
      Container(
          child: data['email2'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Email2: ${crypto.decryptAES(data['email2'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      Container(
          child: data['inisurance_company'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Insurance Company: ${crypto.decryptAES(data['inisurance_company'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      Container(
          child: data['fax'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Fax: ${crypto.decryptAES(data['fax'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      Container(
          child: data['HMO'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'HMO: ${crypto.decryptAES(data['HMO'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      Container(
          child: data['treating_doctor'] != null
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Treating Doctor: ${crypto.decryptAES(data['treating_doctor'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
    ]),
  );
}
