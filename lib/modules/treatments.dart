import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_dentist/modules/patient.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

import '../our_widgets/global.dart';
import 'assistant.dart';

enum Code {
  settings,
  editTreatmentType,
  editAssistents,
  logout,
}

class Treatment {
  late final String toothNumber;
  late final String type;
  late final String patientID;
  late final String treatingDoctor;
  late final bool isDone;
  late final String remarks;
  late final String assistent;
  late final double cost;

  Treatment({
    required this.toothNumber,
    required this.type,
    required this.patientID,
    required this.treatingDoctor,
    required this.assistent,
    this.isDone = false,
    this.remarks = 'No remarks',
    this.cost = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'toothNumber': toothNumber,
        'type': type,
        'patientID': patientID,
        'treatingDoctor': treatingDoctor,
        'assistent': assistent,
        'isDone': isDone,
        'remarks': remarks,
        'cost': cost,
      };

  static Treatment fromJson(Map<String, dynamic> json) => Treatment(
        toothNumber: json['toothNumber'],
        type: json['type'],
        patientID: json['patientID'],
        treatingDoctor: json['treatingDoctor'],
        assistent: json['assistent'],
        isDone: json['isDone'],
        remarks: json['remarks'],
        cost: json['cost'],
      );

  static Future<List<Treatment>> getPatientTreatments(String id) async {
    final DB db = Get.find();
    List<Treatment> list = [];

    CollectionReference colRef = db.treatments.where('id', isEqualTo: id)
        as CollectionReference<Object?>;

    colRef.get().then(
      (QuerySnapshot snapshot) {
        for (var docSnapshot in snapshot.docs) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          list.add(Treatment(
            toothNumber: data["toothNumber"],
            type: data["type"],
            patientID: data['patientID'],
            treatingDoctor: data['treatingDoctor'],
            assistent: data['assistent'],
            isDone: data['isDone'],
            remarks: data['remarks'],
            cost: data['cost'],
          ));
        }
      },
    );
    return list;
  }
}

Future createTreatment(Treatment instance) async {
  final DB db = Get.find();
  final treatmentsDocuments = db.treatments;

  treatmentsDocuments.add(instance.toJson());
}

class TreatmentType {
  late final String name;
  late final double price;
  late final String details;
  late final String code;

  TreatmentType({
    required this.name,
    required this.price,
    required this.details,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'details': details,
        'code': code,
      };

  static TreatmentType fromJson(Map<String, dynamic> json) => TreatmentType(
        name: json['name'],
        price: json['price'],
        details: json['details'],
        code: json['code'],
      );

  static Future<List<String>> getNames() async {
    List<String> list = <String>[];

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Treatment Types');

    QuerySnapshot snapshot = await collectionRef.get();

    for (var doc in snapshot.docs) {
      String name = doc.get('name');
      list.add(name);
    }

    return list;
  }

  static Future<List<TreatmentType>> readTreatmentTypes() async {
    List<TreatmentType> list = [];

    final DB db = Get.find();
    // CollectionReference colRef = db.treatmentTypes;

    db.treatmentTypes.get().then(
      (QuerySnapshot snapshot) {
        for (var docSnapshot in snapshot.docs) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          list.add(TreatmentType(
            name: data["name"],
            price: data["price"],
            details: data['details'],
            code: data['code'],
          ));
        }
      },
    );
    return list;
  }
}

Future createTreatmentType({
  required String name,
  required double price,
  String? details,
  required String code,
}) async {
  TreatmentType instance = TreatmentType(
      name: name, price: price, code: code, details: details ?? '');
  final DB db = Get.find();
  final treatmentsTypeDocuments = db.treatmentTypes;

  var query = treatmentsTypeDocuments.where('code', isEqualTo: code);

  query.get().then(
    (snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs[0].reference.update(instance.toJson());
      } else {
        treatmentsTypeDocuments.add(instance.toJson());
      }
    },
  );
}

Future deleteTreatmentType(String code) async {
  final DB db = Get.find();
  final treatmentsTypeDocuments = db.treatmentTypes;
  var query = treatmentsTypeDocuments.where('code', isEqualTo: code);

  query.get().then(
    (snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs[0].reference.delete();
      } else {
        errorToast('ID not found');
      }
    },
  );
}
