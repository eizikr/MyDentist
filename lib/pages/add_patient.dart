import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(25),
        child: CreatePatientStepper(),
      ),
    );
  }
}

class CreatePatientStepper extends StatefulWidget {
  const CreatePatientStepper({super.key});

  @override
  State<CreatePatientStepper> createState() => _CreatePatientStepperState();
}

class _CreatePatientStepperState extends State<CreatePatientStepper> {
  int _currentStep = 0;
  DateTime today = DateTime.now();
  final _creationDateController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fathersNameController = TextEditingController();
  final _idController = TextEditingController();
  final _imageController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _countryBirthController = TextEditingController();
  final _professionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
            tooltip: "Go back to home page",
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        automaticallyImplyLeading: false,
        title: const Text('Create new patient card'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[200],
      ),
      body: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(
                  colorScheme: Theme.of(context)
                      .colorScheme
                      .copyWith(primary: Colors.lightBlue[200]),
                ),
                child: Stepper(
                  type: StepperType.vertical,
                  physics: const ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                    Step(
                      title: const Text('Patient private information'),
                      content: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          DateTimeFormField(
                            initialValue: today,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.info_outlined),
                              labelText: 'Patient creation date',
                              suffixIcon: Icon(Icons.date_range),
                            ),
                            mode: DateTimeFieldPickerMode.date,
                            autovalidateMode: AutovalidateMode.always,
                            validator: (e) => (e?.compareTo(today) ?? 0) == 1
                                ? 'You cannot enter a future date'
                                : null,
                            onDateSelected: (DateTime value) {
                              print(value);
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: "First name",
                              icon: Icon(Icons.info_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return " cannot be empty";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: "Last name",
                              icon: Icon(Icons.info_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return " cannot be empty";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _fathersNameController,
                            decoration: const InputDecoration(
                              labelText: "Father's Name",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _idController,
                            decoration: const InputDecoration(
                              labelText: "ID",
                              icon: Icon(Icons.info_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return " cannot be empty";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10),
                          DateTimeFormField(
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.info_outlined),
                              labelText: 'Date if birth',
                              suffixIcon: Icon(Icons.date_range),
                            ),
                            mode: DateTimeFieldPickerMode.date,
                            autovalidateMode: AutovalidateMode.always,
                            validator: (e) => (e?.compareTo(today) ?? 0) == 1
                                ? 'You cannot enter a future date'
                                : null,
                            onDateSelected: (DateTime value) {
                              print(value);
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _imageController,
                            decoration: const InputDecoration(
                              labelText: "Image",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: "City",
                              icon: Icon(Icons.info_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return " cannot be empty";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: "Address",
                              icon: Icon(Icons.info_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return " cannot be empty";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Postal Code",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _houseNumberController,
                            decoration: const InputDecoration(
                              labelText: "House number",
                              icon: Icon(Icons.info_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return " cannot be empty";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _countryBirthController,
                            decoration: const InputDecoration(
                              labelText: "Country of Birth",
                              icon: Icon(Icons.info_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return " cannot be empty";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _professionController,
                            decoration: const InputDecoration(
                              labelText: "Profession",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: new Text('Address'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Home Address'),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Postcode'),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: new Text('Mobile Number'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Mobile Number'),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : CreatePatient();
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
  Future CreatePatient() async{
    if (_idController != null){
/*
  DateTime today = DateTime.now();
  final _creationDateController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fathersNameController = TextEditingController();
  final _idController = TextEditingController();
  final _imageController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _countryBirthController = TextEditingController();
  final _professionController = TextEditingController();
 */

    final docUser = FirebaseFirestore.instance.collection("Patients").doc(_idController.text);
    final patient = Patient(
      first_name : _firstNameController.text,
      last_name : _lastNameController.text,
      id : docUser.id,
    );
    final json=patient.toJason();
    await docUser.set(json);
    print("saving changes");
    }
  }
}

class Patient{
  String id;
  final String first_name;
  final String last_name;

  Patient({
    this.id = '',
    required this.first_name,
    required this.last_name,
  });
  
  Map <String,dynamic> toJason() =>{
      'first_name' : first_name,
      'last_name' : last_name,
      'id' : id,
  };
}

// class AddPatientPage extends StatefulWidget {
//   const AddPatientPage({super.key});

//   @override
//   AddPatientPageState createState() {
//     return AddPatientPageState();
//   }
// }

// class AddPatientPageState extends State<AddPatientPage> {
//   DateTime today = DateTime.now();
//   final _formKey = GlobalKey<FormState>();

//   //<controller name>.text will give you the text
//   final _creationDateController = TextEditingController();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _fathersNameController = TextEditingController();
//   final _idController = TextEditingController();
//   final _imageController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _postalCodeController = TextEditingController();
//   final _houseNumberController = TextEditingController();
//   final _countryBirthController = TextEditingController();
//   final _professionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('jeu'),
//     );
//   }
// }
