import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:side_navigation/side_navigation.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  List<Widget> views = const [
    Center(
      child: Text('Show Private Information'),
    ),
    Center(
      child: Text('Show Comunication Details'),
    ),
    Center(
      child: Text('Show Medical Information'),
    ),
    Center(
      child: Text('Show Patient Status and General Details'),
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
                  backgroundColor: Color.fromARGB(255, 207, 235, 248),
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
                title: Text('Add Patient'),
                subtitle: Text('To System')),
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
            child: views.elementAt(selectedIndex),
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
