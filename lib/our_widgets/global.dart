import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:my_dentist/modules/assistant.dart';
import 'package:my_dentist/modules/treatments.dart';

class DB {
  late final CollectionReference assistants;
  late final CollectionReference patients;
  late final CollectionReference treatments;
  late final CollectionReference treatmentTypes;
  late final CollectionReference meetings;
  late final CollectionReference doctors;
  late List<String> treatmentTypeNames;
  late List<String> treatmentTypeCodes;
  late List<String> assistentNames;
  late Map<String, Map<String, dynamic>> treatmentTypesDictionary;

  DB() {
    assistants = FirebaseFirestore.instance.collection('Assistants');
    patients = FirebaseFirestore.instance.collection('Patients');
    treatments = FirebaseFirestore.instance.collection('Treatments');
    treatmentTypes = FirebaseFirestore.instance.collection('Treatment Types');
    meetings = FirebaseFirestore.instance.collection('Meetings');
    doctors = FirebaseFirestore.instance.collection('Doctors');
    treatmentTypesDictionary = {};
  }

  Future<void> createTreatmentDictionary() async {
    // Create treatment dictionary { 'code' : treatment_instance }
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Treatment Types').get();

      for (DocumentSnapshot doc in snapshot.docs) {
        String treatmentCode = doc.get('code');
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        treatmentTypesDictionary[treatmentCode] = data;
      }
    } catch (e) {
      print('Global error! $e');
    }
  }

  Future<void> setAssistantNames() async {
    assistentNames = await Assistant.getNames();
  }

  List<String> getAssistantNames() {
    return assistentNames;
  }

  Future<void> setTreatmentTypeCodes() async {
    treatmentTypeCodes = await TreatmentType.getCodes();
  }

  List<String> getTreatmentTypeCodes() {
    return treatmentTypeCodes;
  }

  Future<void> setTreatmentTypeNames() async {
    treatmentTypeNames = await TreatmentType.getNames();
  }

  List<String> getTreatmentTypeNames() {
    return treatmentTypeNames;
  }
}

class EncryptData {
  late final Key key;
  late final IV _iv;
  late final Encrypter encrypter;

  EncryptData() {
    key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
    _iv = IV.fromLength(16);
    encrypter = Encrypter(AES(key));
  }

  String encryptAES(plainText) {
    if (plainText == '') return '';
    Encrypted encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptAES(plainText) {
    String decrypted;
    try {
      decrypted = encrypter.decrypt64(plainText, iv: _iv);
    } catch (e) {
      decrypted = plainText;
    }
    return decrypted;
  }
}
