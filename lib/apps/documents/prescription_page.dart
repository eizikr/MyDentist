import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/buttons.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class PrescriptionFormPage extends StatefulWidget {
  @override
  _PrescriptionFormPageState createState() => _PrescriptionFormPageState();
}

class _PrescriptionFormPageState extends State<PrescriptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _patientId;
  late String _medication;
  late DateTime _date;
  late String _dosage;
  late String _frequency;
  late String _instructions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          title: 'Prescription Form',
          child: const Text('Prescription Form'),
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
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Patient ID',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the patient ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _patientId = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Medication',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the medication';
                  }
                  return null;
                },
                onSaved: (value) {
                  _medication = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the dosage';
                  }
                  return null;
                },
                onSaved: (value) {
                  _dosage = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the frequency';
                  }
                  return null;
                },
                onSaved: (value) {
                  _frequency = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the instructions';
                  }
                  return null;
                },
                onSaved: (value) {
                  _instructions = value!;
                },
              ),
              const SizedBox(height: 16.0),
              Center(
                child: BasicButton(
                  onClicked: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _date = DateTime.now();
                      _printPrescription();
                    }
                  },
                  text: 'Print',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _printPrescription() {
    // TODO: Implement the printing logic
    print('Patient ID: $_patientId');
    print('Medication: $_medication');
    print('Date: $_date');
    print('Dosage: $_dosage');
    print('Frequency: $_frequency');
    print('Instructions: $_instructions');

    // You can use a library like 'printing' or 'pdf' to generate/print a prescription document
  }
}
