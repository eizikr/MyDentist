import 'package:flutter/material.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
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
          CheckboxListTile(
            title: const Text('All day'),
            value: isAllDay,
            checkColor: Colors.white,

            onChanged: (bool? newValue) {
              setState(() {
                isAllDay = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity
                .leading, // Align checkbox to the left of the title
          ),
          !isAllDay
              ? DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Start time'),
                  value: _from,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: buildHoureItems(startTimes),
                  onChanged: (DateTime? time) {
                    setState(() {
                      _from = time!;
                    });
                  },
                  validator: (value) {
                    return value == null ? "Enter start time" : null;
                  },
                )
              : Container(),
          !isAllDay
              ? DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'End time'),
                  value: _to,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: buildHoureItems(endTimes),
                  onChanged: (DateTime? time) {
                    setState(() {
                      _to = time!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Enter end time";
                    } else if (_from.isAfter(_to) ||
                        _from.compareTo(_to) == 0) {
                      return "End time has to be after Start time";
                    }
                    return null;
                  },
                )
              : Container(),
          TextFormField(
            maxLength: 20,
            decoration: const InputDecoration(labelText: 'Event name'),
            controller: _eventName,
            keyboardType: TextInputType.text,
            validator: (value) {
              return value == null ? "Enter event name" : null;
            },
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
                  submit();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
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
            CheckboxListTile(
              title: const Text('All day'),
              value: isAllDay,
              checkColor: Colors.white,

              onChanged: (bool? newValue) {
                setState(() {
                  isAllDay = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity
                  .leading, // Align checkbox to the left of the title
            ),
            !isAllDay
                ? DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Start time'),
                    value: _from,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: buildHoureItems(startTimes),
                    onChanged: (DateTime? time) {
                      setState(() {
                        _from = time!;
                      });
                    },
                    validator: (value) {
                      return value == null ? "Enter start time" : null;
                    },
                  )
                : Container(),
            !isAllDay
                ? DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'End time'),
                    value: _to,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: buildHoureItems(endTimes),
                    onChanged: (DateTime? time) {
                      setState(() {
                        _to = time!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Enter end time";
                      } else if (_from.isAfter(_to) ||
                          _from.compareTo(_to) == 0) {
                        return "End time has to be after Start time";
                      }
                      return null;
                    },
                  )
                : Container(),
            TextFormField(
              maxLength: 20,
              decoration: const InputDecoration(labelText: 'Event name'),
              controller: _eventName,
              keyboardType: TextInputType.text,
              validator: (value) {
                return value == null ? "Enter event name" : null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancle',
                      style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    submit();
                  },
                  child:
                      const Text('Save', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      createMeeting(_eventName.text, _from, _to, isAllDay: isAllDay);

      Navigator.of(context).pop();
      successToast('Meeting booked');
    }
  }
}
