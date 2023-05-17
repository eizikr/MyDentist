import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/modules/docrots.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController idController;
  late TextEditingController password1Controller;
  late TextEditingController password2Controller;
  late TextEditingController emailController;
  late TextEditingController salaryController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    idController = TextEditingController();
    password1Controller = TextEditingController();
    password2Controller = TextEditingController();
    emailController = TextEditingController();
    salaryController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    idController.dispose();
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

  bool isIdValid() {
    return idController.value.text.length == 9;
  }

  Future<void> showInformationDialog(BuildContext context) async {
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
                          LengthLimitingTextInputFormatter(
                              20), // Limit the input length programmatically
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
                          LengthLimitingTextInputFormatter(
                              20), // Limit the input length programmatically
                        ],
                        keyboardType: TextInputType.name,
                      ),
                      TextFormField(
                        controller: idController,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return isIdValid()
                                ? null
                                : "ID must be 9 character";
                          } else {
                            return "Enter id";
                          }
                        },
                        decoration: const InputDecoration(hintText: "ID"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              9), // Limit the input length programmatically
                        ],
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter email";
                        },
                        decoration: const InputDecoration(hintText: "Email"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              20), // Limit the input length programmatically
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
                        decoration: const InputDecoration(hintText: "password"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              20), // Limit the input length programmatically
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
                          LengthLimitingTextInputFormatter(
                              20), // Limit the input length programmatically
                        ],
                      ),
                      TextFormField(
                        controller: salaryController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter salary";
                        },
                        decoration: const InputDecoration(hintText: "salary"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              6), // Limit the input length programmatically
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  )),
              title: const Text("Create doctor user"),
              actions: <Widget>[
                TextButton(
                  child: const Text('Register'),
                  onPressed: () {
                    submit();
                  },
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
        id: idController.text,
        email: emailController.text,
        password: password1Controller.text,
        salary: double.parse(salaryController.text),
      );
      clearControllers();
      successToast('Docter registered');
    }
  }

  void clearControllers() {
    firstNameController.clear();
    lastNameController.clear();
    idController.clear();
    password1Controller.clear();
    password2Controller.clear();
    emailController.clear();
    salaryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: TextButton(
              onPressed: () async {
                clearControllers();
                await showInformationDialog(context);
              },
              child: const Text(
                "Create doctor user",
              )),
        ),
      ),
    );
  }
}
