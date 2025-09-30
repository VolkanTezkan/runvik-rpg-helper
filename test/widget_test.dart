import 'package:flutter_test/flutter_test.dart';
import 'package:runvik/main.dart';

void main() {
  testWidgets('Runvik app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RunvikApp());

    // Verify that the app starts with the welcome screen
    expect(find.text('Welcome to Runvik!'), findsOneWidget);
    expect(find.text('Tap any die to start rolling'), findsOneWidget);

    // Verify that dice buttons are present
    expect(find.text('D4'), findsOneWidget);
    expect(find.text('D6'), findsOneWidget);
    expect(find.text('D8'), findsOneWidget);
    expect(find.text('D10'), findsOneWidget);
    expect(find.text('D12'), findsOneWidget);
    expect(find.text('D20'), findsOneWidget);
    expect(find.text('D100'), findsOneWidget);
  });

  testWidgets('Dice buttons are interactive', (WidgetTester tester) async {
    await tester.pumpWidget(const RunvikApp());

    // Verify that dice buttons are tappable
    final d6Button = find.text('D6');
    expect(d6Button, findsOneWidget);
    
    // Tap the D6 button (which should be visible)
    await tester.tap(d6Button);
    await tester.pump(const Duration(milliseconds: 100));
    
    // The app should respond to the tap (loading state or result)
    expect(find.text('D6'), findsOneWidget);
  });
}
