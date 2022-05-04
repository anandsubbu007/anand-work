// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: prefer_const_constructors

import 'package:demoapp/BlocMethod/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// // ignore: import_of_legacy_library_into_null_safe
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('User Fetching on Scroll', () {
    testWidgets('Counter increments smoke test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      final listType = find.byType(ListView);
      await Future.delayed(Duration(milliseconds: 100));

      final listViewLen = tester.widgetList<ListView>(listType).length;
      expect(listViewLen == 0, false);
      // final ctrl = listView.controller;
      // final offset = ctrl?.offset ?? 300;
      // tester.drag(listType, Offset(0.0, offset));
      // ignore: avoid_print
      // print(offset);
      // expect(find.text('1'), findsNothing);
      // Tap the '+' icon and trigger a frame.
      // await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      // expect(find.text('0'), findsNothing);
      // expect(find.text('1'), findsOneWidget);
    });
  });
}
