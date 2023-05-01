import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class TreatmentCare extends StatefulWidget {
  Map<String, dynamic> meeting;
  String patient_id;
  TreatmentCare({super.key, required this.meeting, required this.patient_id});

  @override
  State<TreatmentCare> createState() => _TreatmentCareState();
}

class _TreatmentCareState extends State<TreatmentCare> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          title: 'Treatment',
          child: const Text('Treatment'),
        ),
        centerTitle: true,
        backgroundColor: ourSettings.appbarColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'Exit',
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
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
              ),
            ),
            Expanded(
              flex: 4,
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
                    right: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
