import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dentist/modules/assistant.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class EditAssistentPage extends StatefulWidget {
  const EditAssistentPage({super.key});

  @override
  State<EditAssistentPage> createState() => _EditAssistentPageState();
}

class _EditAssistentPageState extends State<EditAssistentPage> {
  final nameController = TextEditingController();
  final salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Stream<List<Assistant>> readAssistants() => FirebaseFirestore.instance
        .collection('Assistants')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Assistant.fromJson(doc.data()))
            .toList());

    Widget buildAssistent(Assistant assistentInstance) => ListTile(
          leading: IconButton(
            onPressed: () async {
              nameController.text = assistentInstance.name;
              await addAssistantDialog(context,
                  title: "Edit '${assistentInstance.name}' Salary",
                  isEdit: true);
              nameController.clear();
            },
            icon: const Icon(Icons.edit),
          ),
          title: Text(
            "${assistentInstance.name}  -  ${assistentInstance.salary} ₪ \n",
            style: const TextStyle(color: Colors.black),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Assistant',
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
        child: StreamBuilder<List<Assistant>>(
          stream: readAssistants(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('somthing went wrong ${snapshot.error}');
            } else if (snapshot.hasData) {
              final assistents = snapshot.data!;
              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return buildAssistent(assistents[index]);
                },
                itemCount: assistents.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                addAutomaticKeepAlives: true,
              );
            } else {
              return const LoadingPage(loadingText: "Loading assistants...");
            }
          },
        ),
      ),
    );
  }

  Future<void> addAssistantDialog(context,
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
                  decoration: const InputDecoration(labelText: 'Salary'),
                  controller: salaryController,
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
                          deleteAssistant(nameController.text),
                          Navigator.of(context).pop()
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
    if (nameController.text.isEmpty) {
      errorToast('Please enter name');
    } else if (salaryController.text.isEmpty) {
      errorToast('Please enter salary');
    } else {
      createAssistant(
        nameController.text,
        double.parse(salaryController.text),
      );
      isEntyFields = true;
    }
    if (isEntyFields) {
      nameController.clear();
      salaryController.clear();
      Navigator.of(context).pop();
    }
  }
}
