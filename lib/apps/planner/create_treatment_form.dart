import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_dentist/auth.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

class TreatmentForm extends StatefulWidget {
  final DateTime? selectedDate;
  final String? patientID;

  const TreatmentForm(
      {super.key, required this.selectedDate, required this.patientID});

  @override
  State<TreatmentForm> createState() => _TreatmentFormState();
}

class _TreatmentFormState extends State<TreatmentForm> {
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
  TextEditingController remarksContrtoller = TextEditingController();
  final DB db = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
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
    var data1 = db.getTreatmentTypeNames();
    var data2 = db.getAssistantNames();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField(
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
            ),
            DropdownButtonFormField(
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
                } else if (_from.isAfter(_to) || _from.compareTo(_to) == 0) {
                  return "End time has to be after Start time";
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Tooth number'),
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
              validator: (value) {
                return value == null ? "Enter tooth number" : null;
              },
            ),

            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Treatment type'),
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
              validator: (value) {
                return value == null ? "Enter treatment type" : null;
              },
            ),

            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Assistent'),
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
              validator: (value) {
                return value == null ? "Enter assistent" : null;
              },
            ),

            TextFormField(
              controller: remarksContrtoller,
              decoration: const InputDecoration(labelText: 'Remarks'),
              autocorrect: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              keyboardType: TextInputType.multiline,
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
                    submit();
                  },
                  child: const Text('Save'),
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
      Map<String, dynamic> treatmentType = db.treatmentTypesDictionary[type]!;
      Treatment instance = Treatment(
        toothNumber: tooth,
        treatmentType: treatmentType,
        patientID: widget.patientID!,
        treatingDoctor: getCurrentUserDisplayName(),
        assistent: assistent!,
        remarks: remarksContrtoller.text,
        cost: treatmentType['price'],
        originalCost: treatmentType['price'],
      );
      addTreatmentMeeting(_from, _to, type!, instance);
      Navigator.of(context).pop();
    }
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
