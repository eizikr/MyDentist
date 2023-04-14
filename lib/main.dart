import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/apps/home/home_page.dart';
import 'package:my_dentist/apps/reports/report.dart';
import 'firebase_options.dart';
import 'our_widgets/settings.dart';
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
  // printMeeting("yJjgrXHCXZNyhuEJAo5V");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: ourSettings.ourMaterialColor,
        scaffoldBackgroundColor: ourSettings.backgroundColor,
      ),
      // home: const LoadDataFromFireBase(),
      // home: const WidgetTree(),
      // home: const HomePage(),
      home: const ReportPage(),
    );
  }
}
