import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_dentist/apps/patient/patient_card_tabs/treatments_tab/treatments_list.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:my_dentist/modules/patient.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:my_dentist/apps/planner/create_meeting_form.dart';
import 'package:my_dentist/apps/planner/create_treatment_form.dart';

class SchedulePlanner extends StatefulWidget {
  final String? patientId;
  const SchedulePlanner({Key? key, this.patientId}) : super(key: key);

  @override
  SchedulePlannerState createState() => SchedulePlannerState();
}

class SchedulePlannerState extends State<SchedulePlanner> {
  Patient? patient;

  DateTime _selectedDate = DateTime.now();
  final CalendarView _calendarView = CalendarView.month;
  final databaseReference = FirebaseFirestore.instance;
  late List<Meeting> meetingDetails = <Meeting>[];
  late CalendarTapDetails currentCalendarTapDetails;

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        meetingDetails = calendarTapDetails.appointments!.cast<Meeting>();
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  bool isLegalDay() {
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (yesterday.isAfter(_selectedDate)) {
      errorToast('Cant set meeting on past time');
      return false;
    }
    return true;
  }

  void refreshDate() {
    setState(() {
      _selectedDate = _selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          title: 'Scheduler planner',
          child: const Text('Scheduler'),
        ),
        centerTitle: true,
        backgroundColor: OurSettings.appbarColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'Exit',
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                if (isLegalDay()) {
                  if (widget.patientId == null) {
                    await meetingDialog();
                  } else {
                    await createTreatmentDialog();
                  }
                }
              },
              icon: const Icon(Icons.add),
              tooltip: 'Add event'),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Meetings').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Meeting> meetings = [];

          for (var document in snapshot.data!.docs) {
            Map<String, dynamic>? data =
                document.data() as Map<String, dynamic>?;
            if (data != null) {
              Meeting meeting = Meeting.fromJson(data);
              meetings.add(meeting);
            }
          }

          return Column(
            children: [
              Expanded(
                // Dates part
                flex: 2,
                child: SfCalendar(
                  view: _calendarView,
                  dataSource: FirebaseMeetingDataSource(),
                  timeSlotViewSettings:
                      const TimeSlotViewSettings(startHour: 8, endHour: 18),
                  showDatePickerButton: true,
                  timeZone: 'Israel Standard Time',
                  onTap: calendarTapped,
                  onSelectionChanged: (date) {
                    setState(() {
                      _selectedDate = date.date!;
                    });
                  },
                  todayHighlightColor: Colors.lightBlue[200],
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  monthViewSettings: const MonthViewSettings(
                    monthCellStyle: MonthCellStyle(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  todayTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: MeetingData(meetingDetails: meetingDetails),
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> createTreatmentDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: OurSettings.mainColors[100],
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return TreatmentForm(
                selectedDate: _selectedDate,
                patientID: widget.patientId,
              );
            },
          ),
        );
      },
    );
  }

  Future<void> meetingDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: OurSettings.mainColors[100],
          content: SizedBox(
            width: double.infinity,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return MeetingForm(
                  selectedDate: _selectedDate,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

void _deleteMeeting(Meeting meeting) {
  meeting.deleteMeeting();
}

class MeetingData extends StatefulWidget {
  final List<Meeting> meetingDetails;
  const MeetingData({super.key, required this.meetingDetails});

  @override
  State<MeetingData> createState() => _MeetingDataState();
}

class _MeetingDataState extends State<MeetingData> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: ListView.separated(
        padding: const EdgeInsets.all(2),
        itemCount: widget.meetingDetails.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(2),
            height: 60,
            color: widget.meetingDetails[index].background,
            child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.meetingDetails[index].isAllDay!
                          ? ''
                          : DateFormat('hh:mm a')
                              .format(widget.meetingDetails[index].from!),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.meetingDetails[index].isAllDay! ? 'All day' : '',
                      style: const TextStyle(height: 0.5, color: Colors.white),
                    ),
                    Text(
                      widget.meetingDetails[index].isAllDay!
                          ? ''
                          : DateFormat('hh:mm a')
                              .format(widget.meetingDetails[index].to!),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () {
                    confirmationDialog(
                      context,
                      () {
                        _deleteMeeting(widget.meetingDetails[index]);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  tooltip: 'Delete meeting',
                ),
                title: Column(
                  children: [
                    (widget.meetingDetails[index].treatment == null)
                        ? Text(
                            '${widget.meetingDetails[index].eventName}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          )
                        : TextButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) => TreatmentDetailsDialog(
                                  meetingInstance:
                                      widget.meetingDetails[index].toJson(),
                                ),
                              );
                            },
                            child: Text(
                              '${widget.meetingDetails[index].eventName}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            )),
                    Text(
                      'Dr ${widget.meetingDetails[index].doctor!['lastName']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 5,
        ),
      ),
    );
  }
}


                  // '${widget.meetingDetails[index].eventName}\nDr ${widget.meetingDetails[index].doctor!['lastName']}',
                  // textAlign: TextAlign.center,
                  // style: const TextStyle(color: Colors.white)),