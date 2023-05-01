import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';

class DB {
  late final CollectionReference assistants;
  late final CollectionReference patients;
  late final CollectionReference treatments;
  late final CollectionReference treatmentTypes;
  late final CollectionReference meetings;

  DB() {
    assistants = FirebaseFirestore.instance.collection('Assistants');
    patients = FirebaseFirestore.instance.collection('Patients');
    treatments = FirebaseFirestore.instance.collection('Treatments');
    treatmentTypes = FirebaseFirestore.instance.collection('Treatment Types');
    meetings = FirebaseFirestore.instance.collection('Meetings');
  }

  static Stream<List<String>> treatmentNames() => FirebaseFirestore.instance
      .collection('Treatment Types')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => doc['name'] as String).toList());
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
    if (plainText == '') return '';
    String decrypted = encrypter.decrypt64(plainText, iv: _iv);
    return decrypted;
  }
}
