import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget entryField({
  required String title,
  required TextEditingController controller,
  required bool isRequired,
  bool numerical = false,
}) {
  return TextFormField(
    keyboardType: numerical ? TextInputType.number : null,
    inputFormatters: numerical
        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
        : null,
    controller: controller,
    decoration: InputDecoration(
      labelText: title,
      icon: isRequired
          ? const Icon(Icons.info_outlined)
          : const Icon(Icons.circle_outlined),
      border: const OutlineInputBorder(),
    ),
    onChanged: (value) {},
    validator: (val) {
      if (isRequired && (val == null || val.isEmpty)) {
        return "Please enter $title!${numerical ? ' (Only Digits)' : ''}";
      }
      return null;
    },
    autovalidateMode: AutovalidateMode.onUserInteraction,
  );
}

String getAge(String dateString) {
  List<String> ymd = dateString.split('-');
  int year = int.parse(ymd[0]),
      month = int.parse(ymd[1]),
      day = int.parse(ymd[2]);
  DateTime birthday = DateTime(year, month, day);
  DateDuration age = AgeCalculator.age(birthday);
  return '${age.years}.${age.months}';
}
