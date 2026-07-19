import 'package:flutter/material.dart';

import '../foundations/andura_tokens.dart';

/// Standard responsive page shell. Product screens provide only their content.
class AnduraPage extends StatelessWidget {
  const AnduraPage({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.leading,
    this.padding = AnduraSpacing.page,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.scrollable = true,
    this.safeBottom = false,
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final EdgeInsetsGeometry padding;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool scrollable;
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
    final content = scrollable
        ? ListView(padding: padding, children: [child])
        : Padding(padding: padding, child: child);
    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(title: Text(title!), actions: actions, leading: leading),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(bottom: safeBottom, child: content),
    );
  }
}

class AnduraSearchField extends StatelessWidget {
  const AnduraSearchField({
    super.key,
    this.hint = 'Search',
    this.onChanged,
    this.filterTooltip = 'Filter',
    this.onFilter,
  });

  final String hint;
  final ValueChanged<String>? onChanged;
  final String filterTooltip;
  final VoidCallback? onFilter;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
    if (onFilter == null) return field;
    return Row(
      children: [
        Expanded(child: field),
        const SizedBox(width: AnduraSpacing.md),
        SizedBox.square(
          dimension: 52,
          child: IconButton.filled(
            tooltip: filterTooltip,
            onPressed: onFilter,
            icon: const Icon(Icons.tune),
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AnduraRadii.md),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnduraErrorText extends StatelessWidget {
  const AnduraErrorText(this.message, {super.key, this.textAlign});

  final String message;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => Text(
    message,
    textAlign: textAlign,
    style: Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
  );
}
