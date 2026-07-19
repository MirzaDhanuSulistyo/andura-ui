import 'package:andura_ui/andura_ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ShowcaseApp());

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  var dark = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AnduraTheme.light,
    darkTheme: AnduraTheme.dark,
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    home: AnduraPage(
      title: 'Andura UI',
      actions: [
        IconButton(
          tooltip: 'Toggle theme',
          onPressed: () => setState(() => dark = !dark),
          icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
        ),
      ],
      child: const _Showcase(),
    ),
  );
}

class _Showcase extends StatefulWidget {
  const _Showcase();

  @override
  State<_Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<_Showcase> {
  final password = TextEditingController();
  var obscure = true;
  var checked = true;
  var choice = 0;

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const AnduraSectionHeader(title: 'Foundations'),
      const SizedBox(height: AnduraSpacing.md),
      const AnduraCard(
        child: Text(
          'Cards, controls, spacing, and typography share one theme.',
        ),
      ),
      const SizedBox(height: AnduraSpacing.xl),
      const AnduraSectionHeader(title: 'Forms'),
      const SizedBox(height: AnduraSpacing.md),
      AnduraPasswordField(
        controller: password,
        obscureText: obscure,
        onToggleVisibility: () => setState(() => obscure = !obscure),
      ),
      const SizedBox(height: AnduraSpacing.lg),
      AnduraChoiceRow<int>(
        values: const [0, 1, 2],
        selected: choice,
        label: (value) => ['One', 'Two', 'Three'][value],
        onSelected: (value) => setState(() => choice = value),
      ),
      const SizedBox(height: AnduraSpacing.lg),
      AnduraCheckOption(
        label: 'Enable option',
        value: checked,
        onChanged: (value) => setState(() => checked = value),
      ),
      const SizedBox(height: AnduraSpacing.xl),
      AnduraButton(label: 'Primary action', onPressed: () {}),
      const SizedBox(height: AnduraSpacing.md),
      AnduraButton(
        label: 'Secondary action',
        variant: AnduraButtonVariant.secondary,
        onPressed: () {},
      ),
      const SizedBox(height: AnduraSpacing.xl),
      const AnduraEmptyState(
        message: 'Empty and feedback states are reusable too.',
      ),
    ],
  );
}
