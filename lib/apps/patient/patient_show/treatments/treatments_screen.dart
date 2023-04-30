import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:my_dentist/modules/patient.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class ShowTreatmentScreen extends StatefulWidget {
  final String patientID;
  final bool is_history;

  const ShowTreatmentScreen({
    super.key,
    required this.patientID,
    required this.is_history,
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
      .map((snapshot) =>
          snapshot.docs.map((doc) => Meeting.fromJson(doc.data())).toList());

  Future<void> treatmentDialog(Map<String, dynamic> meetingInstance) =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsOverflowDirection: VerticalDirection.down,
          title: Center(
            child: Text(
              meetingInstance['eventName'],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${DateFormat("yyyy-MM-dd hh:mm").format(meetingInstance['from'].toDate())}-${DateFormat("hh:mm").format(meetingInstance['to'].toDate())}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tooth: ${meetingInstance['treatment']['toothNumber']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Treating Doctor: ${meetingInstance['treatment']['treatingDoctor']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Assistent: ${meetingInstance['treatment']['assistent']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Remarks: ${meetingInstance['treatment']['remarks']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );

  Widget buildTreatment(Map<String, dynamic> meeting) => ListTile(
        title: Text(meeting['eventName']),
        subtitle: Text(
          '${DateFormat("yyyy-MM-dd hh:mm").format(meeting['from'].toDate())}-${DateFormat("hh:mm").format(meeting['to'].toDate())}',
        ),
        trailing: IconButton(
          onPressed: () {
            treatmentDialog(meeting);
          },
          icon: const Icon(Icons.insert_drive_file_outlined),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            widget.is_history ? 'Treatments History' : 'Future Treatments'),
        centerTitle: true,
        backgroundColor: ourSettings.backgroundColors[200],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Meetings')
            .where('treatment.isDone', isEqualTo: widget.is_history)
            .where('treatment.patientID', isEqualTo: widget.patientID)
            .snapshots(),
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
              return buildTreatment(meeting);
            },
          );
        },
      ),
    );
  }
}
