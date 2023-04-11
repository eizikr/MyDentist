import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

import '../our_widgets/global.dart';

class Assistant {
  late final String name;
  late final double salary;

  Assistant({
    required this.name,
    required this.salary,
  });

  static Future<List<String>> getNames() async {
    List<String> list = <String>[];

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Assistants');

    QuerySnapshot snapshot = await collectionRef.get();

    for (var doc in snapshot.docs) {
      String name = doc.get('name');
      list.add(name);
    }

    return list;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'salary': salary,
      };

  static Assistant fromJson(Map<String, dynamic> json) => Assistant(
        name: json['name'],
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
          list.add(Assistant(name: data["name"], salary: data["salary"]));
        }
      },
    );
    return list;
  }
}

Future createAssistant(String name, double salary) async {
  Assistant instance = Assistant(name: name, salary: salary);
  final DB db = Get.find();
  final assistentDocuments = db.assistants;

  var query = assistentDocuments.where('name', isEqualTo: name);

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

Future deleteAssistant(String name) async {
  final DB db = Get.find();
  final assistentDocuments = db.assistants;

  var query = assistentDocuments.where('name', isEqualTo: name);

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
