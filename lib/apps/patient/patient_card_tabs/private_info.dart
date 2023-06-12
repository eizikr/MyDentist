import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/apps/payment/payment_dialog.dart';
import 'package:my_dentist/our_widgets/buttons.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class PatientPrivateInfo extends StatefulWidget {
  final Map<String, dynamic> patientData;

  const PatientPrivateInfo({Key? key, required this.patientData})
      : super(key: key);

  @override
  State<PatientPrivateInfo> createState() => _PatientPrivateInfoState();
}

class _PatientPrivateInfoState extends State<PatientPrivateInfo> {
  late final Map<String, dynamic> patientData;
  late double paymentRequired;
  @override
  void initState() {
    patientData = widget.patientData;
    paymentRequired = patientData['paymentRequired'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EncryptData crypto = Get.find();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
            const SizedBox(height: 75),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${crypto.decryptAES(patientData['first_name'])} ${crypto.decryptAES(patientData['last_name'])}',
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 125),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'ID: ${crypto.decryptAES(patientData['id'])}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Age: ${crypto.decryptAES(patientData['age'])}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Gender: ${crypto.decryptAES(patientData['gender'])}',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Height: ${crypto.decryptAES(patientData['height'])}',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Weight: ${crypto.decryptAES(patientData['weight'])}',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Smoker: ${crypto.decryptAES(patientData['smoker'])}',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Children: ${crypto.decryptAES(patientData['children'])}',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: patientData['postalCode'] != ''
                          ? Text(
                              'Postal Code: ${crypto.decryptAES(patientData['postalCode'])}',
                              style: const TextStyle(fontSize: 17),
                            )
                          : const SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: patientData['fathers_name'] != ''
                          ? Text(
                              'Father\'s name: ${crypto.decryptAES(patientData['fathers_name'])}',
                              style: const TextStyle(fontSize: 17),
                            )
                          : const SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: patientData['profession'] != ''
                          ? Text(
                              'Profession: ${crypto.decryptAES(patientData['profession'])}',
                              style: const TextStyle(fontSize: 17),
                            )
                          : const SizedBox(),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Address: ${crypto.decryptAES(patientData['address'])}/${crypto.decryptAES(widget.patientData['houseNumber'])}, ${crypto.decryptAES(widget.patientData['city'])}',
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Country of Birth: ${crypto.decryptAES(patientData['countryBirth'])}',
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(height: 10),
            Divider(
              height: 10,
              color: Colors.blueGrey[900],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                Text(
                  'Total payment: $paymentRequired',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                BasicButton(
                    text: 'Pay now',
                    onClicked: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => PaymentDialog(
                          crypto.decryptAES(patientData['id']),
                        ),
                      );
                    }),
                const Spacer(flex: 3),
              ],
            )
          ],
        ),
      ),
    );
  }
}
