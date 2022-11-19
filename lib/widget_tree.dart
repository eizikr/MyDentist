import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_dentist/pages/home_page.dart';
import 'package:my_dentist/pages/login_screen.dart';
import 'package:flutter/material.dart';

/*
  Manage the login states
  If loged in -> Go to home page
  Else -> Stay on login page
*/

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
