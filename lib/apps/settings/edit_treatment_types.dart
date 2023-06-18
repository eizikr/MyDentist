import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class EditTreatmentTypesPage extends StatefulWidget {
  const EditTreatmentTypesPage({super.key});

  @override
  State<EditTreatmentTypesPage> createState() => _EditTreatmentTypesPageState();
}

class _EditTreatmentTypesPageState extends State<EditTreatmentTypesPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController detailsController;
  late TextEditingController codeController;
  late final DB db;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    priceController = TextEditingController();
    detailsController = TextEditingController();
    codeController = TextEditingController();

    db = Get.find();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    detailsController.dispose();
    codeController.dispose();

    super.dispose();
  }

  void clearControllers() {
    nameController.clear();
    priceController.clear();
    detailsController.clear();
    codeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Treatment Types',
        ),
        centerTitle: true,
        backgroundColor: OurSettings.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (() async {
              clearControllers();
              await createTreatmentTypeDialog(context,
                  title: 'Create New Treatment');
            }),
            tooltip: 'Create new Treatment Type',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Treatment Types')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoadingPage(
                loadingText: "Loading doctors list...",
              );
            } else if (snapshot.hasError) {
              return Text('somthing went wrong ${snapshot.error}');
            }

            final treatmentTypes = snapshot.data!.docs;

            return ListView.builder(
              itemCount: treatmentTypes.length,
              itemBuilder: (context, index) {
                final treatmentType =
                    treatmentTypes[index].data() as Map<String, dynamic>;
                treatmentType['price'] += (0.0);

                return treatmentTypeCard(TreatmentType.fromJson(treatmentType));
              },
            );
          },
        ),
      ),
    );
  }

  Widget treatmentTypeCard(TreatmentType treatmentType) {
    return Center(
      child: Card(
        color: OurSettings.mainColors[50],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.manage_accounts_sharp),
              title: Text(treatmentType.name),
              subtitle: Text(
                  'Info: ${treatmentType.details}\nPrice: ${treatmentType.price}\nCode: ${treatmentType.code}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('EDIT'),
                  onPressed: () async {
                    clearControllers();
                    codeController.text = treatmentType.code;
                    await createTreatmentTypeDialog(
                      context,
                      isEdit: true,
                      title: 'Edit Treatment Type',
                    );
                  },
                ),
                TextButton(
                  child: const Text('DELETE'),
                  onPressed: () {
                    confirmationDialog(
                      context,
                      () {
                        TreatmentType.deleteTreatmentType(treatmentType.code);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createTreatmentTypeDialog(context,
      {bool isEdit = false, required String title}) async {
    return await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: OurSettings.mainColors[100],
          scrollable: true,
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: 'Treatment Name'),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Enter name";
                  },
                ),
                TextFormField(
                  controller: codeController,
                  readOnly: isEdit ? true : false,
                  decoration: const InputDecoration(labelText: 'Code'),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Enter code";
                  },
                ),
                TextFormField(
                  controller: priceController,
                  decoration:
                      const InputDecoration(labelText: 'Treatment Price'),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(8),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Enter price";
                  },
                ),
                TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(labelText: 'Details'),
                  autocorrect: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  keyboardType: TextInputType.multiline,
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
                          confirmationDialog(
                            context,
                            () {
                              TreatmentType.deleteTreatmentType(
                                codeController.text,
                              );

                              Navigator.of(context).pop();
                            },
                          )
                        },
                      )
                    : Container(),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    submit();
                  },
                ),
              ],
            )
          ],
          title: Text(title),
        );
      }),
    );
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      createTreatmentType(
          name: nameController.text,
          price: double.parse(priceController.text),
          details: detailsController.text,
          code: codeController.text);
      Navigator.of(context).pop();

      successToast('Docter registered');
    }
  }
}
