import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_dentist/our_widgets/settings.dart';

bool isPatientExists(String id) {
  DocumentSnapshot<Map<String, dynamic>> document = (FirebaseFirestore.instance
      .collection('Patients')
      .get()) as DocumentSnapshot<Map<String, dynamic>>;
  if (document.exists) return true;
  return false;
}

Future<bool?> errorToast(String myMsg) {
  return Fluttertoast.showToast(
    msg: myMsg,
    gravity: ToastGravity.TOP,
    fontSize: 10.0,
    webShowClose: true,
    backgroundColor: Colors.red,
    toastLength: Toast.LENGTH_LONG,
    webPosition: "center",
    webBgColor: "red",
    timeInSecForIosWeb: 2,
  );
}

Future<bool?> successToast(String myMsg) {
  return Fluttertoast.showToast(
    msg: myMsg,
    gravity: ToastGravity.TOP,
    fontSize: 10.0,
    webShowClose: true,
    backgroundColor: Colors.black,
    toastLength: Toast.LENGTH_LONG,
    webPosition: "center",
    webBgColor: "linear-gradient(to right, #00b09b, #96c93d)",
    timeInSecForIosWeb: 2,
  );
}

String capitalizeFirstCharacter(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

String isPasswordValid(String password) {
  late bool isValid;

  bool hasCharacter(String input) {
    return input.isNotEmpty && input.contains(RegExp(r'[a-zA-Z]'));
  }

  bool hasLowerAndUpperCase(String input, {bool hasSpacial = true}) {
    bool hasLower = false;
    bool hasUpper = false;

    for (int i = 0; i < input.length; i++) {
      if (input[i].toUpperCase() == input[i]) {
        hasUpper = true;
      }
      if (input[i].toLowerCase() == input[i]) {
        hasLower = true;
      }
      if (hasSpacial == false &&
          input[i].contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasLower = true;
      }
    }
    return hasLower && hasUpper && hasSpacial;
  }

  switch (OurSettings.passwordStrengh) {
    case PasswordStrengh.low:
      isValid = password.length >= 6;
      return !isValid ? "Minimum 6 characters long" : "valid";
    case PasswordStrengh.fair:
      isValid = password.length >= 8 && hasCharacter(password);
      return !isValid ? "Minimum 8 characters long and 1 letter" : "valid";
    case PasswordStrengh.good:
      isValid = password.length >= 8 && hasLowerAndUpperCase(password);

      return !isValid
          ? "Minimum 8 characters long ,1 lowercase, 1 upercase"
          : "valid";
    case PasswordStrengh.excellent:
      isValid = password.length >= 8 && hasCharacter(password);
      return !isValid
          ? "Minimum 8 characters long ,1 lowercase, 1 upercase, 1 spacial"
          : "valid";
    default:
      return "valid";
  }
}

void confirmationDialog(BuildContext context, Function func) async {
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
                  ),
                ),
                TextButton(
                  onPressed: () => func(),
                  child: const Text(
                    'Yes',
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

List<DropdownMenuItem<DateTime>> buildHoureItems(List<DateTime> items) {
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

void showSuccessDialog(BuildContext context, {String msg = ''}) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 10.0),
              Text(msg),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
