
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_dentist/apps/reports/patient_report.dart';
import '/modules/patient.dart';
import '/our_widgets/global.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart';
import 'package:my_dentist/our_widgets/settings.dart';



class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  EncryptData crypto = Get.find();
  
  final _str = TextEditingController();
  final List<String> dataoptions = ['gender', 'smoker'];


  Widget buildPatient(Patient patient) => RawChip(
        labelPadding: const EdgeInsets.all(2.0),
        label: Text(
          '${crypto.decryptAES(patient.firstName)} ${crypto.decryptAES(patient.lastName)}',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 95, 100, 193),
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: const EdgeInsets.all(8.0),
        avatar: const Icon(Icons.person),
        deleteIcon: const Icon(Icons.remove_circle),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PatientReportPage(patient: patient)));
        },
      );
  
  @override
  Widget build(BuildContext context) {

    Stream<List<Patient>> readPatients() => FirebaseFirestore.instance
        .collection('Patients')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Patient.fromJson(doc.data()))
            .toList());


  Widget newW (){
    return StreamBuilder<List<Patient>>(
      stream: readPatients(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('something went wrong ${snapshot.error}');
        } else if (snapshot.hasData) {
          final patients = snapshot.data!;
          var x = null;
          if (_str.text == "gender") {
            final groupedPatients = groupBy(patients, (patient) => crypto.decryptAES(patient.gender));
            x = groupedPatients.entries.map((entry) => _SalesData(entry.key, entry.value.fold(0, (previousValue, element) => previousValue + 1))).toList();
          }
          else{
            final groupedPatients = groupBy(patients, (patient) => crypto.decryptAES(patient.smoker));
            x = groupedPatients.entries.map((entry) => _SalesData(entry.key, entry.value.fold(0, (previousValue, element) => previousValue + 1))).toList();
          }
          final data = x!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: 
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(text: 'Patients ${_str.text} Analysis'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<_SalesData, String>>[

                        ColumnSeries<_SalesData, String>( //colmn sres todo 
                            dataSource: data,
                            xValueMapper: (_SalesData sales, _) => sales.x,
                            yValueMapper: (_SalesData sales, _) => sales.y,
                            name: _str.text,
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true))
                      ]),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator(
              strokeWidth: 8.0,
              color: Colors.blue,
          );
        }
      }
    );
  }



  Widget _checkBoxField({
    required String title,
    required TextEditingController controller,
    required List<String> options,
    }) {
      return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: ListTile(
            title: Text(options[0]),
            leading: Radio<String>(
              value: options[0],
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(options[1]),
            leading: Radio<String>(
              value: options[1],
              groupValue: controller.text,
              onChanged: (String? value) {
                setState(() {
                  controller.text = value!;

                });
              },
            ),
          ),
        ),
      ]
    );
  }
    return Scaffold(
              appBar: AppBar(
                title: const Text('Reports'),
                centerTitle: true,
                backgroundColor: OurSettings.backgroundColor,
              ),
              body: SingleChildScrollView(
              child:
                StreamBuilder<List<Patient>>(
                  stream: readPatients(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('something went wrong ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final patients = snapshot.data!;
                      return Column(
                        children: [
                          _checkBoxField(
                            title: "Choose the data you want to display:",
                            controller: _str,
                            options: dataoptions,
                          ),
                          newW(),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                const Center(
                                  child: Text(
                                    "Calculate the recommendation for the cost of annual dental insurance for patient ",
                                    style: TextStyle(fontSize: 30, color: Colors.black)
                                    ),
                                ),
                                const SizedBox(height: 10),
                                Center(child: Wrap(
                                      spacing: 8.0,
                                      children: patients.map(buildPatient).toList(),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator(
                          strokeWidth: 8.0,
                          color: Colors.blue,
                      );
                    }
                  },
                )
            )
          );
  }

}


class _SalesData {
  _SalesData(this.x, this.y);
  final String x;
  final double y;
}
