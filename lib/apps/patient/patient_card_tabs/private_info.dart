import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class PatientPrivateInfo extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const PatientPrivateInfo({Key? key, required this.patientData})
      : super(key: key);

  @override
  Widget build(BuildContext context) => privateInfoScreen(patientData);
}

Widget privateInfoScreen(Map<String, dynamic> data) {
  EncryptData crypto = Get.find();

  return SingleChildScrollView(
    child: Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Handle image upload logic here
            // You can use a package like image_picker to implement this functionality
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(75),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${crypto.decryptAES(data['first_name'])} ${crypto.decryptAES(data['last_name'])}',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'ID: ${crypto.decryptAES(data['id'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Birth date: ${crypto.decryptAES(data['date_of_birth'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Age: ${crypto.decryptAES(data['age'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 110),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Gender: ${crypto.decryptAES(data['gender'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Height: ${crypto.decryptAES(data['height'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Weight: ${crypto.decryptAES(data['weight'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Smoker: ${crypto.decryptAES(data['smoker'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Children: ${crypto.decryptAES(data['children'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Address: ${crypto.decryptAES(data['address'])}/${crypto.decryptAES(data['houseNumber'])}, ${crypto.decryptAES(data['city'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: data['postalCode'] != ''
                  ? Text(
                      'Postal Code: ${crypto.decryptAES(data['postalCode'])}',
                      style: const TextStyle(fontSize: 20),
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Country of Birth: ${crypto.decryptAES(data['countryBirth'])}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: data['fathers_name'] != ''
                  ? Text(
                      'Father\'s name: ${crypto.decryptAES(data['fathers_name'])}',
                      style: const TextStyle(fontSize: 20),
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: data['profession'] != ''
                  ? Text(
                      'Profession: ${crypto.decryptAES(data['profession'])}',
                      style: const TextStyle(fontSize: 20),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ],
    ),
  );
}
