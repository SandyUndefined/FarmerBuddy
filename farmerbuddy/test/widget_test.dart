import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farmerbuddy/main.dart';

void main() {
  testWidgets('FarmerBuddy app renders Home Screen correctly',
      (WidgetTester tester) async {
    // Build the FarmerBuddy app and trigger a frame.
    await tester.pumpWidget(FarmerBuddyApp());

    // Verify that the Home screen contains "Welcome to FarmerBuddy!"
    expect(find.text('Welcome to FarmerBuddy!'), findsOneWidget);

    // Verify that the Home screen shows NPK cards or other widgets.
    expect(find.byType(Card), findsWidgets);

    // Verify that BottomNavigationBar is present.
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify BottomNavigationBar has Home and Weather tabs.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Weather'), findsOneWidget);
  });
}
