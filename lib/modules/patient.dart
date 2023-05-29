import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/global.dart';

class Patient {
  String id;
  final double paymentRequired;
  final String creationDate;
  final String firstName;
  final String lastName;
  final String fathersName;
  final String city;
  final String address;
  final String postalCode;
  final String houseNumber;
  final String countryBirth;
  final String profession;
  final String dateOfBirth;
  final String age;
  final String gender;
  final String height;
  final String weight;
  final String smoker;
  final String children;

  final String homePhone;
  final String email1;
  final String email2;
  final String insuranceCompany;
  final String phone;
  final String fax;
  final String hmo;
  final String treatingDoctor;

  final String status;
  final String remarks;
  final EncryptData crypto = Get.find();
  Patient({
    this.paymentRequired = 0,
    this.id = '',
    this.creationDate = 'undefined',
    required this.firstName,
    required this.lastName,
    this.fathersName = 'undefined',
    this.city = 'undefined',
    this.address = 'undefined',
    this.postalCode = 'undefined',
    this.houseNumber = 'undefined',
    this.countryBirth = 'undefined',
    this.profession = 'undefined',
    this.dateOfBirth = 'undefined',
    this.age = 'undefined',
    this.gender = 'undefined',
    this.height = 'undefined',
    this.weight = 'undefined',
    this.smoker = 'undefined',
    this.children = 'undefined',
    this.homePhone = 'undefined',
    this.email1 = 'undefined',
    this.email2 = 'undefined',
    this.insuranceCompany = 'undefined',
    this.phone = 'undefined',
    this.fax = 'undefined',
    this.hmo = 'undefined',
    this.treatingDoctor = 'undefined',
    this.status = 'undefined',
    this.remarks = 'undefined',
  });

  Map<String, dynamic> toJson() => {
        'paymentRequired': paymentRequired,
        'id': id,
        'creationDate': creationDate,
        'first_name': firstName,
        'last_name': lastName,
        'fathers_name': fathersName,
        'city': city,
        'address': address,
        'postalCode': postalCode,
        'houseNumber': houseNumber,
        'countryBirth': countryBirth,
        'profession': profession,
        'date_of_birth': dateOfBirth,
        'age': age,
        'gender': gender,
        'height': height,
        'weight': weight,
        'smoker': smoker,
        'children': children,
        'home_phone': homePhone,
        'email1': email1,
        'email2': email2,
        'inisurance_company': insuranceCompany,
        'phone': phone,
        'fax': fax,
        'HMO': hmo,
        'treating_docrot': treatingDoctor,
        'status': status,
        'remarks': remarks
      };

  static Patient fromJson(Map<String, dynamic> json) => Patient(
      paymentRequired: json['paymentRequired'],
      id: json['id'],
      creationDate: json['creationDate'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fathersName: json['fathers_name'],
      city: json['city'],
      address: json['address'],
      postalCode: json['postalCode'],
      houseNumber: json['houseNumber'],
      countryBirth: json['countryBirth'],
      profession: json['profession'],
      dateOfBirth: json['date_of_birth'],
      age: json['age'],
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      smoker: json['smoker'],
      children: json['children'],
      homePhone: json['home_phone'],
      email1: json['email1'],
      email2: json['email2'],
      insuranceCompany: json['inisurance_company'],
      phone: json['phone'],
      fax: json['fax'],
      hmo: json['HMO'],
      treatingDoctor: json['treating_docrot'],
      status: json['status'],
      remarks: json['remarks']);
}

Future<Patient> getPatientFromFirebase(String patientID) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('patients')
      .doc(patientID)
      .get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  return Patient.fromJson(data!);
}

Stream<List<Patient>> readPatients() => FirebaseFirestore.instance
    .collection('Patients')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Patient.fromJson(doc.data())).toList());

Future<bool> checkPatientExists(patientID) async {
  final firestore = FirebaseFirestore.instance;
  bool patientExists = false;
  DocumentReference patientRef =
      firestore.collection('Patients').doc(patientID);
  patientRef.get().then((value) => {
        if (value.exists) {patientExists = true} else {patientExists = false}
      });

  return patientExists;
}

Future<void> addPatientPayment(patientID, double amount) async {
  try {
    CollectionReference ref = FirebaseFirestore.instance.collection('Patients');
    DocumentReference patientRef = ref.doc(patientID);
    DocumentSnapshot snapshot = await patientRef.get();
    if (snapshot.exists) {
      double currentAmount = snapshot.get('paymentRequired');
      double updatedAmount =
          currentAmount + amount < 0 ? 0 : currentAmount + amount;
      await patientRef.update({'paymentRequired': (updatedAmount)});
    }
  } catch (e) {
    e.printError(info: 'Document does not exist.');
  }
}

Future<void> updatePayment(String patientID) async {
  double newAmount = 0;
}
