import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_dentist/apps/patient/patient_card_tabs/treatments_tab/treatment_care.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class ShowTreatmentScreen extends StatefulWidget {
  final String patientID;
  final bool isHistory;

  const ShowTreatmentScreen({
    super.key,
    required this.patientID,
    required this.isHistory,
  });

  @override
  State<ShowTreatmentScreen> createState() => _ShowTreatmentScreenState();
}

class _ShowTreatmentScreenState extends State<ShowTreatmentScreen> {
  final DB db = Get.find();

  @override
  void initState() {
    super.initState();
  }

  Widget buildTreatment(Map<String, dynamic> meeting) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 170, 226, 252),
      ),
      child: ListTile(
        title: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TreatmentCare(
                  meeting: meeting,
                  patientId: widget.patientID,
                ),
              ),
            );
          },
          child: Text(
            '${meeting['eventName']}\n',
            style: TextStyle(color: OurSettings.mainColors[800]),
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                DateFormat('yMd').format(meeting['from'].toDate()),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                '${DateFormat('hh:mm').format(meeting['from'].toDate())} - ${DateFormat("hh:mm").format(meeting['to'].toDate())}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (context) =>
                    TreatmentDetailsDialog(meetingInstance: meeting));
          },
          tooltip: 'Present Details',
          icon: const Icon(
            Icons.insert_drive_file_outlined,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text(widget.isHistory ? 'Treatments History' : 'Future Treatments'),
        centerTitle: true,
        backgroundColor: OurSettings.appbarColor,
      ),
      body: Container(
        color: OurSettings.mainColors[100],
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Meetings')
              .where('treatment.patientID', isEqualTo: widget.patientID)
              .where('treatment.isDone', isEqualTo: widget.isHistory)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final meetings = snapshot.data!.docs;
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: meetings.length,
                itemBuilder: (context, index) {
                  final meeting =
                      meetings[index].data() as Map<String, dynamic>;
                  return buildTreatment(meeting);
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: OurSettings.mainColors[200],
        height: 50,
        child: Center(
          child: RichText(
            text: TextSpan(
              text: 'Patient id: ',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: widget.patientID,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TreatmentDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> meetingInstance;

  const TreatmentDetailsDialog({super.key, required this.meetingInstance});

  @override
  Widget build(BuildContext context) {
    int discount = meetingInstance['treatment']['discount'];

    DateTime from = meetingInstance['from'] is Timestamp
        ? meetingInstance['from'].toDate()
        : meetingInstance['from'];

    DateTime to = meetingInstance['to'] is Timestamp
        ? meetingInstance['to'].toDate()
        : meetingInstance['to'];

    return AlertDialog(
      backgroundColor: OurSettings.mainColors[100],
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
                  '${DateFormat("yyyy-MM-dd hh:mm").format(from)}-${DateFormat("hh:mm").format(to)}',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Price: ${meetingInstance['treatment']['cost']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                discount != 0
                    ? Text(
                        'Origin Price${meetingInstance['treatment']['originalCost']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    : Container(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Discount: ${meetingInstance['treatment']['discount']} %',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
