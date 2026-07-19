import 'package:flutter/material.dart';

import '../theme/andura_design_system.dart';

/// Semantic intent shared by status-oriented components.
enum AnduraIntent { neutral, info, success, warning, danger }

Color _intentColor(BuildContext context, AnduraIntent intent) {
  final tokens = AnduraThemeTokens.of(context);
  return switch (intent) {
    AnduraIntent.neutral => tokens.muted,
    AnduraIntent.info => tokens.accent,
    AnduraIntent.success => tokens.success,
    AnduraIntent.warning => tokens.warning,
    AnduraIntent.danger => tokens.danger,
  };
}

/// Accessible inline link with optional leading or trailing icon.
class AnduraLink extends StatelessWidget {
  const AnduraLink({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool trailingIcon;

  @override
  Widget build(BuildContext context) => Semantics(
    link: true,
    enabled: onPressed != null,
    child: TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && !trailingIcon) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 8),
          ],
          Text(label),
          if (icon != null && trailingIcon) ...[
            const SizedBox(width: 8),
            Icon(icon, size: 16),
          ],
        ],
      ),
    ),
  );
}

/// Keyboard shortcut presentation used by menus and command palettes.
class AnduraKeyboardKey extends StatelessWidget {
  const AnduraKeyboardKey({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = AnduraThemeTokens.of(context);
    return Semantics(
      label: 'Keyboard key $label',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.surfaceWarm,
          border: Border.all(color: tokens.border),
          borderRadius: BorderRadius.circular(tokens.radiusSm),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: tokens.space2,
            vertical: tokens.space1,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontFamily: 'monospace',
              color: tokens.foregroundSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class AnduraChip extends StatelessWidget {
  const AnduraChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.onDeleted,
    this.avatar,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onDeleted;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) => FilterChip(
    label: Text(label),
    selected: selected,
    onSelected: onSelected,
    onDeleted: onDeleted,
    avatar: avatar,
  );
}

class AnduraAlert extends StatelessWidget {
  const AnduraAlert({
    super.key,
    required this.message,
    this.title,
    this.intent = AnduraIntent.info,
    this.action,
    this.onDismiss,
  });

  final String? title;
  final String message;
  final AnduraIntent intent;
  final Widget? action;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final tokens = AnduraThemeTokens.of(context);
    final color = _intentColor(context, intent);
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.alphaBlend(color.withValues(alpha: .1), tokens.surface),
          border: Border.all(color: color.withValues(alpha: .5)),
          borderRadius: BorderRadius.circular(tokens.radiusMd),
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.space4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_icon, color: color),
              SizedBox(width: tokens.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    if (title != null) SizedBox(height: tokens.space1),
                    Text(message),
                    if (action != null) ...[
                      SizedBox(height: tokens.space2),
                      action!,
                    ],
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  tooltip: 'Dismiss',
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _icon => switch (intent) {
    AnduraIntent.neutral => Icons.info_outline,
    AnduraIntent.info => Icons.info_outline,
    AnduraIntent.success => Icons.check_circle_outline,
    AnduraIntent.warning => Icons.warning_amber,
    AnduraIntent.danger => Icons.error_outline,
  };
}

class AnduraSwitch extends StatelessWidget {
  const AnduraSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => SwitchListTile.adaptive(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: subtitle == null ? null : Text(subtitle!),
    value: value,
    onChanged: enabled ? onChanged : null,
  );
}

class AnduraCheckbox extends StatelessWidget {
  const AnduraCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
    this.tristate = false,
  });

  final String label;
  final String? subtitle;
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final bool enabled;
  final bool tristate;

  @override
  Widget build(BuildContext context) => CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    title: Text(label),
    subtitle: subtitle == null ? null : Text(subtitle!),
    value: value,
    tristate: tristate,
    onChanged: enabled ? onChanged : null,
  );
}

class AnduraRadio<T> extends StatelessWidget {
  const AnduraRadio({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => RadioGroup<T>(
    groupValue: groupValue,
    onChanged: enabled ? onChanged : (_) {},
    child: RadioListTile<T>(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      enabled: enabled,
    ),
  );
}

class AnduraTabs<T> extends StatelessWidget {
  const AnduraTabs({
    super.key,
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => SegmentedButton<T>(
    segments: [
      for (final value in values)
        ButtonSegment<T>(value: value, label: Text(label(value))),
    ],
    selected: {selected},
    onSelectionChanged: (selection) => onSelected(selection.first),
  );
}

class AnduraProgress extends StatelessWidget {
  const AnduraProgress({
    super.key,
    this.value,
    this.label,
    this.showPercentage = false,
  });

  final double? value;
  final String? label;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    value: value == null ? null : '${(value!.clamp(0, 1) * 100).round()}%',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercentage)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null) Text(label!),
              if (showPercentage && value != null)
                Text('${(value!.clamp(0, 1) * 100).round()}%'),
            ],
          ),
        if (label != null || showPercentage) const SizedBox(height: 8),
        LinearProgressIndicator(value: value),
      ],
    ),
  );
}

class AnduraSkeleton extends StatelessWidget {
  const AnduraSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.circular = false,
  });

  final double width;
  final double height;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final tokens = AnduraThemeTokens.of(context);
    return Semantics(
      label: 'Loading',
      child: ExcludeSemantics(
        child: SizedBox(
          width: circular ? height : width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.muted.withValues(alpha: .18),
              shape: circular ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: circular
                  ? null
                  : BorderRadius.circular(tokens.radiusSm),
            ),
          ),
        ),
      ),
    );
  }
}

class AnduraAccordion extends StatelessWidget {
  const AnduraAccordion({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  final Widget title;
  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    initiallyExpanded: initiallyExpanded,
    tilePadding: EdgeInsets.zero,
    childrenPadding: const EdgeInsets.only(bottom: 16),
    title: title,
    children: [Align(alignment: Alignment.centerLeft, child: child)],
  );
}

class AnduraStat extends StatelessWidget {
  const AnduraStat({
    super.key,
    required this.label,
    required this.value,
    this.change,
    this.intent = AnduraIntent.neutral,
  });

  final String label;
  final String value;
  final String? change;
  final AnduraIntent intent;

  @override
  Widget build(BuildContext context) {
    final tokens = AnduraThemeTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: tokens.muted),
        ),
        SizedBox(height: tokens.space1),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        if (change != null) ...[
          SizedBox(height: tokens.space1),
          Text(change!, style: TextStyle(color: _intentColor(context, intent))),
        ],
      ],
    );
  }
}

class AnduraListItem extends StatelessWidget {
  const AnduraListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: title,
    subtitle: subtitle,
    leading: leading,
    trailing: trailing,
    onTap: onTap,
  );
}

class AnduraMenuButton<T> extends StatelessWidget {
  const AnduraMenuButton({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.icon = Icons.more_vert,
    this.tooltip = 'More actions',
  });

  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T> onSelected;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) => PopupMenuButton<T>(
    tooltip: tooltip,
    icon: Icon(icon),
    onSelected: onSelected,
    itemBuilder: (_) => [
      for (final item in items)
        PopupMenuItem<T>(value: item, child: Text(itemLabel(item))),
    ],
  );
}

abstract final class AnduraBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool showDragHandle = true,
  }) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    showDragHandle: showDragHandle,
    builder: builder,
  );
}

class AnduraResponsiveContainer extends StatelessWidget {
  const AnduraResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final tokens = AnduraThemeTokens.of(context);
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: tokens.containerMax),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: tokens.space4),
          child: child,
        ),
      ),
    );
  }
}

class AnduraResponsiveGrid extends StatelessWidget {
  const AnduraResponsiveGrid({
    super.key,
    required this.children,
    this.minimumItemWidth = 240,
    this.spacing,
    this.childAspectRatio = 1,
  });

  final List<Widget> children;
  final double minimumItemWidth;
  final double? spacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    final tokens = AnduraThemeTokens.of(context);
    final gap = spacing ?? tokens.space4;
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = ((constraints.maxWidth + gap) / (minimumItemWidth + gap))
            .floor()
            .clamp(1, children.length);
        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: gap,
          crossAxisSpacing: gap,
          childAspectRatio: childAspectRatio,
          children: children,
        );
      },
    );
  }
}

class AnduraDivider extends StatelessWidget {
  const AnduraDivider({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    if (label == null) return const Divider();
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label!, style: Theme.of(context).textTheme.labelSmall),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
