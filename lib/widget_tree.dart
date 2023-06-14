import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_dentist/apps/home/home_page.dart';
import 'package:my_dentist/apps/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';

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
        if (snapshot.connectionState != ConnectionState.active) {
          return const LoadingPage(
            loadingText: 'loading...',
          );
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
