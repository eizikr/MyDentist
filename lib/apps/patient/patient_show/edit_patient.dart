import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:date_field/date_field.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter/services.dart';
import '/modules/patient.dart';

class EditPatientInfo extends StatelessWidget {
  final String patientID;
  final DateTime today = DateTime.now();
  EncryptData crypto = Get.find();

  EditPatientInfo({super.key, required this.patientID});

  Widget _TextFormField({
    required String title,
    required String field,
    required CollectionReference patient,
    required TextEditingController controller,
    bool numerical = false,
  }){
  return TextFormField(
          keyboardType: numerical ? TextInputType.number : null,
            inputFormatters: numerical
                ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                : null,
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
          ),
            onChanged: (value) {
              if (controller.text!=''){
                patient.doc(patientID).update({field: crypto.encryptAES(controller.text)});
              }
            },
            validator: (val) {
              if (val == null || val.isEmpty) {
                return;
              }
              return null;
            },
        );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference patient =
        FirebaseFirestore.instance.collection('Patients');
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fathersNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _smokerController = TextEditingController();  
  final _childrenController = TextEditingController();  
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
  final _hmoController = TextEditingController();
  final _treatingDoctorController = TextEditingController();
  // Status
  final _statusController = TextEditingController();
  final _remarksController = TextEditingController();
    return FutureBuilder<DocumentSnapshot>(
        future: patient.doc(patientID).get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
                    child: Column(children: [
                      // const SizedBox(height: 10),
                      // _TextFormField(
                      //   title: "First name: ${crypto.decryptAES(data['firstName'])}",
                      //   controller: _firstNameController,
                      //   patient: patient,
                      //   field: 'firstName',
                      // ),
                      // const SizedBox(height: 10),
                      // _TextFormField(
                      //   title: "Last name: ${crypto.decryptAES(data['lastName'])}",
                      //   controller: _lastNameController,
                      //   patient: patient,
                      //   field: 'lastName',
                      // ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: "City: ${crypto.decryptAES(data['city'])}",
                        controller: _cityController,
                        patient: patient,
                        field: 'city',
                      ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: "Address: ${crypto.decryptAES(data['address'])}",
                        controller: _addressController,
                        patient: patient,
                        field: 'address',
                      ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: "House Number: ${crypto.decryptAES(data['houseNumber'])}",
                        controller: _houseNumberController,
                        patient: patient,
                        field: 'houseNumber',
                        numerical: true),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: "Country of Birth: ${crypto.decryptAES(data['countryBirth'])}",
                        controller: _countryBirthController,
                        patient: patient,
                        field: 'countryBirth',                      
                      ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: "Postal Code: ${crypto.decryptAES(data['postalCode'])}",
                        controller: _postalCodeController,
                        patient: patient,
                        field: 'postalCode',
                        numerical: true,
                      ),
                      // const SizedBox(height: 10),
                      // _TextFormField(
                      //   title: "Father's Name: ${crypto.decryptAES(data['fathersName'])}",
                      //   controller: _fathersNameController,
                      //   patient: patient,
                      //   field: 'fathersName',
                      // ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: "Profession: ${crypto.decryptAES(data['profession'])}",
                        controller: _professionController,
                        patient: patient,
                        field: 'profession',
                      ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        controller: _phoneController,
                        title: 'Phone number: ${crypto.decryptAES(data['phone'])}',
                        patient: patient,
                        field: 'phone',
                        numerical: true,
                      ),
                      // const SizedBox(height: 10),
                      // _TextFormField(
                      //   title: 'Treating Doctor: ${crypto.decryptAES(data['treatingDoctor'])}',
                      //   controller: _treatingDoctorController,
                      //   patient: patient,
                      //   field: 'treatingDoctor',
                      // ),
                      // const SizedBox(height: 10),
                      // _TextFormField(
                      //   title: 'Home Phone: ${crypto.decryptAES(data['homePhone'])}',
                      //   controller: _homePhoneController,
                      //   patient: patient,
                      //   field: 'homePhone',
                      //   numerical: true,
                      // ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: 'Email 1: ${crypto.decryptAES(data['email1'])}',
                        controller: _email1Controller,
                        patient: patient,
                        field: 'email1',
                        ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: 'Email 2: ${crypto.decryptAES(data['email2'])}',
                        controller: _email2Controller,
                        patient: patient,
                        field: 'email2',                    
                        ),
                      // const SizedBox(height: 10),
                      // _TextFormField(
                      //   title: 'Insurance Company: ${crypto.decryptAES(data['insuranceCompany'])}',
                      //   controller: _insuranceCompanyController,
                      //   patient: patient,
                      //   field: 'insuranceCompany',
                      //   ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: 'Fax: ${crypto.decryptAES(data['fax'])}',
                        controller: _faxController,
                        numerical: true,
                        patient: patient,
                        field: 'fax',
                      ),
                      // const SizedBox(height: 10),
                      // _TextFormField(
                      //   title: 'HMO: ${crypto.decryptAES(data['hmo'])}',
                      //   controller: _hmoController,
                      //   patient: patient,
                      //   field: 'hmo',                    
                      // ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: 'Status: ${crypto.decryptAES(data['status'])}',
                        controller: _statusController,
                        patient: patient,
                        field: 'status',                      
                      ),
                      const SizedBox(height: 10),
                      _TextFormField(
                        title: 'Remarks: ${crypto.decryptAES(data['remarks'])}',
                        controller: _remarksController,
                        patient: patient,
                        field: 'remarks',
                      ),
                    ]),
                );
          }
          return loadingCircule('Loading status...');
        })));
  }
}
