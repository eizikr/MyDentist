import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/modules/docrots.dart';
import 'package:my_dentist/modules/patient.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Color treatmentColor = const Color.fromARGB(255, 51, 150, 56);
Color meetingColor = const Color.fromARGB(255, 60, 61, 131);
Color allDayColor = const Color.fromARGB(255, 131, 60, 60);

class FirebaseMeetingDataSource extends CalendarDataSource {
  FirebaseMeetingDataSource() {
    streamMeetings();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void streamMeetings() {
    _firestore.collection('Meetings').snapshots().listen((event) {
      List<Meeting> meetings =
          event.docs.map((doc) => Meeting.fromJson(doc.data())).toList();
      appointments = meetings;
      notifyListeners(CalendarDataSourceAction.reset, meetings);
    });
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from!;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to!;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay!;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName!;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background!;
  }
}

class Meeting {
  String? summary;
  String? id;
  String? eventName;
  String? eventType;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  Map<String, dynamic>? treatment;
  Map<String, dynamic>? doctor;

  Meeting({
    this.summary,
    this.eventName,
    this.eventType,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.treatment,
    this.id,
    this.doctor,
  });

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'eventName': eventName,
        'eventType': eventType,
        'from': from,
        'to': to,
        'background': background!.value.toString(),
        'isAllDay': isAllDay,
        'treatment': treatment, //remember to send here as a json
        'doctor': doctor,
      };

  static Meeting fromJson(Map<String, dynamic> json) => Meeting(
        summary: json['summary'],
        eventName: json['eventName'],
        eventType: json['eventType'],
        from: (json['from'] as Timestamp).toDate(),
        to: (json['to'] as Timestamp).toDate(),
        background: Color(int.parse(json['background'])),
        isAllDay: json['isAllDay'],
        treatment: json['treatment'],
        id: json['id'],
        doctor: json['doctor'],
      );

  Future<void> deleteMeeting() async {
    try {
      await FirebaseFirestore.instance.collection('Meetings').doc(id).delete();
      if (treatment != null) {
        Patient.updatePatientPayment(
            treatment!['patientID'], -(treatment!['cost']));
      }
      successToast('Meeting deleted successfully');
    } catch (e) {
      errorToast('Error: $e');
    }
  }

  static Stream<List<Meeting>> getPatientMeetings(String patientID) {
    final DB db = Get.find();

    return FirebaseFirestore.instance
        .collection('Meetings')
        .where('treatment.patientID', isEqualTo: patientID)
        .where('treatment.isDone', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data();
              String id = doc.id;
              return Meeting(id: id, treatment: data['treatment']);
            }).toList());
  }

  static Future<void> updateSummary(String meetingID, String summary) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('Meetings');

      DocumentReference newMeetingRef = collection.doc(meetingID);

      await newMeetingRef.update({'summary': summary});
    } catch (e) {
      errorToast('Error: $e');
    }
  }

  static Future<void> updatePerscription(
      String meetingID, String perscription) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('Meetings');

      DocumentReference newMeetingRef = collection.doc(meetingID);

      await newMeetingRef.update({'treatment.perscription': perscription});
    } catch (e) {
      errorToast('Error: $e');
    }
  }
}

Future<void> createMeeting(
  String eventName,
  DateTime from,
  DateTime to, {
  Treatment? treatment,
  bool isAllDay = false,
  Doctor? doctor,
}) async {
  Meeting instance = Meeting(
    summary: '',
    eventName: eventName,
    eventType: treatment == null ? 'Meeting' : 'Treatment',
    from: from,
    to: to,
    background: treatment == null
        ? meetingColor
        : isAllDay == true
            ? allDayColor
            : treatmentColor,
    isAllDay: isAllDay,
    treatment: treatment?.toJson(),
    doctor: await getCurrentDoctor(),
  );

  if (treatment != null) {
    Patient.updatePatientPayment(treatment.patientID, treatment.cost);
  }

  try {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Meetings');
    DocumentReference newMeetingRef = await collection.add(instance.toJson());
    await newMeetingRef.update({'id': newMeetingRef.id});
    successToast('Meeting was successfully set');
  } catch (e) {
    errorToast('Error: $e');
  }
}

Future<void> changeMeetingStatus(
    Map<String, dynamic> meeting, bool isDone) async {
  try {
    FirebaseFirestore.instance
        .collection('Meetings')
        .doc(meeting['id'])
        .update({'treatment.isDone': isDone});
    successToast(isDone ? 'Meeting is done' : 'Meeting back to progress');
  } catch (e) {
    errorToast('Error: $e');
  }
}

Stream<List<Meeting>> readMeetings() => FirebaseFirestore.instance
    .collection('Meetings')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Meeting.fromJson(doc.data())).toList());
