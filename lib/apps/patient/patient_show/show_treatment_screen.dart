import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:my_dentist/modules/patient.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class ShowTreatmentScreen extends StatefulWidget {
  final String patientID;
  // final String pFirstName;
  // final String pLastName;

  const ShowTreatmentScreen({
    super.key,
    required this.patientID,
    // required this.pFirstName,
    // required this.pLastName,
  });

  @override
  State<ShowTreatmentScreen> createState() => _ShowTreatmentScreenState();
}

class _ShowTreatmentScreenState extends State<ShowTreatmentScreen> {
  final DB db = Get.find();
  late final Patient patient;
  void initState() {
    CollectionReference patients = db.patients;

    super.initState();
  }

  Stream<List<Meeting>> readMeetings() => FirebaseFirestore.instance
      .collection('Meetings')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Meeting.fromJson(doc.data()))
          // .where((Meeting? element) =>
          //     element?.treatment != null &&
          //     element?.treatment!['patientID'] == widget.patientID)
          .toList());

  Future<void> treatmentDialog(Map<String, dynamic> meetingInstance) =>
      showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("${meetingInstance['eventName']}"),
              ));

  Widget buildTreatment(Meeting meetingInstance) => const ListTile(
        // leading: IconButton(
        //   onPressed: () {
        //     treatmentDialog(meetingInstance);
        //   },
        //   icon: const Icon(Icons.insert_drive_file_outlined),
        // ),
        title: Text(
          "hey",
          style: TextStyle(color: Colors.black),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Treatments for ${widget.patientID}'),
        centerTitle: true,
        backgroundColor: ourSettings.backgroundColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Meetings').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final meetings = snapshot.data!.docs;
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: meetings.length,
            itemBuilder: (context, index) {
              final meeting = meetings[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(meeting['id']),
                subtitle: Text(meeting['eventName']),
                trailing: IconButton(
                  onPressed: () {
                    treatmentDialog(meeting);
                  },
                  icon: const Icon(Icons.insert_drive_file_outlined),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
