import 'package:flutter/material.dart';
import 'package:my_dentist/apps/home/home_page.dart';
import 'package:my_dentist/apps/patient/patient_show/treatments/treatments_list.dart';
import 'package:my_dentist/modules/assistant.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/calendar.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PatientTreatmentsPage extends StatefulWidget {
  final String patientID;
  const PatientTreatmentsPage({super.key, required this.patientID});
  @override
  State<PatientTreatmentsPage> createState() => _PatientTreatmentsPageState();
}

class _PatientTreatmentsPageState extends State<PatientTreatmentsPage> {
  bool showHistory = false;
  String title = "Future Treatments";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                BasicButton(
                  onClicked: () => showHistory
                      ? setState(() {
                          showHistory = !showHistory;
                          title = "Future Treatments";
                        })
                      : null,
                  text: 'Future Treatments',
                ),
                const SizedBox(
                  height: 10,
                ),
                BasicButton(
                  onClicked: () => showHistory
                      ? null
                      : setState(() {
                          showHistory = !showHistory;
                          title = "Treatments History";
                        }),
                  text: 'History',
                ),
                const SizedBox(
                  height: 10,
                ),
                BasicButton(
                  onClicked: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchedulePlanner(
                        patient_id: widget.patientID,
                      ),
                    ),
                  ),
                  text: 'Create Treatment',
                ),
                const SizedBox(
                  height: 10,
                ),
                BasicButton(
                  onClicked: () {},
                  text: 'Treatments plan',
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: showHistory
              ? historyTreatmentsScreen(widget.patientID)
              : futureTreatmentsScreen(widget.patientID),
        ),
      ],
    );
  }
}

Widget historyTreatmentsScreen(String patientID) {
  return Container(
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
    child: ShowTreatmentScreen(
      patientID: patientID,
      isHistory: true,
    ),
    // Second column content
  );
}

Widget futureTreatmentsScreen(String patientID) {
  return Container(
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
    child: ShowTreatmentScreen(
      patientID: patientID,
      isHistory: false,
    ),
    // Second column content
  );
}
