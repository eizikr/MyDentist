import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPatientForm extends StatefulWidget {
  const AddPatientForm({super.key});

  @override
  AddPatientFormState createState() {
    return AddPatientFormState();
  }
}

class AddPatientFormState extends State<AddPatientForm> {
  DateTime today = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  //<controller name>.text will give you the text
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
    return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                'Private information',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
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
              const SizedBox(height: 20),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fathersNameController,
                decoration: const InputDecoration(
                  labelText: "Father's Name",
                  icon: Icon(Icons.circle_outlined),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: "Image",
                  icon: Icon(Icons.circle_outlined),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: "Postal Code",
                  icon: Icon(Icons.circle_outlined),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
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
        ));
  }
}
