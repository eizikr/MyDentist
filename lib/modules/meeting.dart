import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

String treatmentColor = Color.fromARGB(255, 59, 199, 4).value.toRadixString(16);
String meetingColor = Color.fromARGB(255, 24, 21, 204).value.toRadixString(16);

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  String? eventName;
  String? eventType;
  DateTime? from;
  DateTime? to;
  String? background;
  bool? isAllDay;
  Treatment? treatment;

  Meeting(
      {this.eventName,
      this.eventType,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.treatment});

  Map<String, dynamic> toJson() => {
        'eventName': eventName,
        'eventType': eventType,
        'from': from,
        'to': to,
        'background': background,
        'isAllDay': isAllDay,
        'treatment': treatment //remember to send here as a json
      };

  static Meeting fromJson(Map<String, dynamic> json) => Meeting(
        eventName: json['eventName'],
        eventType: json['eventType'],
        from: json['from'],
        to: json['to'],
        background: json['background'],
        isAllDay: json['isAllDay'],
        treatment: json['treatment'],
      );

  Color get backgroundColor =>
      Color(int.parse(background ?? '0xFF000000', radix: 16));
}

Future<void> createMeeting(
  String eventName,
  // Color background,
  DateTime from,
  DateTime to, {
  Treatment? treatment,
  bool isAllDay = false,
}) async {
  // Later take care of colors desetion
  Meeting instance = Meeting(
    eventName: eventName,
    eventType: treatment == null ? 'Treatment' : 'Meeting',
    from: from,
    to: to,
    background: treatment == null ? meetingColor : treatmentColor,
    isAllDay: isAllDay,
    treatment: treatment,
  );

  try {
    await FirebaseFirestore.instance
        .collection('Meetings')
        .doc()
        .set(instance.toJson());
    print('Meeting saved successfully');
  } catch (e) {
    print('Error saving meeting: $e');
  }
  // final DB db = Get.find();
  // final meetingDocuments = db.meetings;

  // // print('hey');
  // var query = meetingDocuments.where('from', isGreaterThan: to);

  // query.get().then(
  //   (snapshot) {
  //     if (snapshot.docs.isNotEmpty) {
  //       print('dates error');
  //     } else {
  //       meetingDocuments.add(instance.toJson());
  //     }
  //   },
  // ).catchError((error) {
  //   print('The write failed...${error}');
  // });
}
