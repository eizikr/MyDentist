import 'package:flutter/material.dart';
import 'package:my_dentist/apps/home/home_page.dart';
import 'package:my_dentist/modules/assistant.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/calendar.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:get/get.dart';

class PatientTreatmentsPage extends StatefulWidget {
  final String patientID;
  const PatientTreatmentsPage({super.key, required this.patientID});
  @override
  State<PatientTreatmentsPage> createState() => _PatientTreatmentsPageState();
}

class _PatientTreatmentsPageState extends State<PatientTreatmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BasicButton(
                text: 'Create Treatment',
                onClicked: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SchedulePlanner(
                      patient_id: widget.patientID,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // First column content
      ),
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
              bottom: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
              top: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
              right: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
            ),
          ),
          // Second column content
        ),
      ),
    ]);
  }
}
