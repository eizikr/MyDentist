import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/apps/home/home_page.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:my_dentist/our_widgets/calendar.dart';
import 'firebase_options.dart';
import 'widget_tree.dart';
import 'our_widgets/global.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(DB());
  Get.put(EncryptData());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor: const Color.fromARGB(255, 207, 235, 248),
      ),
      home: const LoadDataFromFireBase(),
      // home: const WidgetTree(),
      // home: const HomePage(),
    );
  }
}
