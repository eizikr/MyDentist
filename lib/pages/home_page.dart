import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_dentist/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_dentist/our_widgets.dart';
import 'package:my_dentist/pages/add_patient.dart';
import 'package:my_dentist/pages/patient_card.dart';
import 'package:my_dentist/pages/show_patient.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> signOut() async {
  await Auth().signOut();
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;

  final _patientController = TextEditingController();

  final firestore = FirebaseFirestore.instance;

  Widget _title({double fontSize = 40}) {
    return Text(
      'Home Page',
      style: GoogleFonts.lato(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    var screenWidth = queryData.size.width;
    var screenHeight = queryData.size.height;

    bool patientExists = false;

    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth / 3, vertical: screenHeight / 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _title(fontSize: screenWidth * 0.04),
              const SizedBox(height: 60),
              ButtonWidget(
                  text: 'Show Patient',
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowPatient(),
                      ),
                    );
                  }),
              const SizedBox(height: 35),
              ButtonWidget(
                text: 'Patient Card',
                onClicked: () async {
                  await openDialog(context);
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
              ButtonWidget(text: 'Reports', onClicked: () => {}),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openDialog(context) => showDialog<void>(
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
                  onPressed: () async => dialog_submit(context),
                  child: const Text('Show Patient Card'),
                ),
              ],
            )
          ],
        ),
      );

  void dialog_submit(BuildContext context) {
    String patientID = _patientController.text;
    _patientController.clear();
    if (patientID.isNotEmpty) {
      DocumentReference patientRef =
          firestore.collection('Patients').doc(patientID);
      patientRef.get().then((value) => {
            if (value.exists)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientCard(patientID: patientID),
                ),
              )
            else
              {errorToast('ID not found')}
          });
    } else {
      errorToast('Please fill the ID field');
    }
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.lightBlue[100],
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            const Spacer(
              flex: 1,
            ),
            const IconButton(
              tooltip: 'Logout',
              icon: Icon(Icons.logout),
              onPressed: signOut,
            ),
            const Spacer(
              flex: 10,
            ),
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
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
