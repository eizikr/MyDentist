import 'package:flutter/material.dart';
import 'package:my_dentist/apps/home/home_page.dart';
import 'package:my_dentist/modules/assistant.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/calendar.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'treatments/treatments_screen.dart';

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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color.fromARGB(255, 156, 224, 255),
                  ),
                  onPressed: () => showHistory
                      ? setState(() {
                          showHistory = !showHistory;
                          title = "Future Treatments";
                        })
                      : null,
                  child: const Text('Future Treatments'),
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color.fromARGB(255, 156, 224, 255),
                  ),
                  onPressed: () => showHistory
                      ? null
                      : setState(() {
                          showHistory = !showHistory;
                          title = "Treatments History";
                        }),
                  child: const Text('History'),
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color.fromARGB(255, 156, 224, 255),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchedulePlanner(
                        patient_id: widget.patientID,
                      ),
                    ),
                  ),
                  child: const Text('Create Treatment'),
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
      is_history: true,
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
      is_history: false,
    ),
    // Second column content
  );
}
