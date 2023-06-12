import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_dentist/apps/patient/pages/patient_card.dart';
import 'package:my_dentist/apps/settings/add_doctor.dart';
import 'package:my_dentist/apps/settings/edit_assistants.dart';
import 'package:my_dentist/apps/settings/edit_treatment_types.dart';
import 'package:my_dentist/auth.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';

enum MenuItem {
  editTreatmentType,
  editAssistents,
  addDoctorUser,
  logout,
}

PreferredSizeWidget homePageAppBar(BuildContext context) => AppBar(
      title: Center(
        child: Title(
          color: Colors.white,
          title: 'Home page',
          child: const Text('Home Page'),
        ),
      ),
      backgroundColor: OurSettings.appbarColor,
      actions: [
        Theme(
          data: Theme.of(context).copyWith(
            popupMenuTheme: PopupMenuThemeData(
              color: OurSettings.mainColors[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: PopupMenuButton<MenuItem>(
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'More Options',
            onSelected: (value) {
              if (value == MenuItem.editTreatmentType) {
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
                Auth().signOut();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<MenuItem>(
                value: MenuItem.editTreatmentType,
                child: ListTile(
                  leading: Icon(
                    Icons.type_specimen_rounded,
                  ),
                  title: Text(
                    'Treatment Types',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.editAssistents,
                child: ListTile(
                  leading: Icon(
                    Icons.person_2_rounded,
                  ),
                  title: Text(
                    'Assistants',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.addDoctorUser,
                child: ListTile(
                  leading: Icon(
                    Icons.person_pin,
                  ),
                  title: Text(
                    'Doctor User',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.logout,
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );

class SearchPatientDialog extends StatefulWidget {
  const SearchPatientDialog({super.key});

  @override
  State<SearchPatientDialog> createState() => _SearchPatientDialogState();
}

class _SearchPatientDialogState extends State<SearchPatientDialog> {
  final _patientController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Please enter patient ID'),
      backgroundColor: OurSettings.mainColors[100],
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _patientController,
          decoration: const InputDecoration(
            labelText: 'Patient ID',
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          validator: (value) {
            if (value!.isEmpty) {
              return "Enter Patient ID";
            } else if (value.length != 9) {
              return "Must Be 9 Digits";
            }
            return null;
          },
        ),
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
              },
              child: const Text('Show Patient Card'),
            ),
          ],
        )
      ],
    );
  }

  void dialogSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final DB db = Get.find();
      String patientID = _patientController.text;
      if (patientID.isNotEmpty) {
        DocumentReference patientRef =
            _firestore.collection('Patients').doc(patientID);

        try {
          DocumentSnapshot doc = await patientRef.get();
          db.setAssistantNames();
          db.setTreatmentTypeCodes();
          final data = doc.data() as Map<String, dynamic>;
          void dismissDialogAndNavigate() {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientCard(patientData: data),
              ),
            );
          }

          dismissDialogAndNavigate();
        } catch (e) {
          errorToast('ID not found');
        }

        _patientController.clear();
      }
    }
  }
}

String getBlessingTitle() {
  int currentHour = DateTime.now().hour;
  String doctorName = getCurrentUserDisplayName();
  String blessing = 'Good ';
  if (currentHour > 4 && currentHour < 10) {
    blessing += 'morning ';
  } else if (currentHour > 10 && currentHour < 17) {
    blessing += 'afternoon ';
  } else if (currentHour > 17 && currentHour < 21) {
    blessing += 'evening ';
  } else {
    blessing += 'night ';
  }
  return blessing + doctorName;
}
