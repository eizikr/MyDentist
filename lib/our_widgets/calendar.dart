import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class LoadDataFromFireBase extends StatelessWidget {
  const LoadDataFromFireBase({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar',
      home: SchedulePlanner(),
    );
  }
}

class SchedulePlanner extends StatefulWidget {
  String? patient_id;

  SchedulePlanner({Key? key, this.patient_id}) : super(key: key);

  @override
  SchedulePlannerState createState() => SchedulePlannerState();
}

class SchedulePlannerState extends State<SchedulePlanner> {
  DateTime _selectedDate = DateTime.now();
  // Duration _duration = const Duration(hours: 1);
  CalendarView _calendarView = CalendarView.month;
  MeetingDataSource? events;
  final List<String> options = <String>['Add', 'Delete', 'Update'];
  final databaseReference = FirebaseFirestore.instance;

  void _toggleCalendarView() {
    setState(() {
      _calendarView = _calendarView == CalendarView.month
          ? CalendarView.week
          : CalendarView.month;
    });
  }

  @override
  void initState() {
    getDataFromDatabase().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });

    super.initState();
  }

  Future<void> getDataFromDatabase() async {
    var snapShotsValue = await databaseReference
        .collection("CalendarAppointmentCollection")
        .get();

    List<Meeting> list = snapShotsValue.docs
        .map((e) => Meeting(
            eventName: e.data()['eventName'],
            from:
                DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['StartTime']),
            to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['EndTime']),
            background: e.data()['beckground'],
            isAllDay: false,
            treatment: e.data()['treatment']['type']))
        .toList();
    setState(() {
      events = MeetingDataSource(list);
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
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.settings),
          itemBuilder: (BuildContext context) => options.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList(),
          onSelected: (String value) {
            // later
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => widget.patient_id == null ? meetingDialog() : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: GestureDetector(
        onDoubleTapDown: (details) {
          //final DateTime selectedDate = SfCalendar
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Selected data'),
                content: Text(_selectedDate.toString()),
              );
            },
          );
        },
        child: SfCalendar(
          view: _calendarView,
          timeSlotViewSettings:
              const TimeSlotViewSettings(startHour: 8, endHour: 18),
          showDatePickerButton: true,
          dataSource: events,
          timeZone: 'Israel Standard Time',
          monthViewSettings: const MonthViewSettings(
            showAgenda: true,
          ),
          onSelectionChanged: (date) {
            setState(() {
              _selectedDate = date.date!;
              print(_selectedDate.toString());
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCalendarView,
        child: Icon(_calendarView == CalendarView.month
            ? Icons.view_week
            : Icons.view_module),
      ),
    );
  }

  void meetingDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: double.infinity,
            child: StatefulBuilder(
              // You need this, notice the parameters below:
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

class MeetingForm extends StatefulWidget {
  final DateTime? selectedDate;
  const MeetingForm({super.key, required this.selectedDate});
  @override
  State<MeetingForm> createState() => _MeetingFormState();
}

class _MeetingFormState extends State<MeetingForm> {
  // final durations = List.generate(2 * 4, (i) => Duration(minutes: i * 15));
  late List<DateTime> start_times;
  late List<DateTime> end_times;

  late DateTime _from;
  late DateTime _to;
  final _eventName = TextEditingController();

  @override
  void initState() {
    start_times = List.generate(
        16 * 4,
        (i) => DateTime(widget.selectedDate!.year, widget.selectedDate!.month,
            widget.selectedDate!.day, 6, i * 15));
    end_times = List.generate(
        18 * 4,
        (i) => DateTime(widget.selectedDate!.year, widget.selectedDate!.month,
            widget.selectedDate!.day, 6, i * 15));
    _to = start_times.first;
    _from = start_times.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              const Text(
                'From:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              DropdownButton(
                value: _from,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _buildHoureItems(start_times),
                onChanged: (DateTime? time) {
                  setState(() {
                    _from = time!;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'To:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              DropdownButton(
                value: _to,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _buildHoureItems(end_times),
                onChanged: (DateTime? time) {
                  setState(() {
                    _to = time!;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  maxLength: 30,
                  decoration: const InputDecoration(labelText: 'event name'),
                  controller: _eventName,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancle'),
              ),
              TextButton(
                onPressed: () async {
                  addMeeting(_from, _to, _eventName.text);
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<Duration>> _buildDurationItems(List<Duration> items) {
    return items.map((duration) {
      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      final label = '$hours:$minutes';
      return DropdownMenuItem<Duration>(
        value: duration,
        child: Text(label),
      );
    }).toList();
  }

  List<DropdownMenuItem<DateTime>> _buildHoureItems(List<DateTime> items) {
    return items.map((time) {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      final label = '$hours:$minutes';
      return DropdownMenuItem<DateTime>(
        value: time,
        child: Text(label),
      );
    }).toList();
  }

  void addMeeting(DateTime from, DateTime to, String name) async {
    createMeeting(
      'hey',
      DateTime(2017, 9, 7, 17, 30),
      DateTime(2017, 9, 7, 16, 30),
    );
    // Meeting.createMeeting(name, from, to);
  }
}



// Row(
//             children: [
//               const Text(
//                 'To:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const Spacer(),
//               DropdownButton(
//                 value: _to,
//                 icon: const Icon(Icons.keyboard_arrow_down),
//                 items: _buildDurationItems(durations),
//                 onChanged: (Duration? newValue) {
//                   setState(() {
//                     _to = newValue!;
//                   });
//                 },
//               ),
//             ],
//           ),