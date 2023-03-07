import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:my_dentist/apps/settings_pages/edit_assistants.dart';
import 'package:my_dentist/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/apps/patient/pages/add_patient.dart';
import 'package:my_dentist/apps/patient/pages/patient_card.dart';
import 'package:my_dentist/apps/settings_pages/edit_treatment_types.dart';
import 'package:my_dentist/apps/reports/report.dart';

enum MenuItem {
  settings,
  editTreatmentType,
  editAssistents,
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
        backgroundColor: Colors.lightBlue[100],
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
              horizontal: screenWidth / 3, vertical: screenHeight / 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ButtonWidget(
              //     text: 'Show Patient',
              //     onClicked: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const ShowPatient(),
              //         ),
              //       );
              //     }),
              const SizedBox(height: 35),
              ButtonWidget(
                text: 'Patient Card',
                onClicked: () async {
                  await openSearchPatientDialog(context);
                },
              ),
              const SizedBox(height: 35),
              ButtonWidget(
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
              ButtonWidget(
                text: 'Treatment Plan',
                onClicked: () => {},
              ),
              const SizedBox(height: 35),
              ButtonWidget(text: 'daily planner', onClicked: () => {}),
              const SizedBox(height: 35),
              ButtonWidget(text: 'Reports', onClicked: () => {
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

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: const StadiumBorder(),
          backgroundColor: Colors.lightBlue[100],
        ),
        onPressed: onClicked,
        child: FittedBox(
          child: Text(
            text,
            style: GoogleFonts.roboto(fontSize: 17, color: Colors.black),
          ),
        ),
      );
}
