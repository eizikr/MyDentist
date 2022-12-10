import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

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
        padding: const EdgeInsets.all(25),
        child: const CreatePatientStepper(),
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
  // Private information
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
  // Comunication
  final _homePhoneController = TextEditingController();
  final _email1Controller = TextEditingController();
  final _email2Controller = TextEditingController();
  final _insuranceCompanyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _faxController = TextEditingController();
  final _HMOController = TextEditingController();
  final _treatingDoctorController = TextEditingController();
  // Status
  final _statusController = TextEditingController();
  final _RemarksController = TextEditingController();

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
                      title: const Text('Comunication'),
                      content: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Phone",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Home Phone",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Email 1",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Email 2",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Insurance Company",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Fax",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "HMO",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Treating Doctor",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: const Text('Status'),
                      content: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Status",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: const InputDecoration(
                              labelText: "Remarks",
                              icon: Icon(Icons.circle_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {},
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

  Future CreatePatient() async {
    final docUser = FirebaseFirestore.instance
        .collection("Patients")
        .doc(_idController.text);
    final patient = Patient(
      id: docUser.id,
      creationDate: _creationDateController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      fathersName: _fathersNameController.text,
      image: _imageController.text,
      city: _cityController.text,
      address: _addressController.text,
      postalCode: _postalCodeController.text,
      houseNumber: _houseNumberController.text,
      countryBirth: _countryBirthController.text,
      profession: _professionController.text,
    );
    final json = patient.toJson();
    await docUser.set(json);
  }
}

class Patient {
  String id;
  final String creationDate;
  final String firstName;
  final String lastName;
  final String fathersName;
  final String image;
  final String city;
  final String address;
  final String postalCode;
  final String houseNumber;
  final String countryBirth;
  final String profession;

  Patient({
    this.id = '',
    this.creationDate = 'undefined',
    required this.firstName,
    required this.lastName,
    this.fathersName = 'undefined',
    this.image = 'undefined',
    this.city = 'undefined',
    this.address = 'undefined',
    this.postalCode = 'undefined',
    this.houseNumber = 'undefined',
    this.countryBirth = 'undefined',
    this.profession = 'undefined',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'creationDate': creationDate,
        'first_name': firstName,
        'last_name': lastName,
        'fathers_name': fathersName,
        'image': image,
        'city': city,
        'address': address,
        'postalCode': postalCode,
        'houseNumber': houseNumber,
        'countryBirth': countryBirth,
        'profession': profession,
      };
  static Patient fromJson(Map<String, dynamic> json) => Patient(
        id: json['id'],
        creationDate: json['creationDate'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        fathersName: json['fathers_name'],
        image: json['image'],
        city: json['city'],
        address: json['address'],
        postalCode: json['postalCode'],
        houseNumber: json['houseNumber'],
        countryBirth: json['countryBirth'],
        profession: json['profession'],
      );
}
