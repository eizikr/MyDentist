import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';

class PatientStatusInfo extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final DateTime today = DateTime.now();

  PatientStatusInfo({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) => privateInfoScreen(patientData);
}

Widget privateInfoScreen(Map<String, dynamic> data) {
  EncryptData crypto = Get.find();

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
