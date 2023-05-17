import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class TreatmentCare extends StatefulWidget {
  Map<String, dynamic> meeting;
  String patient_id;
  TreatmentCare({super.key, required this.meeting, required this.patient_id});

  @override
  State<TreatmentCare> createState() => _TreatmentCareState();
}

class _TreatmentCareState extends State<TreatmentCare> {
  late Map<String, dynamic> meeting;
  List<Icon> icons = [const Icon(Icons.done), const Icon(Icons.cancel)];
  late Icon icon;
  late int iconIndex;
  late List<String> toolTips = ['Finish treatment', 'Bring treatment back'];
  final DB db = Get.find();
  EncryptData crypto = Get.find();

  late CollectionReference patient;
  void changeDoneIcon() {
    setState(() {
      iconIndex = (iconIndex + 1) % 2;
    });
  }

  @override
  void initState() {
    meeting = widget.meeting;
    if (meeting['treatment']['isDone']) {
      iconIndex = 1;
    } else {
      iconIndex = 0;
    }
    icon = icons[iconIndex];
    patient = db.patients;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Title(
            color: Colors.white,
            title: 'Treatment',
            child: const Text('Treatment'),
          ),
          centerTitle: true,
          backgroundColor: OurSettings.appbarColor,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Exit',
          ),
          actions: [
            IconButton(
                onPressed: () {
                  changeDoneIcon();
                  changeMeetingStatus(meeting, iconIndex == 1 ? true : false);
                },
                tooltip: toolTips[iconIndex],
                icon: icons[iconIndex]),
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: patient.doc(widget.patient_id).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return treatmentPage(data);
            }
            return loadingCircule('Loading treatment page...');
          },
        ));
  }

  Widget treatmentPage(Map<String, dynamic> data) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  bottom: BorderSide(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  top: BorderSide(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  right: BorderSide(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      patientInfoItem(
                          'First Name: ${crypto.decryptAES(data['first_name'])}'),
                      patientInfoItem(
                          'Last Name: ${crypto.decryptAES(data['last_name'])}'),
                      patientInfoItem('ID: ${crypto.decryptAES(data['id'])}'),
                      patientInfoItem(
                          'Gender: ${crypto.decryptAES(data['gender'])}'),
                      patientInfoItem('Age: ${crypto.decryptAES(data['age'])}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  bottom: BorderSide(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  right: BorderSide(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: patientInfoItem(
                        'Treatment type: ${meeting['treatment']['type']}'),
                  ),
                  Row(
                    children: [
                      patientInfoItem(
                          'From: ${DateFormat("yyyy-MM-dd hh:mm").format(meeting['from'].toDate())}'),
                      patientInfoItem(
                          'To: ${DateFormat("yyyy-MM-dd hh:mm").format(meeting['to'].toDate())}'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.grey[200], // set the background color here
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const TextField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: 'Enter your text here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: BasicButton(
                            onClicked: () {},
                            text: 'Discount',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: BasicButton(
                            onClicked: () {},
                            text: 'Show patient ditails',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: BasicButton(
                            onClicked: () {},
                            text: 'Save treatment details',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget patientInfoItem(String str) {
  return Expanded(
    child: Text(
      str,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20),
    ),
  );
}

Widget meetingInfoItem(String str) {
  return Expanded(
    child: Text(
      str,
      style: const TextStyle(fontSize: 15),
    ),
  );
}
