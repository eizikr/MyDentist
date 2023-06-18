import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_dentist/our_widgets/our_widgets.dart';

void main() {
  test('Check buildHoureItems Widget', () {
    // Empty list of items
    List<DateTime> emptyItems = [];
    expect(buildHoureItems(emptyItems).toString(), [].toString());

    // List with a single item
    List<DateTime> singleItem = [DateTime(2023, 6, 18, 9, 30)];
    List<DropdownMenuItem<DateTime>> expectedSingleItemResult = [
      DropdownMenuItem<DateTime>(
        value: DateTime(2023, 6, 18, 9, 30),
        child: const Text('09:30'),
      )
    ];
    expect(buildHoureItems(singleItem).toString(),
        expectedSingleItemResult.toString());

    // List with multiple items
    List<DateTime> multipleItems = [
      DateTime(2023, 6, 18, 9, 30),
      DateTime(2023, 6, 18, 13, 45),
      DateTime(2023, 6, 18, 18, 0)
    ];
    List<DropdownMenuItem<DateTime>> expectedMultipleItemsResult = [
      DropdownMenuItem<DateTime>(
        value: DateTime(2023, 6, 18, 9, 30),
        child: const Text('09:30'),
      ),
      DropdownMenuItem<DateTime>(
        value: DateTime(2023, 6, 18, 13, 45),
        child: const Text('13:45'),
      ),
      DropdownMenuItem<DateTime>(
        value: DateTime(2023, 6, 18, 18, 0),
        child: const Text('18:00'),
      )
    ];
    expect(buildHoureItems(multipleItems).toString(),
        expectedMultipleItemsResult.toString());

    // Add more test cases as needed
  });
}
