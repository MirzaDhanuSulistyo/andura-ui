import 'package:flutter/material.dart';

import '../foundations/andura_tokens.dart';

class AnduraTextField extends StatelessWidget {
  const AnduraTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.autofocus = false,
    this.autocorrect = true,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.errorText,
    this.helperText,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool autofocus;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final String? errorText;
  final String? helperText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    obscureText: obscureText,
    autofocus: autofocus,
    autocorrect: autocorrect,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    textInputAction: textInputAction,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    enabled: enabled,
    readOnly: readOnly,
    maxLines: maxLines,
    minLines: minLines,
    maxLength: maxLength,
    decoration: InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      helperText: helperText,
    ),
  );
}

class AnduraTextArea extends StatelessWidget {
  const AnduraTextArea({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.minLines = 3,
    this.maxLines = 6,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) => AnduraTextField(
    controller: controller,
    hintText: hintText,
    labelText: labelText,
    errorText: errorText,
    onChanged: onChanged,
    minLines: minLines,
    maxLines: maxLines,
    enabled: enabled,
  );
}

class AnduraSelect<T> extends StatelessWidget {
  const AnduraSelect({
    super.key,
    required this.value,
    required this.items,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? labelText;
  final String? errorText;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<T>(
    initialValue: value,
    items: items,
    onChanged: enabled ? onChanged : null,
    decoration: InputDecoration(labelText: labelText, errorText: errorText),
  );
}

class AnduraPasswordField extends StatelessWidget {
  const AnduraPasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    this.hintText = 'Password',
    this.labelText,
    this.onChanged,
    this.onSubmitted,
    this.leadingActions = const [],
    this.autofocus = false,
  });

  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String hintText;
  final String? labelText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<Widget> leadingActions;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => AnduraTextField(
    controller: controller,
    obscureText: obscureText,
    autofocus: autofocus,
    hintText: hintText,
    labelText: labelText,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    suffixIcon: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...leadingActions,
        IconButton(
          tooltip: obscureText ? 'Show password' : 'Hide password',
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: onToggleVisibility,
        ),
      ],
    ),
  );
}

class AnduraChoiceRow<T> extends StatelessWidget {
  const AnduraChoiceRow({
    super.key,
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
    this.enabled = true,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) label;
  final ValueChanged<T> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final value in values) ...[
        Expanded(
          child: Semantics(
            button: true,
            enabled: enabled,
            selected: value == selected,
            label: label(value),
            child: InkWell(
              onTap: enabled ? () => onSelected(value) : null,
              borderRadius: BorderRadius.circular(AnduraRadii.md),
              child: AnimatedContainer(
                duration: AnduraMotion.fast,
                padding: const EdgeInsets.symmetric(vertical: AnduraSpacing.md),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: value == selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AnduraRadii.md),
                ),
                child: Text(
                  label(value),
                  style: AnduraTextStyles.label.copyWith(
                    color: value == selected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (value != values.last) const SizedBox(width: AnduraSpacing.md),
      ],
    ],
  );
}

class AnduraCheckOption extends StatelessWidget {
  const AnduraCheckOption({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: enabled ? () => onChanged(!value) : null,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AnduraTextStyles.label),
        AnimatedContainer(
          duration: AnduraMotion.fast,
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: value
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            shape: BoxShape.circle,
            border: value
                ? null
                : Border.all(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    width: 2,
                  ),
          ),
          child: value
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
        ),
      ],
    ),
  );
}

class AnduraSettingsTile extends StatelessWidget {
  const AnduraSettingsTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AnduraSpacing.md),
    child: Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AnduraRadii.lg),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AnduraRadii.lg),
        ),
        leading: DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(AnduraRadii.md),
          ),
          child: SizedBox.square(
            dimension: 42,
            child: Icon(icon, color: color),
          ),
        ),
        title: Text(title, style: AnduraTextStyles.label),
        trailing:
            trailing ??
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    ),
  );
}
