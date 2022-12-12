import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../modules/patient.dart';

class ShowPatient extends StatefulWidget {
  const ShowPatient({super.key});

  @override
  State<ShowPatient> createState() => _ShowPatientState();
}

class _ShowPatientState extends State<ShowPatient> {
  Stream<List<Patient>> readPatients() => FirebaseFirestore.instance
      .collection('Patients')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Patient.fromJson(doc.data())).toList());

  Widget buildPatient(Patient patient) => ListTile(
        leading: CircleAvatar(child: Text(patient.id)),
        title: Text(patient.id),
        subtitle: Text('${patient.firstName} ${patient.lastName}'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
            tooltip: "Go back to home page",
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        automaticallyImplyLeading: false,
        title: const Text('search patient card'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[200],
      ),
      body: StreamBuilder<List<Patient>>(
        stream: readPatients(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('somthing went wrong ${snapshot.error}');
          } else if (snapshot.hasData) {
            final patients = snapshot.data!;
            return ListView(
              children: patients.map(buildPatient).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
