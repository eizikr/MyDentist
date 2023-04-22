import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '/modules/patient.dart';
import '/our_widgets/global.dart';

class PatientReportPage extends StatefulWidget {
  final Patient patient;
  const PatientReportPage({super.key, required this.patient});

  @override
  State<PatientReportPage> createState() => _PatientReportPageState();
}

class _PatientReportPageState extends State<PatientReportPage> {
  late Patient _patient;
  EncryptData crypto = Get.find();
  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
  }

  Future<String> getPred() async {
      //enter details
      double bmi = 27.9;
      int ch = 0; // children
      //end
      String age = crypto.decryptAES(_patient.age);
      String sex = crypto.decryptAES(_patient.gender);
      String sm = crypto.decryptAES(_patient.smoker);
      var response = await http.get(Uri.parse('http://127.0.0.1:5000/api?age=$age&sex=$sex&bmi=$bmi&ch=$ch&sm=$sm'));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        return decodedData['pred'];
      } else {
        return "Error ${response.statusCode}";
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
            future: getPred(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('Data: ${snapshot.data}');
                    }
                  } 
                  else {
                    return const CircularProgressIndicator();
                  }                          
            },
    );
  }
}
