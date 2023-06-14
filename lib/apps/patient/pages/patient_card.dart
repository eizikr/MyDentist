import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/apps/patient/patient_card_tabs/comunication_info.dart';
import 'package:my_dentist/apps/patient/patient_card_tabs/manage_treatments.dart';
import 'package:my_dentist/apps/patient/patient_card_tabs/private_info.dart';
import 'package:my_dentist/apps/patient/patient_card_tabs/status_info.dart';
import 'package:my_dentist/apps/patient/patient_card_tabs/edit_patient.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:side_navigation/side_navigation.dart';

class PatientCard extends StatefulWidget {
  final Map<String, dynamic> patientData;
  const PatientCard({super.key, required this.patientData});

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  late String _patientID;

  @override
  void initState() {
    super.initState();
    final EncryptData db = Get.find();
    _patientID = db.decryptAES(widget.patientData['id']);
  }

  late List<Widget> views = [
    Center(
      child: PatientPrivateInfo(patientData: widget.patientData),
    ),
    Center(
      child: PatientComunicationInfo(patientData: widget.patientData),
    ),
    Center(
      child: PatientTreatmentsPage(patientID: _patientID),
    ),
    Center(
      child: PatientStatusInfo(patientData: widget.patientData),
    ),
    Center(
      child: EditPatientInfo(patientID: _patientID),
    ),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                title: const Text('Patient Card'),
                subtitle: const Text('Show Details')),
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
