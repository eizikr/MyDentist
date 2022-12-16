import 'package:cloud_firestore/cloud_firestore.dart';

class TreatmentType {
  late final String name;
  late final double price;

  TreatmentType({
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
      };

  static TreatmentType fromJson(Map<String, dynamic> json) => TreatmentType(
        name: json['name'],
        price: json['price'],
      );

  static Future<List<TreatmentType>> readTreatmentTypes() async {
    List<TreatmentType> list = [];
    CollectionReference colRef =
        FirebaseFirestore.instance.collection("Treatment Types");

    colRef.get().then(
      (QuerySnapshot snapshot) {
        for (var docSnapshot in snapshot.docs) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          list.add(TreatmentType(name: data["name"], price: data["price"]));
        }
      },
    );
    return list;
  }
}

Future createTreatmentType(String name, double price) async {
  TreatmentType instance = TreatmentType(name: name, price: price);
  final treatmentsTypeDocuments =
      FirebaseFirestore.instance.collection('Treatment Types');
  var query = treatmentsTypeDocuments.where('name', isEqualTo: name);

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
