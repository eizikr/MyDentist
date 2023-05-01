import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_dentist/apps/reports/patient_report.dart';
import '/modules/patient.dart';
import '/our_widgets/global.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  EncryptData crypto = Get.find();

  Widget buildPatient(Patient patient) => RawChip(
        labelPadding: const EdgeInsets.all(2.0),
        label: Text(
          '${crypto.decryptAES(patient.firstName)} ${crypto.decryptAES(patient.lastName)}',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 95, 100, 193),
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: const EdgeInsets.all(8.0),
        avatar: const Icon(Icons.person),
        deleteIcon: const Icon(Icons.remove_circle),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PatientReportPage(patient: patient)));
        },
      );

  @override
  Widget build(BuildContext context) {
    Stream<List<Patient>> readPatients() => FirebaseFirestore.instance
        .collection('Patients')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Patient.fromJson(doc.data())).toList());

    return Scaffold(
      body: StreamBuilder<List<Patient>>(
        stream: readPatients(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('something went wrong ${snapshot.error}');
          } else if (snapshot.hasData) {
            final patients = snapshot.data!;
            return Center(
              child: Wrap(
                spacing: 8.0,
                children: patients.map(buildPatient).toList(),
              ),
            );
          } else {
            return const CircularProgressIndicator(
              strokeWidth: 8.0,
              color: Colors.blue,
            );
          }
        },
      ),
    );
  }
}
