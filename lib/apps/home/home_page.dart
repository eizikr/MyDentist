import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:my_dentist/apps/settings/add_doctor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_dentist/apps/planner/schedule_planner.dart';

import 'package:my_dentist/apps/settings/edit_assistants.dart';
import 'package:my_dentist/auth.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/buttons.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/apps/patient/pages/add_patient.dart';
import 'package:my_dentist/apps/patient/pages/patient_card.dart';
import 'package:my_dentist/apps/settings/edit_treatment_types.dart';
import 'package:my_dentist/our_widgets/settings.dart';
import 'package:my_dentist/apps/reports/report.dart';

enum MenuItem {
  settings,
  editTreatmentType,
  editAssistents,
  addDoctorUser,
  logout,
}

Future<void> signOut() async {
  await Auth().signOut();
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference patient =
      FirebaseFirestore.instance.collection('Patients');

  final _patientController = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    var screenWidth = queryData.size.width;
    var screenHeight = queryData.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Home Page',
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: OurSettings.appbarColor,
        actions: [
          PopupMenuButton<MenuItem>(
            tooltip: 'More Options',
            onSelected: (value) {
              if (value == MenuItem.settings) {
                null;
              } else if (value == MenuItem.editTreatmentType) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditTreatmentTypesPage(),
                  ),
                );
              } else if (value == MenuItem.editAssistents) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditAssistentPage(),
                  ),
                );
              } else if (value == MenuItem.addDoctorUser) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateUserPage(),
                  ),
                );
              } else if (value == MenuItem.logout) {
                signOut();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MenuItem.settings,
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuItem(
                value: MenuItem.editTreatmentType,
                child: ListTile(
                  leading: Icon(Icons.add_box_outlined),
                  title: Text('Edit Treatment Types'),
                ),
              ),
              const PopupMenuItem(
                value: MenuItem.editAssistents,
                child: ListTile(
                  leading: Icon(Icons.add_box_outlined),
                  title: Text('Edit Assistants'),
                ),
              ),
              const PopupMenuItem(
                value: MenuItem.addDoctorUser,
                child: ListTile(
                  leading: Icon(Icons.add_box_outlined),
                  title: Text('Create Doctor User'),
                ),
              ),
              const PopupMenuItem(
                value: MenuItem.logout,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth / 3, vertical: screenHeight / 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.medical_services,
                size: 60,
              ),
              Text(
                'My Dentist',
                style: GoogleFonts.caveat(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35),
              HomePageButton(
                text: 'Patient Card',
                onClicked: () async {
                  await openSearchPatientDialog(context);
                },
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
                  }),
              const SizedBox(height: 35),
              HomePageButton(
                text: 'Treatment Plan',
                onClicked: () => {},
              ),
              const SizedBox(height: 35),
              HomePageButton(
                  text: 'Schedule planner',
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchedulePlanner(),
                      ),
                    );
                  }),
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
                      }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openSearchPatientDialog(context) => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Please enter patient ID'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Patient ID',
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _patientController,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async => Navigator.of(context).pop(),
                  child: const Text('Cancle'),
                ),
                TextButton(
                  onPressed: () async {
                    dialogSubmit(context);
                    _patientController.clear();
                  },
                  child: const Text('Show Patient Card'),
                ),
              ],
            )
          ],
        ),
      );

  void dialogSubmit(BuildContext context) {
    String patientID = _patientController.text;
    if (patientID.isNotEmpty) {
      DocumentReference patientRef =
          firestore.collection('Patients').doc(patientID);
      patientRef.get().then((value) => {
            if (value.exists)
              {
                Navigator.of(context).pop(),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientCard(patientID: patientID),
                  ),
                ),
              }
            else
              {errorToast('ID not found')}
          });
    } else {
      errorToast('Please fill the ID field');
    }
  }
}
