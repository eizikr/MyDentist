import 'package:my_dentist/auth.dart';
import 'package:my_dentist/pages/home_page.dart';
import 'package:my_dentist/pages/login_screen.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProfileScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
