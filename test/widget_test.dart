// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cerrar_sesion/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Ensure secure storage is mocked for testing
    FlutterSecureStorage.setMockInitialValues({}); // This method is static and available in the package
    // But since I can't easily import the package here without modifying the test file imports
    // and ensuring it's available. 
    // Wait, I added the dependency, so it should be available.
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // Expect to see Login Screen
    expect(find.text('Login to App'), findsOneWidget);
    expect(find.text('0'), findsNothing);

    // Tap Login
    await tester.tap(find.text('Login to App'));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(seconds: 1)); // Wait for async operations if any (though ours are mostly sync dispatch except storage)
    
    // We might need to wait for the Future inside SessionService.login to complete and notify listeners.
    // The login method is async.
    await tester.pumpAndSettle();

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
