import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_date_picker_bottom_sheet/app_date_picker_bottom_sheet.dart';

void main() {
  testWidgets('AppDatePickerBottomSheet displays title and selected date',
      (WidgetTester tester) async {
    final testDate = DateTime(2025, 5, 15);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDatePickerBottomSheet(
            initialDate: testDate,
            title: 'Choose Departure Date',
            confirmText: 'Select',
          ),
        ),
      ),
    );

    expect(find.text('Choose Departure Date'), findsOneWidget);
    expect(find.text('Select'), findsOneWidget);
    expect(find.text('May 2025'), findsOneWidget);
  });

  testWidgets('Selecting a date triggers onDateSelected callback',
      (WidgetTester tester) async {
    DateTime? selectedDate;
    final testDate = DateTime(2025, 5, 10);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDatePickerBottomSheet(
            initialDate: testDate,
            onDateSelected: (date) {
              selectedDate = date;
            },
          ),
        ),
      ),
    );

    // Tap on day 20
    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();

    // Tap Done
    await tester.ensureVisible(find.text('Done'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(selectedDate, isNotNull);
    expect(selectedDate?.day, 20);
    expect(selectedDate?.month, 5);
    expect(selectedDate?.year, 2025);
  });

  testWidgets('showAppDatePickerBottomSheet displays and returns chosen date',
      (WidgetTester tester) async {
    DateTime? returnedDate;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                returnedDate = await showAppDatePickerBottomSheet(
                  context: context,
                  initialDate: DateTime(2025, 6, 1),
                );
              },
              child: const Text('Open Picker'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Picker'));
    await tester.pumpAndSettle();

    expect(find.text('June 2025'), findsOneWidget);

    // Tap day 15
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    // Tap Done
    await tester.ensureVisible(find.text('Done'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(returnedDate, DateTime(2025, 6, 15));
  });
}
