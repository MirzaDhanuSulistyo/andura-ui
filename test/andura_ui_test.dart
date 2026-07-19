import 'package:andura_ui/andura_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AnduraButton exposes its label and action', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AnduraTheme.light,
        home: Scaffold(
          body: AnduraButton(
            label: 'Continue',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    expect(pressed, isTrue);
  });

  testWidgets('AnduraButton replaces content while loading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AnduraTheme.light,
        home: const Scaffold(body: AnduraButton(label: 'Save', loading: true)),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);
  });
}
