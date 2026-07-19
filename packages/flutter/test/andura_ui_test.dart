import 'package:andura_ui/andura_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Open Design catalog exposes every imported system', () {
    expect(AnduraDesignSystems.all, hasLength(151));
    expect(AnduraDesignSystems.byId('linear-app').name, 'Linear');
    expect(AnduraDesignSystems.byId('missing').id, 'default');
  });

  test('catalog themes install contextual semantic tokens', () {
    final theme = AnduraTheme.forSystem('airbnb', Brightness.light);
    final tokens = theme.extension<AnduraThemeTokens>();
    expect(tokens, isNotNull);
    expect(tokens!.systemId, 'airbnb');
    expect(theme.colorScheme.primary, tokens.accent);
  });

  testWidgets('components support ordinary Material themes', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AnduraCard(child: Text('Material host'))),
      ),
    );

    expect(find.text('Material host'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

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

  testWidgets('AnduraTextArea renders multiline input and errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AnduraTheme.light,
        home: const Scaffold(
          body: AnduraTextArea(
            labelText: 'Description',
            errorText: 'Description is required',
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Description is required'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).minLines, 3);
    expect(tester.widget<TextField>(find.byType(TextField)).maxLines, 6);
  });

  testWidgets('AnduraSelect exposes its options and selection callback', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        theme: AnduraTheme.light,
        home: Scaffold(
          body: AnduraSelect<String>(
            value: 'one',
            labelText: 'Choice',
            items: const [
              DropdownMenuItem(value: 'one', child: Text('One')),
              DropdownMenuItem(value: 'two', child: Text('Two')),
            ],
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    expect(find.text('Two'), findsOneWidget);

    await tester.tap(find.text('Two').last);
    await tester.pumpAndSettle();
    expect(selected, 'two');
  });

  testWidgets('AnduraDialog opens with title, content, and actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AnduraTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => AnduraDialog.show<void>(
                context: context,
                title: const Text('Delete item'),
                content: const Text('This cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Delete item'), findsOneWidget);
    expect(find.text('This cannot be undone.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('disabled choice and check controls do not invoke callbacks', (
    tester,
  ) async {
    var choiceChanged = false;
    var checkChanged = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AnduraTheme.light,
        home: Scaffold(
          body: Column(
            children: [
              AnduraChoiceRow<int>(
                values: const [1, 2],
                selected: 1,
                label: (value) => '$value',
                enabled: false,
                onSelected: (_) => choiceChanged = true,
              ),
              AnduraCheckOption(
                label: 'Option',
                value: false,
                enabled: false,
                onChanged: (_) => checkChanged = true,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('2'));
    await tester.tap(find.text('Option'));
    expect(choiceChanged, isFalse);
    expect(checkChanged, isFalse);
  });

  testWidgets('extended components consume selected design tokens', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AnduraTheme.forSystem('linear-app', Brightness.dark),
        home: const Scaffold(
          body: Column(
            children: [
              AnduraAlert(message: 'Saved', intent: AnduraIntent.success),
              AnduraKeyboardKey(label: '⌘ K'),
              AnduraProgress(value: .5, showPercentage: true),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('⌘ K'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(
      Theme.of(
        tester.element(find.text('Saved')),
      ).extension<AnduraThemeTokens>()?.systemId,
      'linear-app',
    );
  });

  testWidgets('AnduraBadge renders its label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AnduraTheme.light,
        home: const Scaffold(body: AnduraBadge(label: 'Active')),
      ),
    );

    expect(find.text('Active'), findsOneWidget);
    expect(find.byType(DecoratedBox), findsOneWidget);
  });
}
