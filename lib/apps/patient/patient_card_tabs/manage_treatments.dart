import 'package:flutter/material.dart';
import 'package:my_dentist/apps/patient/patient_card_tabs/treatments_tab/treatments_list.dart';
import 'package:my_dentist/apps/payment/payment_dialog.dart';
import 'package:my_dentist/apps/planner/schedule_planner.dart';
import 'package:my_dentist/our_widgets/buttons.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

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
                SizedBox(
                  width: 180,
                  height: 40,
                  child: BasicButton(
                    onClicked: () => showHistory
                        ? setState(() {
                            showHistory = !showHistory;
                            title = "Future Treatments";
                          })
                        : null,
                    text: 'Future Treatments',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 180,
                  height: 40,
                  child: BasicButton(
                    onClicked: () => showHistory
                        ? null
                        : setState(() {
                            showHistory = !showHistory;
                            title = "Treatments History";
                          }),
                    text: 'History',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 180,
                  height: 40,
                  child: BasicButton(
                    onClicked: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchedulePlanner(
                          patientId: widget.patientID,
                        ),
                      ),
                    ),
                    text: 'Create Treatment',
                  ),
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
    decoration: ourBoxDecoration(),
    child: ShowTreatmentScreen(
      patientID: patientID,
      isHistory: true,
    ),
    // Second column content
  );
}

Widget futureTreatmentsScreen(String patientID) {
  return Container(
    decoration: ourBoxDecoration(),
    child: ShowTreatmentScreen(
      patientID: patientID,
      isHistory: false,
    ),
    // Second column content
  );
}
