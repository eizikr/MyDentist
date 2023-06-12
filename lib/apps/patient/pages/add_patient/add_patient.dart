import 'package:my_dentist/apps/patient/pages/add_patient/widgets.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';

import '/modules/patient.dart';

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

  final List<String> _genderOptions = ['Male', 'Female'];
  final List<String> _smokerOptions = ['Yes', 'No'];

  final _genderController = TextEditingController();
  final _smokerController = TextEditingController();

  double _heightValue = 130;
  double _weightValue = 35;
  double _chilrenValue = 0;

  @override
  void initState() {
    _genderController.text = _genderOptions[0];
    _smokerController.text = _smokerOptions[0];
    super.initState();
  }

  Widget _checkBoxField({
    required String title,
    required TextEditingController controller,
    required List<String> options,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: ListTile(
            title: Text(options[0]),
            leading: Radio<String>(
              value: options[0],
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(options[1]),
            leading: Radio<String>(
              value: options[1],
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _childrenSlider() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Children amount: $_chilrenValue (5 is 5 or more)',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              valueIndicatorColor: OurSettings.mainColors[400],
            ),
            child: Slider(
              value: _chilrenValue,
              max: 5,
              divisions: 5,
              label: _chilrenValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _chilrenValue = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _weightSlider() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Weight: $_weightValue',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              valueIndicatorColor: OurSettings.mainColors[400],
            ),
            child: Slider(
              value: _weightValue,
              min: 35,
              max: 160,
              divisions: 25,
              label: _weightValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _weightValue = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _heightSlider() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Height: $_heightValue',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              valueIndicatorColor: OurSettings.mainColors[400],
            ),
            child: Slider(
              value: _heightValue,
              min: 130,
              max: 220,
              divisions: 18,
              label: _heightValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _heightValue = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Future createPatient() async {
    final DB db = Get.find();
    final EncryptData crypto = Get.find();

    final patientDoc = db.patients.doc(_idController.text); //
    final patient = Patient(
      id: crypto.encryptAES(patientDoc.id),
      creationDate:
          crypto.encryptAES('${today.day}.${today.month}.${today.year}'),
      firstName: crypto
          .encryptAES(capitalizeFirstCharacter(_firstNameController.text)),
      lastName:
          crypto.encryptAES(capitalizeFirstCharacter(_lastNameController.text)),
      fathersName: crypto.encryptAES(_fathersNameController.text),
      gender: crypto.encryptAES(_genderController.text),
      height: crypto.encryptAES(_heightValue.toString()),
      weight: crypto.encryptAES(_weightValue.toString()),
      smoker: crypto.encryptAES(_smokerController.text),
      children: crypto.encryptAES(_chilrenValue.toString()),
      city: crypto.encryptAES(_cityController.text),
      address: crypto.encryptAES(_addressController.text),
      postalCode: crypto.encryptAES(_postalCodeController.text),
      houseNumber: crypto.encryptAES(_houseNumberController.text),
      countryBirth: crypto.encryptAES(_countryBirthController.text),
      profession: crypto.encryptAES(_professionController.text),
      dateOfBirth: crypto.encryptAES(_dateOfBirth),
      age: crypto.encryptAES(getAge(_dateOfBirth)),
      homePhone: crypto.encryptAES(_homePhoneController.text),
      email1: crypto.encryptAES(_email1Controller.text),
      email2: crypto.encryptAES(_email2Controller.text),
      insuranceCompany: crypto.encryptAES(_insuranceCompanyController.text),
      phone: crypto.encryptAES(_phoneController.text),
      fax: crypto.encryptAES(_faxController.text),
      hmo: crypto.encryptAES(_hmoController.text),
      treatingDoctor: crypto.encryptAES(_treatingDoctorController.text),
      status: crypto.encryptAES(_statusController.text),
      remarks: crypto.encryptAES(_remarksController.text),
    );
    final json = patient.toJson();
    await patientDoc.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          title: 'Add patient',
          child: const Text('Add patient'),
        ),
        centerTitle: true,
        backgroundColor: OurSettings.appbarColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'Exit',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Container(
          decoration: ourBoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: Theme(
                  data: ThemeData(
                    colorScheme: Theme.of(context)
                        .colorScheme
                        .copyWith(primary: OurSettings.mainColors[500]),
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
                          if (_formKeys[_currentStep]
                              .currentState!
                              .validate()) {
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
                              entryField(
                                title: "First name",
                                controller: _firstNameController,
                                isRequired: true,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Last name",
                                controller: _lastNameController,
                                isRequired: true,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                  title: "ID",
                                  controller: _idController,
                                  isRequired: true,
                                  numerical: true),
                              const SizedBox(height: 10),
                              DateTimeFormField(
                                onSaved: (val) => setState(
                                    () => _dateOfBirth = val.toString()),
                                decoration: const InputDecoration(
                                  errorStyle:
                                      TextStyle(color: Colors.redAccent),
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.info_outlined),
                                  labelText: 'Date of birth',
                                  suffixIcon: Icon(Icons.date_range),
                                ),
                                mode: DateTimeFieldPickerMode.date,
                                autovalidateMode: AutovalidateMode.always,
                                validator: (e) =>
                                    (e?.compareTo(today) ?? 0) == 1
                                        ? 'You cannot enter a future date'
                                        : null,
                                onDateSelected: (DateTime value) {
                                  _dateOfBirth =
                                      value.toString().substring(0, 10);
                                },
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                title: "City",
                                controller: _cityController,
                                isRequired: true,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Address",
                                controller: _addressController,
                                isRequired: true,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                  title: "House Number",
                                  controller: _houseNumberController,
                                  isRequired: true,
                                  numerical: true),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Country of Birth",
                                controller: _countryBirthController,
                                isRequired: true,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Postal Code",
                                controller: _postalCodeController,
                                isRequired: false,
                                numerical: true,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Father's Name",
                                controller: _fathersNameController,
                                isRequired: false,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Profession",
                                controller: _professionController,
                                isRequired: false,
                              ),
                              const SizedBox(height: 10),
                              _checkBoxField(
                                title: "Gender",
                                controller: _genderController,
                                options: _genderOptions,
                              ),
                              const SizedBox(height: 10),
                              _heightSlider(),
                              const SizedBox(height: 10),
                              _weightSlider(),
                              const SizedBox(height: 10),
                              _checkBoxField(
                                title: "Smoker",
                                controller: _smokerController,
                                options: _smokerOptions,
                              ),
                              const SizedBox(height: 10),
                              _childrenSlider(),
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
                              entryField(
                                  title: "Phone",
                                  controller: _phoneController,
                                  isRequired: true,
                                  numerical: true),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Treating Doctor",
                                controller: _treatingDoctorController,
                                isRequired: true,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                  title: "Home Phone",
                                  controller: _homePhoneController,
                                  isRequired: false,
                                  numerical: true),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Email 1",
                                controller: _email1Controller,
                                isRequired: false,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Email 2",
                                controller: _email2Controller,
                                isRequired: false,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                title: "Insurance Company",
                                controller: _insuranceCompanyController,
                                isRequired: false,
                              ),
                              const SizedBox(height: 10),
                              entryField(
                                  title: "Fax",
                                  controller: _faxController,
                                  isRequired: false,
                                  numerical: true),
                              const SizedBox(height: 10),
                              entryField(
                                title: "HMO",
                                controller: _hmoController,
                                isRequired: false,
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
                              entryField(
                                title: "Status",
                                controller: _statusController,
                                isRequired: false,
                              ),
                              const SizedBox(height: 10),
                              entryField(
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
      ),
    );
  }
}
