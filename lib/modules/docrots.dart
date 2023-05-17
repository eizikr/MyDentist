import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/auth.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class Doctor {
  late final String firstName;
  late final String lastName;
  late final double salary;
  late final String password;
  late final String email;

  Doctor({
    required this.firstName,
    required this.lastName,
    required this.salary,
    required this.password,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'salary': salary,
        'password': password,
        'email': email,
      };

  static Doctor fromJson(Map<String, dynamic> json) => Doctor(
        firstName: json['firstName'],
        lastName: json['lastName'],
        salary: json['salary'],
        password: json['password'],
        email: json['email'],
      );
}

Future createDoctor({
  required String firstName,
  required String lastName,
  required double salary,
  required String password,
  required String email,
}) async {
  Doctor instance = Doctor(
      firstName: capitalizeFirstCharacter(firstName),
      lastName: capitalizeFirstCharacter(lastName),
      salary: salary,
      email: email,
      password: password);
  final DB db = Get.find();
  final doctorDocuments = db.doctors;

  var query = doctorDocuments.where('email', isEqualTo: email);

  query.get().then(
    (snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        errorToast('This email is already in use');
        // snapshot.docs[0].reference.update(instance.toJson());
      } else {
        try {
          UserCredential userCredential =
              await Auth().signUp(email: email, password: password);
          String userId = userCredential.user!.uid;
          userCredential.user!.updateDisplayName('Dr $lastName');
          doctorDocuments.doc(userId).set(instance.toJson());
          // print('Registration success');
        } catch (error) {
          //  print('Registration failed. Error: $error');
        }
      }
    },
  );
}

Future deleteDoctor(String email) async {
  final DB db = Get.find();
  final doctorDocuments = db.doctors;

  var query = doctorDocuments.where('email', isEqualTo: email);
  query.get().then(
    (snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // snapshot.docs[0].id

        snapshot.docs[0].reference.delete();
      } else {
        errorToast('ID not found');
      }
    },
  );
}
