import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import '../../auth.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginState = true;
  late String pass;
  late String email;
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  String signInError(String errorCode) {
    switch (errorCode) {
      case "user-not-found":
        {
          return "Wrong email!";
        }
      case "wrong-password":
        {
          return "Wrong password!";
        }
      case "invalid-email":
        {
          return "Invalid email!";
        }
      case "too-many-requests":
        return "Try again in a second";
      default:
        {
          return "General error!";
        }
    }
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
      print(e.code.toString());
      Fluttertoast.showToast(
        msg: signInError(e.code.toString()),
        gravity: ToastGravity.TOP,
        fontSize: 16.0,
        webShowClose: true,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        webPosition: "center",
        webBgColor: "red",
        timeInSecForIosWeb: 2,
      );
    }
  }

  Widget _submitButton(double width) {
    return SizedBox(
      width: width,
      child: RawMaterialButton(
        fillColor: Colors.lightBlue[100],
        elevation: 0.0,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: signIn,
        child: Text(
          'Login',
          style: GoogleFonts.roboto(fontSize: 17, color: Colors.black),
        ),
        // child: Text(isLoginState ? 'Login' : 'Register'),
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    var screenWidth = queryData.size.width;
    var screenHeight = queryData.size.height;

    return loading == true
        ? const LoadingPage(loadingText: "Loading home page")
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth / 6,
                          vertical: screenHeight / 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.medical_services,
                            size: 60,
                          ),
                          Text(
                            'My Dentist',
                            style: GoogleFonts.caveat(
                              fontSize: 55,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Hey Doctor!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.lightBlue[50],
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.lightBlue[50],
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
                          _submitButton(screenWidth * 0.2),
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
