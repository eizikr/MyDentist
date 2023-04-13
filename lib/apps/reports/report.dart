import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  int age = 19;
  String sw = 'female';
  double pl = 27.9;
  int pw = 0;
  String sw2 = 'yes';
  String sw3 = 'southwest';


  Future<String> getString() async {
      var response = await http.get(Uri.parse('http://127.0.0.1:5000/api?age=$age&sw=$sw&pl=$pl&pw=$pw'));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        return decodedData['query'];
      } else {
        return "Error 404";
    }
    return "Error";
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
     future: getString(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Data: ${snapshot.data}');
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
  }
}
