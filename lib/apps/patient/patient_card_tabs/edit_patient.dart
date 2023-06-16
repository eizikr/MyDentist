import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:flutter/services.dart';

class EditPatientInfo extends StatelessWidget {
  final String patientID;
  final DateTime today = DateTime.now();
  final EncryptData crypto = Get.find();

  EditPatientInfo({super.key, required this.patientID});

  Widget textFormField({
    required String title,
    required String field,
    required CollectionReference patient,
    required TextEditingController controller,
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
      ),
      onChanged: (value) {
        if (controller.text != '') {
          patient
              .doc(patientID)
              .update({field: crypto.encryptAES(controller.text)});
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
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final fathersNameController = TextEditingController();

    final cityController = TextEditingController();
    final addressController = TextEditingController();
    final postalCodeController = TextEditingController();
    final houseNumberController = TextEditingController();
    final countryBirthController = TextEditingController();
    final professionController = TextEditingController();
    // Comunication
    final homePhoneController = TextEditingController();
    final email1Controller = TextEditingController();
    final email2Controller = TextEditingController();
    final insuranceCompanyController = TextEditingController();
    final phoneController = TextEditingController();
    final faxController = TextEditingController();
    final hmoController = TextEditingController();
    final treatingDoctorController = TextEditingController();
    // Status
    final statusController = TextEditingController();
    final remarksController = TextEditingController();
    return FutureBuilder<DocumentSnapshot>(
        future: patient.doc(patientID).get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(children: [
                    const SizedBox(height: 10),
                    textFormField(
                      title:
                          "First name: ${crypto.decryptAES(data['first_name'])}",
                      controller: firstNameController,
                      patient: patient,
                      field: 'first_name',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title:
                          "Last name: ${crypto.decryptAES(data['last_name'])}",
                      controller: lastNameController,
                      patient: patient,
                      field: 'last_name',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title: "City: ${crypto.decryptAES(data['city'])}",
                      controller: cityController,
                      patient: patient,
                      field: 'city',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title: "Address: ${crypto.decryptAES(data['address'])}",
                      controller: addressController,
                      patient: patient,
                      field: 'address',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                        title:
                            "House Number: ${crypto.decryptAES(data['houseNumber'])}",
                        controller: houseNumberController,
                        patient: patient,
                        field: 'houseNumber',
                        numerical: true),
                    const SizedBox(height: 10),
                    textFormField(
                      title:
                          "Country of Birth: ${crypto.decryptAES(data['countryBirth'])}",
                      controller: countryBirthController,
                      patient: patient,
                      field: 'countryBirth',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title:
                          "Postal Code: ${crypto.decryptAES(data['postalCode'])}",
                      controller: postalCodeController,
                      patient: patient,
                      field: 'postalCode',
                      numerical: true,
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title:
                          "Father's Name: ${crypto.decryptAES(data['fathers_name'])}",
                      controller: fathersNameController,
                      patient: patient,
                      field: 'fathers_name',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title:
                          "Profession: ${crypto.decryptAES(data['profession'])}",
                      controller: professionController,
                      patient: patient,
                      field: 'profession',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      controller: phoneController,
                      title:
                          'Phone number: ${crypto.decryptAES(data['phone'])}',
                      patient: patient,
                      field: 'phone',
                      numerical: true,
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title:
                          'Treating Doctor: ${crypto.decryptAES(data['treating_docrot'])}',
                      controller: treatingDoctorController,
                      patient: patient,
                      field: 'treating_docrot',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title:
                          'Home Phone: ${crypto.decryptAES(data['home_phone'])}',
                      controller: homePhoneController,
                      patient: patient,
                      field: 'home_phone',
                      numerical: true,
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title: 'Email 1: ${crypto.decryptAES(data['email1'])}',
                      controller: email1Controller,
                      patient: patient,
                      field: 'email1',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title: 'Email 2: ${crypto.decryptAES(data['email2'])}',
                      controller: email2Controller,
                      patient: patient,
                      field: 'email2',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title:
                          'Insurance Company: ${crypto.decryptAES(data['inisurance_company'])}',
                      controller: insuranceCompanyController,
                      patient: patient,
                      field: 'inisurance_company',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title: 'Fax: ${crypto.decryptAES(data['fax'])}',
                      controller: faxController,
                      numerical: true,
                      patient: patient,
                      field: 'fax',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title: 'HMO: ${crypto.decryptAES(data['HMO'])}',
                      controller: hmoController,
                      patient: patient,
                      field: 'HMO',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title: 'Status: ${crypto.decryptAES(data['status'])}',
                      controller: statusController,
                      patient: patient,
                      field: 'status',
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      title: 'Remarks: ${crypto.decryptAES(data['remarks'])}',
                      controller: remarksController,
                      patient: patient,
                      field: 'remarks',
                    ),
                  ]),
                ),
              ),
            );
          }
          return loadingCircule('Loading status...');
        })));
  }
}
