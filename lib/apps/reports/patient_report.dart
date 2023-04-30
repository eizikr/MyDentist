import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:my_dentist/our_widgets/settings.dart';
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
      String age = crypto.decryptAES(_patient.age);
      String sex = crypto.decryptAES(_patient.gender);
      String sm = crypto.decryptAES(_patient.smoker);
      String ch = crypto.decryptAES(_patient.children);
      double h = double.parse(crypto.decryptAES(_patient.height))/100;
      double bmi = double.parse(crypto.decryptAES(_patient.weight))/(h*h);
      var response = await http.get(Uri.parse('http://127.0.0.1:5000/api?age=$age&sex=$sex&ch=$ch&sm=$sm&bmi=$bmi'));
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
                      return Scaffold(
                              backgroundColor: ourSettings.appbarColor,
                              body: Center(
                                    child: Column (
                                      
                                      children: [
                                      const Text('A recommendation for the cost of annual dental insurance is :',
                                            style: TextStyle(fontSize: 30, color: Colors.black)
                                        ),
                                        Text('${snapshot.data}\$',
                                            style: const TextStyle(fontSize: 45, color: Colors.black)
                                    )
                                    ],                                ),
                              )
                      );
                    }
                  } 
                  else {
                      return const CircularProgressIndicator(
                          strokeWidth: 8.0,
                          color: Colors.blue,
                      );                  
                  }                          
            },
    );
  }
}
