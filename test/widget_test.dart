// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alarm_clock_app/main.dart';

void main() {
  testWidgets('Smart Alarm Clock app loads correctly', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AlarmClockApp());

    // Verify that the app loads with the correct title.
    expect(find.text('Smart Alarm Clock'), findsOneWidget);

    // Verify that the theme toggle button is present.
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });
}
