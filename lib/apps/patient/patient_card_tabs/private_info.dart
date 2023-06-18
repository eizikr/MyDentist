import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/apps/payment/payment_dialog.dart';
import 'package:my_dentist/our_widgets/buttons.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class PatientPrivateInfo extends StatefulWidget {
  final String patientID;

  const PatientPrivateInfo({Key? key, required this.patientID})
      : super(key: key);

  @override
  State<PatientPrivateInfo> createState() => _PatientPrivateInfoState();
}

class _PatientPrivateInfoState extends State<PatientPrivateInfo> {
  final EncryptData crypto = Get.find();
  final DB db = Get.find();
  late Map<String, dynamic> data;
  @override
  void initState() {
    super.initState();
  }

  void updata() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference patient = db.patients;

    return FutureBuilder<DocumentSnapshot>(
        future: patient.doc(widget.patientID).get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            data = snapshot.data!.data() as Map<String, dynamic>;
            return infoScreen(data);
          }

          return const LoadingPage(loadingText: 'Loading Patient Info');
        })));
  }

  Widget infoScreen(Map<String, dynamic> patientData) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    print(width);
    return SingleChildScrollView(
      child: Container(
        decoration: ourBoxDecoration(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 16),
          child: Column(
            children: [
              const SizedBox(height: 15),
              // GestureDetector(
              //   child: Container(
              //     width: 120,
              //     height: 120,
              //     decoration: BoxDecoration(
              //       color: Colors.grey,
              //       borderRadius: BorderRadius.circular(75),
              //     ),
              //     child: const Icon(
              //       Icons.camera_alt,
              //       size: 50,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              // BasicButton(
              //   text: 'Upload image',
              //   onClicked: () {},
              // ),
              // const SizedBox(height: 75),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${crypto.decryptAES(patientData['first_name'])} ${crypto.decryptAES(patientData['last_name'])}',
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
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
                  'Address: ${crypto.decryptAES(patientData['address'])}/${crypto.decryptAES(patientData['houseNumber'])}, ${crypto.decryptAES(patientData['city'])}',
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
                    'Total payment: ${patientData['paymentRequired']}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  BasicButton(
                      text: 'Pay now',
                      onClicked: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => PaymentDialog(
                            crypto.decryptAES(patientData['id']),
                          ),
                        );
                        updata();
                      }),
                  const Spacer(flex: 3),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class PatientImageContainer extends StatelessWidget {
//   final String patientID;

//   const PatientImageContainer({required this.patientID});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         final ImagePicker picker = ImagePicker();
//         XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);
//         if (imageFile != null) {
//           File image = File(imageFile.path);
//           String? imageUrl = await uploadImage(image);
//           if (imageUrl != null) {
//             await updatePatientImage(patientID, imageUrl);
//           }
//         }
//       },
//       child: FutureBuilder<String?>(
//         future: getPatientImage(patientID),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(75),
//               ),
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(75),
//               ),
//               child: const Icon(
//                 Icons.error,
//                 size: 50,
//                 color: Colors.white,
//               ),
//             );
//           } else {
//             final imageUrl = snapshot.data;
//             if (imageUrl != null) {
//               return Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: NetworkImage(imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             } else {
//               return Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.grey,
//                   borderRadius: BorderRadius.circular(75),
//                 ),
//                 child: const Icon(
//                   Icons.camera_alt,
//                   size: 50,
//                   color: Colors.white,
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }
