import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_dentist/apps/reports/patient_report.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/settings.dart';
import '/modules/patient.dart';
import '/our_widgets/global.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  EncryptData crypto = Get.find();

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
        .map((snapshot) =>
            snapshot.docs.map((doc) => Patient.fromJson(doc.data())).toList());

    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          title: 'Reports',
          child: const Text('Reports'),
        ),
        centerTitle: true,
        backgroundColor: OurSettings.appbarColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'Exit',
        ),
      ),
      body: StreamBuilder<List<Patient>>(
        stream: readPatients(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('something went wrong ${snapshot.error}');
          } else if (snapshot.hasData) {
            final patients = snapshot.data!;
            return Column(
              children: [
                const NewWidget(),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                            "Calculate the recommendation for the cost of annual dental insurance for patient ",
                            style:
                                TextStyle(fontSize: 30, color: Colors.black)),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Wrap(
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
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({super.key});

  Stream<List<Treatment>> readTreatments() => FirebaseFirestore.instance
      .collection('Treatments')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Treatment.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Treatment>>(
        stream: readTreatments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('something went wrong ${snapshot.error}');
          } else if (snapshot.hasData) {
            final treatments = snapshot.data!;
            final groupedTreatments =
                groupBy(treatments, (treatment) => treatment.treatingDoctor);
            final data = groupedTreatments.entries
                .map((entry) => _SalesData(
                    entry.key,
                    entry.value
                        .fold(0, (sum, treatment) => sum + treatment.cost)))
                .toList();
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Sales by doctor analysis'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                        dataSource: data,
                        xValueMapper: (_SalesData sales, _) => sales.doctor,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'Sales',
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true))
                  ]),
            );
          } else {
            return const CircularProgressIndicator(
              strokeWidth: 8.0,
              color: Colors.blue,
            );
          }
        });
  }
}

class _SalesData {
  _SalesData(this.doctor, this.sales);

  final String doctor;
  final double sales;
}
