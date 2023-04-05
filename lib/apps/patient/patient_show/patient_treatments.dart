import 'package:flutter/material.dart';
import 'package:my_dentist/apps/home/home_page.dart';
import 'package:my_dentist/modules/assistant.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:get/get.dart';

class PatientTreatmentsPage extends StatefulWidget {
  final String patientID;
  const PatientTreatmentsPage({super.key, required this.patientID});
  @override
  State<PatientTreatmentsPage> createState() => _PatientTreatmentsPageState();
}

class _PatientTreatmentsPageState extends State<PatientTreatmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BasicButton(
                  text: 'Create Treatment', onClicked: () => showMyDialog())
            ],
          ),
        ),
        // First column content
      ),
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
              bottom: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
              top: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
              right: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
            ),
          ),
          // Second column content
        ),
      ),
    ]);
  }

  void showMyDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content:
            StatefulBuilder(// You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
          return const treatmentForm();
        }));
      },
    );
  }

//   Future<void> createTreatmentDialog(context) => showDialog<void>(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Enter treatment details'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     const Text(
//                       'Tooth number: ',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const Spacer(),
//                     DropdownButton<String>(
//                       value: tooth,
//                       onChanged: (String? value) {
//                         setState(() {
//                           tooth = value!;
//                         });
//                       },
//                       items:
//                           tooths.map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//                 //Treatment Type Drop Down
//                 Row(
//                   children: [
//                     const Text(
//                       'Type:',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const Spacer(),
//                     FutureBuilder<List<String>>(
//                       future: TreatmentType.getNames(),
//                       builder: ((context, snapshot) {
//                         if (snapshot.hasError) {
//                           return Text('somthing went wrong ${snapshot.error}');
//                         } else if (snapshot.hasData) {
//                           // type = snapshot.data!.first;
//                           return typeDropDown(snapshot.data!);
//                         } else {
//                           return const Text('loading...');
//                         }
//                       }),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: () async => Navigator.of(context).pop(),
//                   child: const Text('Cancle'),
//                 ),
//                 TextButton(
//                   onPressed: () async => Navigator.of(context).pop(),
//                   child: const Text('Save'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );

//   DropdownButton<String> typeDropDown(List<String> list) => DropdownButton(
//         value: type,
//         items: list.map(buildManuItem).toList(),
//         onChanged: (String? newVal) => setState(() => type = newVal!),
//       );

//   DropdownMenuItem<String> buildManuItem(String item) => DropdownMenuItem(
//         value: item,
//         child: Text(item),
//       );
}

class treatmentForm extends StatefulWidget {
  const treatmentForm({super.key});

  @override
  State<treatmentForm> createState() => _treatmentFormState();
}

class _treatmentFormState extends State<treatmentForm> {
  String tooth = '1';
  late final List<String> tooths;
  String? type;
  String? assistent;
  String? remarks;
  String? startTime;

  _treatmentFormState() {
    tooths = [];
    for (int i = 1; i <= 32; i++) {
      tooths.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          //Tooth number dropdown
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
              FutureBuilder<List<String>>(
                future: TreatmentType.getNames(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('somthing went wrong ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    var data = snapshot.data!;

                    return DropdownButton(
                      value: type,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: data.map((String items) {
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
                    );
                  } else {
                    return const Text('loading...');
                  }
                }),
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
              FutureBuilder<List<String>>(
                future: Assistant.getNames(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('somthing went wrong ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    var data = snapshot.data!;

                    return DropdownButton(
                      value: assistent,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: data.map((String items) {
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
                    );
                  } else {
                    return const Text('loading...');
                  }
                }),
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
                  onChanged: (String? newValue) {
                    setState(() {
                      remarks = newValue!;
                    });
                  },
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
                onPressed: () async => Navigator.of(context).pop(),
                // Add Save on DB
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
