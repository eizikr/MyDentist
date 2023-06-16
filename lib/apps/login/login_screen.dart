import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';
import '../../auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String pass;
  late String email;
  final formKey = GlobalKey<FormState>();
  bool isLoginState = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> signIn() async {
    try {
      if (formKey.currentState!.validate()) {
        setState(() {
          loading = true;
        });
        await Auth().signIn(
          email: email,
          password: pass,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      errorToast(e.code.toString());
    }
  }

  Widget _submitButton() {
    return SizedBox(
      child: RawMaterialButton(
        fillColor: OurSettings.buttonColor,
        elevation: 0.0,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: signIn,
        child: Text(
          'Login',
          style: OurSettings.buttonsTextFont,
        ),
      ),
    );
  }

  Widget _entryField(
    String title,
    IconData icon,
  ) {
    return TextFormField(
      // controller: controller,
      onChanged: (inputValue) {
        title == 'email' ? email = inputValue : pass = inputValue;
      },
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        border: InputBorder.none,
      ),
      obscureText: title == 'password' ? true : false,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "$title cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? const LoadingPage(loadingText: "Loading home page")
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: SizedBox(
                      height: 500,
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_services,
                            size: 60,
                            color: Colors.blueGrey.shade900,
                          ),
                          Text('My Dentist', style: OurSettings.titleFont),
                          const SizedBox(height: 10),
                          const Text(
                            'Hey Doctor, Please Sign In!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Email field
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: OurSettings.mainColors[100],
                                border: Border.all(color: Colors.white10),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: _entryField(
                                  'email',
                                  Icons.email_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Password field
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: OurSettings.mainColors[100],
                                border: Border.all(color: Colors.white10),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: _entryField(
                                  'password',
                                  Icons.lock_outline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _submitButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
