import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/services.dart';
import '/modules/patient.dart';
import 'package:chaquopy/chaquopy.dart';

class Python {
  static Future<String> run(String code) async {
    dynamic result = await Chaquopy.executeCode(code);
    return result.toString();
  }
}

Future<String> getString() async {
  final futureString = await Python.run("""print("res")""");
  final result = await futureString;
  print("res");
  return result;
}


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // String result = await Python.run("print(\"res\")");
  // import pandas as pd
  // from sklearn.model_selection import train_test_split
  // from sklearn.linear_model import LinearRegression

  // # Your sklearn code goes here
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
                return CircularProgressIndicator();
              }
            },
          );
  }
}

 
/*
// from chatGPT
import 'package:flutter/material.dart';
import 'package:chaquopy/chaquopy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _output = '';

  @override
  void initState() {
    super.initState();
    _runPythonScript();
  }

  void _runPythonScript() async {
    // Initialize the Chaquopy plugin
    await Chaquopy.init();
    
    // Define the Python script to be executed
    String pythonCode = '''
    a = 5
    b = 7
    c = a + b
    print("The sum of", a, "and", b, "is", c)
    ''';
    
    // Run the Python script and get the output
    String output = await Chaquopy.executeCode(pythonCode);
    
    // Update the state to display the output
    setState(() {
      _output = output;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chaquopy Example'),
        ),
        body: Center(
          child: Text(_output),
        ),
      ),
    );
  }
}

 */