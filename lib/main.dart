import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/apps/home/home_page.dart';
import 'package:my_dentist/apps/reports/report.dart';
import 'firebase_options.dart';
import 'our_widgets/settings.dart';
import 'widget_tree.dart';
import 'our_widgets/global.dart';
import 'package:get/get.dart';

void setGlobalData() {
  Get.put(DB());
  Get.put(EncryptData());
  final DB db = Get.find();
  db.setTreatmentTypeNames();
  db.setAssistantNames();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setGlobalData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: OurSettings.backgroundColors,
        scaffoldBackgroundColor: OurSettings.backgroundColor,
      ),
      darkTheme: ThemeData(
        primarySwatch: OurSettings.backgroundColors,
        scaffoldBackgroundColor: OurSettings.backgroundColor,
      ),
      // home: const LoadDataFromFireBase(),
      home: const WidgetTree(),
      // home: const HomePage(),
      // home: const ReportPage(),
    );
  }
}
