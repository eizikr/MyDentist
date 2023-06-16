import 'package:flutter/material.dart';
import 'package:my_dentist/our_widgets/settings.dart';

class NumberSelectionDialog extends StatefulWidget {
  const NumberSelectionDialog({super.key});

  @override
  NumberSelectionDialogState createState() => NumberSelectionDialogState();
}

class NumberSelectionDialogState extends State<NumberSelectionDialog> {
  late int _selectedNumber = 0;

  List<Widget> _buildNumberButtons() {
    List<Widget> buttons = [];

    for (int i = 0; i <= 50; i += 5) {
      buttons.add(
        Expanded(
          child: RadioListTile<int>(
            value: i,
            groupValue: _selectedNumber,
            title: Text('$i%'),
            onChanged: (value) {
              setState(() {
                _selectedNumber = value!;
              });
            },
          ),
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Select Discount')),
      backgroundColor: OurSettings.mainColors[100],
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: _buildNumberButtons().sublist(0, 3),
            ),
            Row(
              children: _buildNumberButtons().sublist(3, 6),
            ),
            Row(
              children: _buildNumberButtons().sublist(6, 9),
            ),
            Row(
              children: _buildNumberButtons().sublist(9),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CALCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context, _selectedNumber);
          },
        ),
      ],
    );
  }
}
