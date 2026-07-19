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
  var systemId = 'andura';

  ThemeData _theme(Brightness brightness) => systemId == 'andura'
      ? AnduraTheme.create(brightness)
      : AnduraTheme.forSystem(systemId, brightness);

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: _theme(Brightness.light),
    darkTheme: _theme(Brightness.dark),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    home: AnduraPage(
      title: 'Andura UI',
      actions: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: systemId,
            menuMaxHeight: 480,
            onChanged: (value) => setState(() => systemId = value!),
            items: [
              const DropdownMenuItem(
                value: 'andura',
                child: Text('Andura (legacy)'),
              ),
              for (final system in AnduraDesignSystems.all)
                DropdownMenuItem(value: system.id, child: Text(system.name)),
            ],
          ),
        ),
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
  final description = TextEditingController();
  var obscure = true;
  var checked = true;
  var choice = 0;
  String? selectValue = 'personal';
  var loading = false;

  @override
  void dispose() {
    password.dispose();
    description.dispose();
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
        labelText: 'Password',
        onToggleVisibility: () => setState(() => obscure = !obscure),
      ),
      const SizedBox(height: AnduraSpacing.md),
      AnduraTextArea(
        controller: description,
        labelText: 'Description',
        hintText: 'Tell us about your project',
        minLines: 3,
        maxLines: 5,
      ),
      const SizedBox(height: AnduraSpacing.md),
      AnduraSelect<String>(
        value: selectValue,
        labelText: 'Workspace type',
        items: const [
          DropdownMenuItem(value: 'personal', child: Text('Personal')),
          DropdownMenuItem(value: 'team', child: Text('Team')),
          DropdownMenuItem(value: 'enterprise', child: Text('Enterprise')),
        ],
        onChanged: (value) => setState(() => selectValue = value),
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
      AnduraButton(
        label: 'Primary action',
        loading: loading,
        onPressed: () async {
          setState(() => loading = true);
          await Future<void>.delayed(const Duration(milliseconds: 700));
          if (mounted) setState(() => loading = false);
        },
      ),
      const SizedBox(height: AnduraSpacing.md),
      AnduraButton(
        label: 'Secondary action',
        variant: AnduraButtonVariant.secondary,
        onPressed: () {},
      ),
      const SizedBox(height: AnduraSpacing.md),
      const AnduraBadge(label: 'Active'),
      const SizedBox(height: AnduraSpacing.md),
      Wrap(
        spacing: AnduraSpacing.md,
        runSpacing: AnduraSpacing.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const AnduraUserAvatar(name: 'Andura'),
          AnduraNotificationButton(
            hasNotification: checked,
            onPressed: () => setState(() => checked = false),
          ),
          OutlinedButton(
            onPressed: () => AnduraDialog.show<void>(
              context: context,
              title: const Text('Shared dialog'),
              content: const Text('Dialogs inherit the Andura theme.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
            child: const Text('Open dialog'),
          ),
        ],
      ),
      const SizedBox(height: AnduraSpacing.xl),
      const AnduraSectionHeader(title: 'States'),
      const SizedBox(height: AnduraSpacing.md),
      const AnduraTextField(
        labelText: 'Validation example',
        errorText: 'This field contains an example error.',
      ),
      const SizedBox(height: AnduraSpacing.md),
      const AnduraButton(label: 'Disabled action'),
      const SizedBox(height: AnduraSpacing.xl),
      const AnduraEmptyState(
        message: 'Empty and feedback states are reusable too.',
      ),
      const SizedBox(height: AnduraSpacing.xl),
      const AnduraSectionHeader(title: 'Open Design component coverage'),
      const SizedBox(height: AnduraSpacing.md),
      const AnduraAlert(
        title: 'Catalog ready',
        message: 'Shared components now consume contextual design tokens.',
        intent: AnduraIntent.success,
      ),
      const SizedBox(height: AnduraSpacing.md),
      AnduraSwitch(
        label: 'Theme-aware switch',
        value: checked,
        onChanged: (value) => setState(() => checked = value),
      ),
      AnduraTabs<int>(
        values: const [0, 1, 2],
        selected: choice,
        label: (value) => ['Overview', 'Tokens', 'Components'][value],
        onSelected: (value) => setState(() => choice = value),
      ),
      const SizedBox(height: AnduraSpacing.md),
      const Wrap(
        spacing: AnduraSpacing.sm,
        runSpacing: AnduraSpacing.sm,
        children: [
          AnduraChip(label: 'Badge / chip'),
          AnduraKeyboardKey(label: '⌘ K'),
          AnduraLink(
            label: 'Reference link',
            icon: Icons.arrow_forward,
            trailingIcon: true,
          ),
        ],
      ),
      const SizedBox(height: AnduraSpacing.md),
      const AnduraProgress(
        label: 'Catalog coverage',
        value: 1,
        showPercentage: true,
      ),
      const SizedBox(height: AnduraSpacing.md),
      const AnduraAccordion(
        title: Text('Portable component recipe'),
        child: Text(
          'The widget implementation is shared; the selected system supplies its visual tokens.',
        ),
      ),
    ],
  );
}
