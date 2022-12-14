import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/services.dart';
import '../modules/patient.dart';

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
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  // Private information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fathersNameController = TextEditingController();
  final _idController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _countryBirthController = TextEditingController();
  final _professionController = TextEditingController();
  String _dateOfBirth = 'undefined';
  // Comunication
  final _homePhoneController = TextEditingController();
  final _email1Controller = TextEditingController();
  final _email2Controller = TextEditingController();
  final _insuranceCompanyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _faxController = TextEditingController();
  final _hmoController = TextEditingController();
  final _treatingDoctorController = TextEditingController();
  // Status
  final _statusController = TextEditingController();
  final _remarksController = TextEditingController();

  Widget _entryField({
    required String title,
    required TextEditingController controller,
    required bool isRequired,
    bool numerical = false,
  }) {
    return TextFormField(
      keyboardType: numerical ? TextInputType.number : null,
      inputFormatters: numerical
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        icon: isRequired
            ? const Icon(Icons.info_outlined)
            : const Icon(Icons.circle_outlined),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {},
      validator: (val) {
        if (isRequired && (val == null || val.isEmpty)) {
          return "Please enter $title!${numerical ? ' (Only Digits)' : ''}";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

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
                  onStepContinue: () {
                    final isLastStep = _currentStep < 2 ? false : true;
                    if (isLastStep) {
                      createPatient();
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        if (_formKeys[_currentStep].currentState!.validate()) {
                          _currentStep++;
                        }
                      });
                    }
                  },
                  onStepCancel: () {
                    _currentStep > 0
                        ? setState(() => _currentStep -= 1)
                        : Navigator.pop(context);
                  },
                  steps: <Step>[
                    Step(
                      title: const Text('Patient private information'),
                      content: Form(
                        key: _formKeys[0],
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Text(
                                'Date of creation: ${today.day}.${today.month}.${today.year}'),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "First name",
                              controller: _firstNameController,
                              isRequired: true,
                            ),
                            // TextFormField(
                            //   controller: _firstNameController,
                            //   decoration: const InputDecoration(
                            //     labelText: "First name",
                            //     icon: Icon(Icons.info_outlined),
                            //     border: OutlineInputBorder(),
                            //   ),
                            //   onChanged: (value) {},
                            //   validator: (val) {
                            //     if (val == null || val.isEmpty) {
                            //       return " cannot be empty";
                            //     }
                            //     return null;
                            //   },
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            // ),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "Last name",
                              controller: _lastNameController,
                              isRequired: true,
                            ),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "Father's Name",
                              controller: _fathersNameController,
                              isRequired: false,
                            ),
                            const SizedBox(height: 10),
                            _entryField(
                                title: "ID",
                                controller: _idController,
                                isRequired: true,
                                numerical: true),
                            const SizedBox(height: 10),
                            DateTimeFormField(
                              onSaved: (val) =>
                                  setState(() => _dateOfBirth = val.toString()),
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
                                _dateOfBirth = value.toString();
                              },
                            ),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "City",
                              controller: _cityController,
                              isRequired: true,
                            ),

                            const SizedBox(height: 10),
                            _entryField(
                              title: "Address",
                              controller: _addressController,
                              isRequired: true,
                            ),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "Postal Code",
                              controller: _postalCodeController,
                              isRequired: false,
                              numerical: true,
                            ),

                            const SizedBox(height: 10),
                            _entryField(
                                title: "House Number",
                                controller: _houseNumberController,
                                isRequired: true,
                                numerical: true),

                            const SizedBox(height: 10),
                            _entryField(
                              title: "Country of Birth",
                              controller: _countryBirthController,
                              isRequired: true,
                            ),

                            const SizedBox(height: 10),
                            _entryField(
                              title: "Profession",
                              controller: _professionController,
                              isRequired: false,
                            ),
                          ],
                        ),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: const Text('Comunication'),
                      content: Form(
                        key: _formKeys[1],
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            _entryField(
                                title: "Phone",
                                controller: _phoneController,
                                isRequired: true,
                                numerical: true),
                            const SizedBox(height: 10),
                            _entryField(
                                title: "Home Phone",
                                controller: _homePhoneController,
                                isRequired: false,
                                numerical: true),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "Email 1",
                              controller: _email1Controller,
                              isRequired: false,
                            ),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "Email 2",
                              controller: _email2Controller,
                              isRequired: false,
                            ),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "Insurance Company",
                              controller: _insuranceCompanyController,
                              isRequired: false,
                            ),
                            const SizedBox(height: 10),
                            _entryField(
                                title: "Fax",
                                controller: _faxController,
                                isRequired: false,
                                numerical: true),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "HMO",
                              controller: _hmoController,
                              isRequired: false,
                            ),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "Treating Doctor",
                              controller: _treatingDoctorController,
                              isRequired: true,
                            ),
                          ],
                        ),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: const Text('Status'),
                      content: Form(
                        key: _formKeys[2],
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10),
                            _entryField(
                              title: "Status",
                              controller: _statusController,
                              isRequired: false,
                            ),
                            const SizedBox(height: 10),
                            _entryField(
                              title: "Remarks",
                              controller: _remarksController,
                              isRequired: false,
                            ),
                          ],
                        ),
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

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Future createPatient() async {
    final docUser = FirebaseFirestore.instance
        .collection("Patients")
        .doc(_idController.text);
    final patient = Patient(
      id: docUser.id,
      creationDate: '${today.day}.${today.month}.${today.year}',
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      fathersName: _fathersNameController.text,
      city: _cityController.text,
      address: _addressController.text,
      postalCode: _postalCodeController.text,
      houseNumber: _houseNumberController.text,
      countryBirth: _countryBirthController.text,
      profession: _professionController.text,
      dateOfBirth: _dateOfBirth,
      homePhone: _homePhoneController.text,
      email1: _email1Controller.text,
      email2: _email2Controller.text,
      insuranceCompany: _insuranceCompanyController.text,
      phone: _phoneController.text,
      fax: _faxController.text,
      hmo: _hmoController.text,
      treatingDoctor: _treatingDoctorController.text,
      status: _statusController.text,
      remarks: _remarksController.text,
    );
    final json = patient.toJson();
    await docUser.set(json);
  }
}
