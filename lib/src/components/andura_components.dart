import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../foundations/andura_colors.dart';
import '../foundations/andura_tokens.dart';

enum AnduraButtonVariant { primary, secondary, danger }

class AnduraButton extends StatelessWidget {
  const AnduraButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.variant = AnduraButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final AnduraButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final background = switch (variant) {
      AnduraButtonVariant.primary => colors.primary,
      AnduraButtonVariant.secondary => AnduraColors.mint,
      AnduraButtonVariant.danger => colors.error,
    };
    final content = loading
        ? const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AnduraSizes.icon),
                const SizedBox(width: AnduraSpacing.sm),
              ],
              Text(label),
            ],
          );
    final button = SizedBox(
      height: AnduraSizes.control,
      child: Semantics(
        button: true,
        enabled: !loading && onPressed != null,
        label: loading ? '$label, loading' : label,
        child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: background),
          child: content,
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class AnduraBadge extends StatelessWidget {
  const AnduraBadge({super.key, required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? Theme.of(context).colorScheme.primaryContainer;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AnduraRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AnduraSpacing.md,
          vertical: AnduraSpacing.xs,
        ),
        child: Text(
          label,
          style: AnduraTextStyles.caption.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AnduraDialog extends StatelessWidget {
  const AnduraDialog({super.key, this.title, this.content, this.actions});

  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) => showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) =>
        AnduraDialog(title: title, content: content, actions: actions),
  );

  @override
  Widget build(BuildContext context) =>
      AlertDialog(title: title, content: content, actions: actions);
}

class AnduraIconButton extends StatelessWidget {
  const AnduraIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: Icon(icon, color: color ?? Theme.of(context).colorScheme.onSurface),
    style: IconButton.styleFrom(
      minimumSize: const Size.square(AnduraSizes.minimumTapTarget),
      tapTargetSize: MaterialTapTargetSize.padded,
    ),
  );
}

class AnduraCard extends StatelessWidget {
  const AnduraCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: color ?? Theme.of(context).colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(AnduraRadii.lg),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AnduraSpacing.lg),
        child: child,
      ),
    ),
  );
}

class AnduraSectionHeader extends StatelessWidget {
  const AnduraSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: AnduraTextStyles.section),
      if (action != null)
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            padding: EdgeInsets.zero,
            minimumSize: const Size(44, 40),
          ),
          child: Text(action!),
        ),
    ],
  );
}

class AnduraEmptyState extends StatelessWidget {
  const AnduraEmptyState({super.key, required this.message, this.icon});

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AnduraSpacing.xxl),
    child: Column(
      children: [
        Icon(
          icon ?? Icons.inbox_outlined,
          size: 32,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: AnduraSpacing.md),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AnduraTextStyles.caption.copyWith(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class AnduraLoadingOverlay extends StatelessWidget {
  const AnduraLoadingOverlay({
    super.key,
    required this.loading,
    required this.child,
  });

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      if (loading)
        const Positioned.fill(
          child: ColoredBox(
            color: Color(0x66000000),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
    ],
  );
}

class AnduraUserAvatar extends StatelessWidget {
  const AnduraUserAvatar({
    super.key,
    this.name = '',
    this.image,
    this.radius = 20,
    this.onTap,
  });

  final String name;
  final Uint8List? image;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundImage: image == null ? null : MemoryImage(image!),
      child: image == null
          ? Text(
              initial,
              style: AnduraTextStyles.label.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: radius * .8,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
    );
    if (onTap == null) return avatar;
    return Semantics(
      button: true,
      label: 'Open profile',
      child: GestureDetector(onTap: onTap, child: avatar),
    );
  }
}

class AnduraNotificationButton extends StatelessWidget {
  const AnduraNotificationButton({
    super.key,
    this.onPressed,
    this.hasNotification = true,
  });

  final VoidCallback? onPressed;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      AnduraIconButton(
        icon: Icons.notifications_none,
        tooltip: 'Notifications',
        onPressed: onPressed,
      ),
      if (hasNotification)
        const Positioned(
          right: 9,
          top: 8,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AnduraColors.red,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: 8),
            ),
          ),
        ),
    ],
  );
}
