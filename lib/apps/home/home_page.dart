import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_dentist/apps/documents/prescription_page.dart';
import 'package:my_dentist/apps/documents/sick_leave_page.dart';

import 'package:my_dentist/apps/home/home_components.dart';

import 'package:my_dentist/apps/planner/schedule_planner.dart';

import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/buttons.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';
import 'package:my_dentist/apps/patient/pages/add_patient/add_patient.dart';
import 'package:my_dentist/our_widgets/settings.dart';
import 'package:my_dentist/apps/reports/report.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference patient =
      FirebaseFirestore.instance.collection('Patients');

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const LoadingPage(loadingText: "Loading home page")
        : Scaffold(
            appBar: homePageAppBar(context),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 700,
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services,
                          size: 60,
                          color: Colors.blueGrey.shade900,
                        ),
                        Text(
                          'My Dentist',
                          style: OurSettings.titleFont,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          getBlessingTitle(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 40),
                        HomePageButton(
                          text: 'Patient Card',
                          onClicked: () async {
                            await showDialog<void>(
                              context: context,
                              builder: (context) => const SearchPatientDialog(),
                            );
                          },
                          icon: Icons.person_search_sharp,
                        ),
                        const SizedBox(height: 35),
                        HomePageButton(
                          text: 'Schedule Planner',
                          onClicked: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SchedulePlanner(),
                              ),
                            );
                          },
                          icon: Icons.date_range_rounded,
                        ),
                        const SizedBox(height: 35),
                        HomePageButton(
                          text: 'Documents',
                          onClicked: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: OurSettings.mainColors[100],
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 16.0),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          BasicButton(
                                            onClicked: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PrescriptionFormPage(),
                                                ),
                                              );
                                            },
                                            text: 'Prescriptions',
                                          ),
                                          const SizedBox(height: 16.0),
                                          BasicButton(
                                            text: 'Sick Leave',
                                            onClicked: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SickLeaveFormPage(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                    ],
                                  ),
                                );
                              },
                            ),
                          },
                          icon: Icons.file_copy_rounded,
                        ),
                        const SizedBox(height: 35),
                        HomePageButton(
                          text: 'Add Patient',
                          onClicked: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddPatientPage(),
                              ),
                            );
                          },
                          icon: Icons.person_add_rounded,
                        ),
                        const SizedBox(height: 35),
                        HomePageButton(
                          text: 'Reports',
                          onClicked: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ReportPage(),
                              ),
                            )
                          },
                          icon: Icons.auto_graph_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
