import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';

class PatientPrivateInfo extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const PatientPrivateInfo({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) => privateInfoScreen(patientData);
}

Widget privateInfoScreen(Map<String, dynamic> data) {
  EncryptData crypto = Get.find();

  return SingleChildScrollView(
    child: Column(children: [
      Text(
        'First name: ${crypto.decryptAES(data['first_name'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Last name: ${crypto.decryptAES(data['last_name'])}',
        style: const TextStyle(fontSize: 20),
      ),
      Container(
          child: data['fathers_name'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Father'
                    's name: ${crypto.decryptAES(data['fathers_name'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      const SizedBox(height: 15),
      Text(
        'ID: ${crypto.decryptAES(data['id'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Birth date: ${crypto.decryptAES(data['date_of_birth'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Age: ${crypto.decryptAES(data['age'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Gender: ${crypto.decryptAES(data['gender'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Heigth: ${crypto.decryptAES(data['height'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Weigth: ${crypto.decryptAES(data['weight'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Smoker: ${crypto.decryptAES(data['smoker'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Children: ${crypto.decryptAES(data['children'])}',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 15),
      Text(
        'Address: ${crypto.decryptAES(data['address'])}/${crypto.decryptAES(data['houseNumber'])}, ${crypto.decryptAES(data['city'])}',
        style: const TextStyle(fontSize: 20),
      ),
      Container(
          child: data['postalCode'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Postal Code: ${crypto.decryptAES(data['postalCode'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
      const SizedBox(height: 15),
      Text(
        'Counter of birth: ${crypto.decryptAES(data['countryBirth'])}',
        style: const TextStyle(fontSize: 20),
      ),
      Container(
          child: data['profession'] != ''
              ? Column(children: [
                  const SizedBox(height: 15),
                  Text(
                    'Profession: ${crypto.decryptAES(data['profession'])}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ])
              : null),
    ]),
  );
}
