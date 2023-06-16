
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/modules/docrots.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController password1Controller;
  late TextEditingController password2Controller;
  late TextEditingController emailController;
  late TextEditingController salaryController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    password1Controller = TextEditingController();
    password2Controller = TextEditingController();
    emailController = TextEditingController();
    salaryController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    password1Controller.dispose();
    password2Controller.dispose();
    emailController.dispose();
    salaryController.dispose();

    super.dispose();
  }

  bool isPasswordVerify() {
    String password_1 = password1Controller.value.text;
    String password_2 = password2Controller.value.text;
    return password_1.compareTo(password_2) == 0;
  }

  Future<void> createDoctorDialog(BuildContext context,
      {bool isEdit = false, required String title}) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: firstNameController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter first name";
                        },
                        autofocus: true,
                        decoration:
                            const InputDecoration(hintText: "First name"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        keyboardType: TextInputType.name,
                      ),
                      TextFormField(
                        controller: lastNameController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter last name";
                        },
                        decoration:
                            const InputDecoration(hintText: "Last name"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        keyboardType: TextInputType.name,
                      ),
                      TextFormField(
                        readOnly: isEdit ? true : false,
                        controller: emailController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter email";
                        },
                        decoration: const InputDecoration(hintText: "Email"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        controller: password1Controller,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            String validationMSG =
                                isPasswordValid(password1Controller.text);
                            if (validationMSG.compareTo('valid') == 0) {
                              return null;
                            }
                            return validationMSG;
                          }
                          return "Enter password";
                        },
                        decoration: const InputDecoration(hintText: "Password"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                      TextFormField(
                        controller: password2Controller,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return isPasswordVerify()
                                ? null
                                : "Passwords are not the same";
                          } else {
                            return "Enter verified password";
                          }
                        },
                        decoration:
                            const InputDecoration(hintText: "Verify password"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                      TextFormField(
                        controller: salaryController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter salary";
                        },
                        decoration: const InputDecoration(hintText: "Salary"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  )),
              title: Text(title),
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
                                  deleteDoctor(emailController.text);
                                  Navigator.of(context).pop();
                                },
                              )
                            },
                          )
                        : Container(),
                    TextButton(
                      child: const Text('Register'),
                      onPressed: () {
                        submit();
                      },
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      createDoctor(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: password1Controller.text,
        salary: double.parse(salaryController.text),
      );
      successToast('Docter registered');
    }
  }

  void clearControllers() {
    firstNameController.clear();
    lastNameController.clear();
    password1Controller.clear();
    password2Controller.clear();
    emailController.clear();
    salaryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor users settings',
        ),
        centerTitle: true,
        backgroundColor: OurSettings.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (() async {
              clearControllers();
              await createDoctorDialog(context, title: "Create doctor user");
            }),
            tooltip: 'Create new doctor user',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Doctors').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoadingPage(
                loadingText: "Loading doctors list...",
              );
            } else if (snapshot.hasError) {
              return Text('somthing went wrong ${snapshot.error}');
            }
            final doctors = snapshot.data!.docs;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index].data() as Map<String, dynamic>;

                return doctorCard(Doctor.fromJson(doctor));
              },
            );
          },
        ),
      ),
    );
  }

  Widget doctorCard(Doctor doctor) {
    String fullName = '${doctor.firstName} ${doctor.lastName}';
    String email = doctor.email;
    String salary = '${doctor.salary}';

    return Center(
      child: Card(
        color: OurSettings.mainColors[50],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.manage_accounts_sharp),
              title: Text('Doctor ${doctor.lastName}'),
              subtitle:
                  Text('Full name: $fullName\nEmail: $email\nSalary: $salary'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('EDIT'),
                  onPressed: () async {
                    clearControllers();
                    emailController.text = doctor.email;
                    await createDoctorDialog(context,
                        isEdit: true, title: 'Edit Details');
                  },
                ),
                TextButton(
                  child: const Text('DELETE'),
                  onPressed: () {
                    confirmationDialog(context, () {
                      deleteDoctor(email);
                      Navigator.of(context).pop();
                    });
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
}
