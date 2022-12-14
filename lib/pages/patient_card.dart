import 'package:flutter/material.dart';
import 'package:my_dentist/patient_show/comunication_info.dart';
import 'package:my_dentist/patient_show/private_info.dart';
import 'package:my_dentist/patient_show/status_info.dart';
import 'package:side_navigation/side_navigation.dart';

class PatientCard extends StatefulWidget {
  final String patientID;

  const PatientCard({super.key, required this.patientID});

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  late String _patientID;

  @override
  void initState() {
    super.initState();
    _patientID = widget.patientID;
  }

  late List<Widget> views = [
    Center(
      child: PatientPrivateInfo(patientID: _patientID),
    ),
    Center(
      child: PatientComunicationInfo(patientID: _patientID),
    ),
    Center(
      child: Text('Show Medical Information'),
    ),
    Center(
      child: PatientStatusInfo(patientID: _patientID),
    ),
    Center(
      child: Text('Save Details'),
    ),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            header: SideNavigationBarHeader(
                image: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 207, 235, 248),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    tooltip: "Go back to home page",
                  ),
                ),
                title: const Text('Add Patient'),
                subtitle: const Text('To System')),
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
                icon: Icons.save_as_rounded,
                label: 'Save',
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

  // @override
  // Widget build(BuildContext context) {
  //   MediaQueryData? queryData;
  //   queryData = MediaQuery.of(context);

  //   var screenWidth = queryData.size.width;
  //   var screenHeight = queryData.size.height;

  //   return Scaffold(
  //     body: SingleChildScrollView(
  //       child: Container(
  //         width: screenWidth,
  //         height: screenHeight,
  //         alignment: Alignment.center,
  //         child: Container(
  //           width: screenWidth / 1.1,
  //           height: screenHeight / 1.1,
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
