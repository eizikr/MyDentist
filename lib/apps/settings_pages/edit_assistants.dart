import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dentist/modules/assistant.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class EditAssistentPage extends StatefulWidget {
  const EditAssistentPage({super.key});

  @override
  State<EditAssistentPage> createState() => _EditAssistentPageState();
}

class _EditAssistentPageState extends State<EditAssistentPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final idController = TextEditingController();
  final salaryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assistants settings',
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (() async {
              await addAssistantDialog(context,
                  title: 'Enter New Assistant Details');
            }),
            tooltip: 'Add Assistant',
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Assistants').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoadingPage(
                loadingText: "Loading assistants list...",
              );
            } else if (snapshot.hasError) {
              return Text('somthing went wrong ${snapshot.error}');
            }
            final assistants = snapshot.data!.docs;

            return ListView.builder(
              itemCount: assistants.length,
              itemBuilder: (context, index) {
                final assistant =
                    assistants[index].data() as Map<String, dynamic>;

                return assistentCard(Assistant.fromJson(assistant));
              },
            );
          },
        ),
      ),
    );
  }

  Widget assistentCard(Assistant assistant) {
    return Center(
      child: Card(
        color: OurSettings.backgroundColors[50],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.manage_accounts_sharp),
              title: Text('${assistant.firstName} ${assistant.lastName}'),
              subtitle: Text('ID:${assistant.id}\nSalary:${assistant.salary}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('EDIT'),
                  onPressed: () async {
                    idController.text = assistant.id;
                    await addAssistantDialog(context,
                        isEdit: true, title: 'Edit Details');
                  },
                ),
                TextButton(
                  child: const Text('DELETE'),
                  onPressed: () {
                    confirmationDialog(
                      context,
                      () {
                        deleteAssistant(assistant.id);
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

  bool isIdValid() {
    return idController.value.text.length == 9;
  }

  Future<void> addAssistantDialog(context,
          {bool isEdit = false, required String title}) =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'First name'),
                    controller: firstNameController,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Enter first name";
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.name,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Last name'),
                    controller: lastNameController,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Enter Last name";
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.name,
                  ),
                  TextFormField(
                    readOnly: isEdit ? true : false,
                    decoration: const InputDecoration(labelText: 'ID'),
                    controller: idController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          9), // Limit the input length programmatically
                    ],
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return isIdValid() ? null : "ID must be 9 character";
                      } else {
                        return "Enter id";
                      }
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Salary'),
                    controller: salaryController,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Enter salary";
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          6), // Limit the input length programmatically
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
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
                        child: const Text('Delete'),
                        onPressed: () => {
                          confirmationDialog(
                            context,
                            () {
                              deleteAssistant(idController.text);
                              Navigator.of(context).pop();
                            },
                          )
                        },
                      )
                    : Container(),
                TextButton(
                  onPressed: () async => submitNewAssistant(context),
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      );

  void submitNewAssistant(BuildContext context) {
    bool isEntyFields = false;
    if (firstNameController.text.isEmpty) {
      errorToast('Please enter first name');
    } else if (lastNameController.text.isEmpty) {
      errorToast('Please enter last name');
    } else if (idController.text.isEmpty) {
      errorToast('Please enter id');
    } else if (salaryController.text.isEmpty) {
      errorToast('Please enter salary');
    } else {
      createAssistant(
        firstNameController.text,
        lastNameController.text,
        idController.text,
        double.parse(salaryController.text),
      );
      isEntyFields = true;
    }
    if (isEntyFields) {
      firstNameController.clear();
      lastNameController.clear();
      idController.clear();
      salaryController.clear();
      Navigator.of(context).pop();
    }
  }
}
