import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_dentist/modules/meeting.dart';
import 'package:my_dentist/modules/treatments.dart';
import 'package:my_dentist/our_widgets/buttons.dart';
import 'package:my_dentist/apps/payment/discount_dialog.dart';
import 'package:my_dentist/our_widgets/global.dart';
import 'package:my_dentist/our_widgets/loading_page.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class TreatmentCare extends StatefulWidget {
  final Map<String, dynamic> meeting;
  final String patientId;
  const TreatmentCare(
      {super.key, required this.meeting, required this.patientId});

  @override
  State<TreatmentCare> createState() => _TreatmentCareState();
}

class _TreatmentCareState extends State<TreatmentCare> {
  TextEditingController summaryController = TextEditingController();
  TextEditingController perscriptionController = TextEditingController();

  late Map<String, dynamic> meeting;
  List<Icon> icons = [const Icon(Icons.done), const Icon(Icons.cancel)];
  late int _discount;
  late double _cost;
  late Icon icon;
  late int iconIndex;
  late List<String> toolTips = ['Finish treatment', 'Bring treatment back'];

  final DB db = Get.find();
  EncryptData crypto = Get.find();

  late CollectionReference patient;
  void changeDoneIcon() {
    setState(() {
      iconIndex = (iconIndex + 1) % 2;
    });
  }

  @override
  void initState() {
    meeting = widget.meeting;
    if (meeting['treatment']['isDone']) {
      iconIndex = 1;
    } else {
      iconIndex = 0;
    }
    icon = icons[iconIndex];
    patient = db.patients;
    summaryController.text = meeting['summary'];
    perscriptionController.text = meeting['treatment']['perscription'];

    _discount = meeting['treatment']['discount'];
    _cost = meeting['treatment']['cost'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          title: 'Treatment',
          child: const Text('Treatment'),
        ),
        centerTitle: true,
        backgroundColor: OurSettings.appbarColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'Exit',
        ),
        actions: [
          IconButton(
              onPressed: () {
                confirmationDialog(
                  context,
                  () {
                    changeDoneIcon();
                    changeMeetingStatus(meeting, iconIndex == 1 ? true : false);
                    Navigator.of(context).pop();
                  },
                );
              },
              tooltip: toolTips[iconIndex],
              icon: icons[iconIndex]),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: patient.doc(widget.patientId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return treatmentPage(data);
          }
          return loadingCircule('Loading treatment page...');
        },
      ),
    );
  }

  Widget treatmentPage(Map<String, dynamic> data) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: ourBoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      patientInfoItem(
                          'First Name: ${crypto.decryptAES(data['first_name'])}'),
                      patientInfoItem(
                          'Last Name: ${crypto.decryptAES(data['last_name'])}'),
                      patientInfoItem('ID: ${crypto.decryptAES(data['id'])}'),
                      patientInfoItem(
                          'Gender: ${crypto.decryptAES(data['gender'])}'),
                      patientInfoItem('Age: ${crypto.decryptAES(data['age'])}'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: ourBoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: meetingInfoItem(
                        'Treatment type: ${meeting['treatment']['treatmentType']['name']}'),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: meetingInfoItem(
                              'From: ${DateFormat("yyyy-MM-dd hh:mm").format(meeting['from'].toDate())}'),
                        ),
                        Expanded(
                          child: meetingInfoItem(
                              'To: ${DateFormat("yyyy-MM-dd hh:mm").format(meeting['to'].toDate())}'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        const Text(
                          'Summary',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[200], // set the background color here
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextField(
                            readOnly:
                                meeting['treatment']['isDone'] ? true : false,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              hintText: 'Meeting Summary',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                            controller: summaryController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        const Text(
                          'Medicent',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[200], // set the background color here
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextField(
                            readOnly:
                                meeting['treatment']['isDone'] ? true : false,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Meeting Summary',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                            controller: perscriptionController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: BasicButton(
                              onClicked: () async {
                                int? discount = (await openDiscountDialog());
                                if (discount != null) {
                                  setState(() {
                                    _discount = discount;
                                    _cost = meeting['treatment']
                                            ['originalCost'] -
                                        (meeting['treatment']['originalCost'] *
                                            (_discount * 0.01));
                                  });
                                }
                              },
                              text: 'Discount',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: BasicButton(
                              onClicked: () {},
                              text: 'Print Summary',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: BasicButton(
                              onClicked: () async {
                                await Meeting.updateSummary(
                                  meeting['id'],
                                  summaryController.text,
                                );
                                await Meeting.updatePerscription(
                                  meeting['id'],
                                  perscriptionController.text,
                                );
                                await Treatment.updateDiscount(
                                  meeting['id'],
                                  _discount,
                                );
                                void contextCare() {
                                  Navigator.pop(context);
                                }

                                contextCare();
                              },
                              text: 'Save Summary',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
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
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: priceInfoItem('Discount: $_discount%'),
                    ),
                    Expanded(
                      child: _discount == 0
                          ? priceInfoItem(
                              'Price: ${meeting['treatment']['originalCost']}')
                          : newPriceInfoItem(
                              meeting['treatment']['originalCost'],
                              _cost,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> openDiscountDialog() => showDialog(
        context: context,
        builder: (context) => const NumberSelectionDialog(),
      );
}

Widget patientInfoItem(String str) {
  return Expanded(
    child: Text(
      str,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20),
    ),
  );
}

Widget meetingInfoItem(String str) {
  return Text(
    str,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 17),
  );
}

Widget priceInfoItem(String str) {
  return Text(
    str,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
  );
}

Widget newPriceInfoItem(double originalPrice, double newPrice) {
  return RichText(
    text: TextSpan(
      text: "Price: ${newPrice.toString()} ",
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
      children: <TextSpan>[
        TextSpan(
          text: originalPrice.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    ),
  );
}
