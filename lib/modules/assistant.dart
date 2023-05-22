import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

import '../our_widgets/global.dart';

class Assistant {
  late final String firstName;
  late final String lastName;
  late final String id;
  late final double salary;

  Assistant({
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.salary,
  });

  static Future<List<String>> getNames() async {
    List<String> list = <String>[];

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Assistants');

    QuerySnapshot snapshot = await collectionRef.get();

    for (var doc in snapshot.docs) {
      String firstName = doc.get('firstName');
      String lastName = doc.get('lastName');

      list.add('$firstName $lastName');
    }

    return list;
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'id': id,
        'salary': salary,
      };

  static Assistant fromJson(Map<String, dynamic> json) => Assistant(
        firstName: json['firstName'],
        lastName: json['lastName'],
        id: json['id'],
        salary: json['salary'],
      );

  static Future<List<Assistant>> readAssistants() async {
    List<Assistant> list = [];
    final DB db = Get.find();
    CollectionReference colRef = db.assistants;

    colRef.get().then(
      (QuerySnapshot snapshot) {
        for (var docSnapshot in snapshot.docs) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          list.add(
            Assistant(
              firstName: data["firstName"],
              lastName: data["lastName"],
              id: data["id"],
              salary: data["salary"],
            ),
          );
        }
      },
    );
    return list;
  }
}

Future createAssistant(
  String firstName,
  String lastName,
  String id,
  double salary,
) async {
  Assistant instance = Assistant(
    firstName: capitalizeFirstCharacter(firstName),
    lastName: capitalizeFirstCharacter(lastName),
    id: id,
    salary: salary,
  );
  final DB db = Get.find();
  final assistentDocuments = db.assistants;

  var query = assistentDocuments.where('id', isEqualTo: id);

  query.get().then(
    (snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs[0].reference.update(instance.toJson());
      } else {
        assistentDocuments.add(instance.toJson());
      }
    },
  );
}

Future deleteAssistant(String id) async {
  final DB db = Get.find();
  final assistentDocuments = db.assistants;

  var query = assistentDocuments.where('id', isEqualTo: id);

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
