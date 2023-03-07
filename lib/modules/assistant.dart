import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class Assistant {
  late final String name;
  late final double salary;

  Assistant({
    required this.name,
    required this.salary,
  });

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
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("Assistants");

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
  final assistentDocuments =
      FirebaseFirestore.instance.collection('Assistants');

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
  final assistentDocuments =
      FirebaseFirestore.instance.collection('Assistants');
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
