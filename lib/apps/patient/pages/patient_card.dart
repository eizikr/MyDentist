import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/pages/patient_card.dart
import 'package:my_dentist/forms/show_patienr_form.dart';
import 'package:side_navigation/side_navigation.dart';
import '../forms/add_patient_form.dart';
import '../modules/patient.dart';

=======
import 'package:my_dentist/apps/patient/patient_show/comunication_info.dart';
import 'package:my_dentist/apps/patient/patient_show/private_info.dart';
import 'package:my_dentist/apps/patient/patient_show/status_info.dart';
import 'package:side_navigation/side_navigation.dart';
>>>>>>> 8eada838199b47baf8e24174d41a36350a7c6e12:lib/apps/patient/pages/patient_card.dart

class PatientCard extends StatefulWidget {
  final String patientID;
  const PatientCard({super.key, required this.patientID});

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
<<<<<<< HEAD:lib/pages/patient_card.dart

  List<Widget> views = const [
    Center(
      child: ShowPatientForm(),
=======
  late String _patientID;

  @override
  void initState() {
    super.initState();
    _patientID = widget.patientID;
  }

  late List<Widget> views = [
    Center(
      child: PatientPrivateInfo(patientID: _patientID),
>>>>>>> 8eada838199b47baf8e24174d41a36350a7c6e12:lib/apps/patient/pages/patient_card.dart
    ),
    Center(
      child: PatientComunicationInfo(patientID: _patientID),
    ),
    const Center(
      child: Text('Coming soon...'),
    ),
    Center(
      child: PatientStatusInfo(patientID: _patientID),
    ),
    const Center(
      child: Text('edit page'),
    ),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    final Patient patient = ModalRoute.of(context)!.settings.arguments as Patient;
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            initiallyExpanded: false,
            header: SideNavigationBarHeader(
                image: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 207, 235, 248),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    tooltip: "Exit",
                  ),
                ),
<<<<<<< HEAD:lib/pages/patient_card.dart
                title: const Text('Patient ID: '),
                subtitle: Text('${patient.id}')),
=======
                title: const Text('Patient Card'),
                subtitle: const Text('Show Details')),
>>>>>>> 8eada838199b47baf8e24174d41a36350a7c6e12:lib/apps/patient/pages/patient_card.dart
            footer: const SideNavigationBarFooter(label: Text('Close bar')),
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.manage_accounts_rounded,
                label: 'Private-Info',
              ),
              SideNavigationBarItem(
                icon: Icons.phone,
                label: 'Comunication',

              ),
              SideNavigationBarItem(
                icon: Icons.medical_information,
                label: 'Medical-Info',
              ),
              SideNavigationBarItem(
                icon: Icons.description_sharp,
                label: 'Patient-Status',
              ),
              SideNavigationBarItem(
                icon: Icons.edit_note,
                label: 'Edit Patient Info',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            toggler: const SideBarToggler(
              shrinkIcon: Icons.keyboard_arrow_left,
              expandIcon: Icons.keyboard_arrow_right,
            ),
            theme: SideNavigationBarTheme(
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme(
                selectedItemColor: Colors.lightBlue,
                unselectedItemColor: Colors.black,
              ),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(25),
              child: Container(
                child: views.elementAt(selectedIndex),
              ),
            ),
          )
        ],
      ),
    );
  }
}
