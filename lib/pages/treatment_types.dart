import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dentist/modules/treatments.dart';

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
    return Scaffold(
      appBar: AppBar(
          title: const Text('Home Page'),
          centerTitle: true,
          backgroundColor: Colors.lightBlue[100],
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: (() async {
                await addTreatmentDialog(context);
              }),
              tooltip: 'Add Treatment Type',
            ),
          ]),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: Container(),
      ),
    );
  }

  Future<List<String>> getButtonList() async {
    List<TreatmentType> treatmentList =
        await TreatmentType.readTreatmentTypes();
    List<String> list = [];
    for (TreatmentType type in treatmentList) {
      list.add('Treatment:${type.name}, Price:${type.price}₪');
    }
    return list;
  }

  Future<void> addTreatmentDialog(context) => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enter New Treatment Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
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
    createTreatmentType(
      nameController.text,
      double.parse(priceController.text),
    );
    nameController.clear();
    priceController.clear();
    Navigator.of(context).pop();
  }
}
