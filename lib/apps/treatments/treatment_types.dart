import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class TreatmentTypesPage extends StatefulWidget {
  const TreatmentTypesPage({super.key});

  @override
  State<TreatmentTypesPage> createState() => _TreatmentTypesPageState();
}

class _TreatmentTypesPageState extends State<TreatmentTypesPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Stream<List<TreatmentType>> readPatients() => FirebaseFirestore.instance
        .collection('Treatment Types')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TreatmentType.fromJson(doc.data()))
            .toList());

    Widget buildPatient(TreatmentType treatmentInstance) => ListTile(
          leading: IconButton(
            onPressed: () async {
              nameController.text = treatmentInstance.name;
              await addTreatmentDialog(context,
                  title: "Edit '${treatmentInstance.name}' Treatment cost",
                  isEdit: true);
              nameController.clear();
            },
            icon: const Icon(Icons.edit),
          ),
          title: Text(
            "${treatmentInstance.name}  -  ${treatmentInstance.price} ₪ \n",
            style: const TextStyle(color: Colors.black),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Treatment Types',
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (() async {
              await addTreatmentDialog(context,
                  title: 'Enter New Treatment Details');
            }),
            tooltip: 'Add Treatment Type',
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: StreamBuilder<List<TreatmentType>>(
          stream: readPatients(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('somthing went wrong ${snapshot.error}');
            } else if (snapshot.hasData) {
              final patients = snapshot.data!;
              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return buildPatient(patients[index]);
                },
                itemCount: patients.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                addAutomaticKeepAlives: true,
              );
            } else {
              return const LoadingPage(loadingText: "Loading treatments...");
            }
          },
        ),
      ),
    );
  }

  Future<void> addTreatmentDialog(context,
          {bool isEdit = false, required String title}) =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  readOnly: isEdit ? true : false,
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: nameController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  controller: priceController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text('Cancle'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                isEdit
                    ? TextButton(
                        child: const Text('delete'),
                        onPressed: () => {
                          deleteTreatmentTyoe(nameController.text),
                          Navigator.of(context).pop()
                        },
                      )
                    : Container(),
                TextButton(
                  onPressed: () async => submitNewTreatment(context),
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      );

  void submitNewTreatment(BuildContext context) {
    bool isEntyFields = false;
    if (nameController.text.isEmpty) {
      errorToast('Please enter a name');
    } else if (priceController.text.isEmpty) {
      errorToast('Please enter a price');
    } else {
      createTreatmentType(
        nameController.text,
        double.parse(priceController.text),
      );
      isEntyFields = true;
    }
    if (isEntyFields) {
      nameController.clear();
      priceController.clear();
      Navigator.of(context).pop();
    }
  }
}
