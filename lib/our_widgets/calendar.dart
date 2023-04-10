import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dentist/modules/assistant.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

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
  final databaseReference = FirebaseFirestore.instance;
  late List<Meeting> _meetingDetails = <Meeting>[];

  void _toggleCalendarView() {
    setState(() {
      _calendarView = _calendarView == CalendarView.month
          ? CalendarView.week
          : CalendarView.month;
    });
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _meetingDetails = calendarTapDetails.appointments!.cast<Meeting>();
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'Exit',
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () => widget.patient_id == null
                  ? meetingDialog()
                  : createTreatmentDialog(),
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

          // Convert QuerySnapshot to List of Meeting objects
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
                ),
              ),
              Expanded(
                  child: Container(
                      color: Colors.black12,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(2),
                        itemCount: _meetingDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              padding: const EdgeInsets.all(2),
                              height: 60,
                              color: _meetingDetails[index].background,
                              child: ListTile(
                                leading: Column(
                                  children: <Widget>[
                                    Text(
                                      _meetingDetails[index].isAllDay!
                                          ? ''
                                          : DateFormat('hh:mm a').format(
                                              _meetingDetails[index].from!),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      _meetingDetails[index].isAllDay!
                                          ? 'All day'
                                          : '',
                                      style: const TextStyle(
                                          height: 0.5, color: Colors.white),
                                    ),
                                    Text(
                                      _meetingDetails[index].isAllDay!
                                          ? ''
                                          : DateFormat('hh:mm a').format(
                                              _meetingDetails[index].to!),
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.white,
                                  onPressed: () {
                                    _showAppointmentDetails(
                                        context, _meetingDetails[index]);
                                  },
                                  tooltip: 'Delete meeting',
                                ),
                                title: Text(
                                    '${_meetingDetails[index].eventName}',
                                    textAlign: TextAlign.center,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          height: 5,
                        ),
                      )))
            ],
          );
        },
      ),
    );
  }

  void createTreatmentDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content:
            StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
          return treatmentForm(
            selectedDate: _selectedDate,
            patientID: widget.patient_id,
          );
        }));
      },
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

  void _showAppointmentDetails(BuildContext context, Meeting meeting) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _deleteMeeting(meeting);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
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
  late List<DateTime> startTimes;
  late List<DateTime> endTimes;
  late DateTime selectedDate;
  late DateTime _from;
  late DateTime _to;
  final _eventName = TextEditingController();
  late bool isAllDay = false;

  @override
  void initState() {
    selectedDate = widget.selectedDate!;
    startTimes = List.generate(
        16 * 4,
        (i) => DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
            6, i * 15));
    endTimes = List.generate(
        18 * 4,
        (i) => DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
            6, i * 15));
    _from = startTimes.first;
    _to = startTimes[1];
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
            ],
          ),
          Row(
            children: [
              const Text(
                'Is all day:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Checkbox(
                checkColor: Colors.white,
                value: isAllDay,
                onChanged: (bool? value) {
                  setState(() {
                    isAllDay = value!;
                  });
                },
              ),
            ],
          ),
          !isAllDay
              ? Row(
                  children: [
                    const Text(
                      'From:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    DropdownButton(
                      value: _from,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _buildHoureItems(startTimes),
                      onChanged: (DateTime? time) {
                        setState(() {
                          _from = time!;
                        });
                      },
                    ),
                  ],
                )
              : Container(),
          !isAllDay
              ? Row(
                  children: [
                    const Text(
                      'To:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    DropdownButton(
                      value: _to,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _buildHoureItems(endTimes),
                      onChanged: (DateTime? time) {
                        setState(() {
                          _to = time!;
                        });
                      },
                    ),
                  ],
                )
              : Container(),
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
                child:
                    const Text('Cancle', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  !isAllDay
                      ? addMeeting(_from, _to, _eventName.text)
                      : addMeeting(
                          startTimes.first,
                          endTimes.last,
                          _eventName.text,
                          isAllDay: isAllDay,
                        );
                  Navigator.of(context).pop();
                },
                child:
                    const Text('Save', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void addMeeting(DateTime from, DateTime to, String name,
      {bool isAllDay = false}) {
    if (from.isAfter(to) || from.compareTo(to) == 0) {
      errorToast('"To" field has to be after "From"');
    } else if (DateTime.now().isAfter(from)) {
      errorToast('Cant set meeting on past time');
    } else {
      createMeeting(name, from, to, isAllDay: isAllDay);
    }
  }
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

void _deleteMeeting(Meeting meeting) {
  meeting.deleteMeeting();
}

class treatmentForm extends StatefulWidget {
  final DateTime? selectedDate;
  final String? patientID;

  const treatmentForm(
      {super.key, required this.selectedDate, required this.patientID});

  @override
  State<treatmentForm> createState() => _treatmentFormState();
}

class _treatmentFormState extends State<treatmentForm> {
  String tooth = '1';
  late final List<String> tooths;
  String? type;
  String? assistent;
  String? startTime;
  late List<DateTime> startTimes;
  late List<DateTime> endTimes;
  late DateTime selectedDate;
  late DateTime _from;
  late DateTime _to;
  TextEditingController remarksContrtoller = new TextEditingController();

  void initState() {
    tooths = [];
    for (int i = 1; i <= 32; i++) {
      tooths.add(i.toString());
    }
    selectedDate = widget.selectedDate!;
    startTimes = List.generate(
        16 * 4,
        (i) => DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
            6, i * 15));
    endTimes = List.generate(
        18 * 4,
        (i) => DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
            6, i * 15));
    _from = startTimes.first;
    _to = startTimes[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: Future.wait([
          TreatmentType.getNames(),
          Assistant.getNames(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // The two futures data are available in snapshot.data.
            var data1 = snapshot.data![0];
            var data2 = snapshot.data![1];

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                //Tooth number dropdown
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
                      items: _buildHoureItems(startTimes),
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
                      items: _buildHoureItems(endTimes),
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
                    const Text(
                      'Tooth number:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    DropdownButton(
                      value: tooth,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: tooths.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          tooth = newValue!;
                        });
                      },
                    ),
                  ],
                ),

                //Treatment type dropdown
                Row(
                  children: [
                    const Text(
                      'Treatment:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    DropdownButton(
                      value: type,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: data1.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          type = newValue!;
                        });
                      },
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text(
                      'Assistent:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    DropdownButton(
                      value: assistent,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: data2.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          assistent = newValue!;
                        });
                      },
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text(
                      'Remarks:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Expanded(
                      child: TextField(
                        maxLength: 50,
                        decoration: const InputDecoration(labelText: 'Remarks'),
                        controller: remarksContrtoller,
                      ),
                    ),
                  ],
                ),

                //Bottom Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancle'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Treatment instance = Treatment(
                            toothNumber: tooth,
                            type: type!,
                            patientID: widget.patientID!,
                            treatingDoctor: 'Dr.Heler',
                            assistent: assistent!,
                            remarks: remarksContrtoller.text);
                        createTreatment(instance);
                        addTreatmentMeeting(_from, _to, type!, instance);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void addTreatmentMeeting(
      DateTime from, DateTime to, String name, Treatment treatment) {
    if (from.isAfter(to) || from.compareTo(to) == 0) {
      errorToast('"To" field has to be after "From"');
    } else if (DateTime.now().isAfter(from)) {
      errorToast('Cant set meeting on past time');
    } else {
      createMeeting(name, from, to, treatment: treatment);
    }
  }
}
