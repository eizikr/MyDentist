import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_dentist/apps/login/login_screen.dart';

void main() {
  group('LoginPage', () {
    testWidgets('Initial UI is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.text('My Dentist'), findsOneWidget);
      expect(find.text('Hey Doctor, Please Sign In!'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(RawMaterialButton), findsOneWidget);
    });
  });
}
