import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/buttons.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class SickLeaveFormPage extends StatefulWidget {
  @override
  _SickLeaveFormPageState createState() => _SickLeaveFormPageState();
}

class _SickLeaveFormPageState extends State<SickLeaveFormPage> {
  // Define variables to store form values
  String name = '';
  String date = '';
  String reason = '';
  String duration = '';

  // Create a GlobalKey for the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          title: 'Sick Leave Form',
          child: const Text('Sick Leave Form'),
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the date';
                  }
                  return null;
                },
                onSaved: (value) {
                  date = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Duration'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
                onSaved: (value) {
                  duration = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reason'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the reason for sick leave';
                  }
                  return null;
                },
                onSaved: (value) {
                  reason = value!;
                },
              ),
              const SizedBox(height: 16.0),
              BasicButton(
                onClicked: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Process the form data (e.g., send to the server)
                    // TODO: Implement your form submission logic here

                    // Print the form details
                    printFormDetails();
                  }
                },
                text: 'Print',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void printFormDetails() {}
}
