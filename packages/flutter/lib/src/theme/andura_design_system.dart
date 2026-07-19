import 'package:flutter/material.dart';

/// Brightness preferred by a design system's original canvas.
enum AnduraNativeBrightness { light, dark }

/// A portable, normalized representation of an Open Design system.
///
/// Colors are stored as ARGB integers so generated catalog entries remain
/// compile-time constants. Use [AnduraThemeTokens.fromSystem] in widgets.
@immutable
class AnduraDesignSystem {
  const AnduraDesignSystem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.nativeBrightness,
    required this.background,
    required this.surface,
    required this.surfaceWarm,
    required this.foreground,
    required this.foregroundSecondary,
    required this.muted,
    required this.border,
    required this.accent,
    required this.accentOn,
    required this.success,
    required this.warning,
    required this.danger,
    required this.fontDisplay,
    required this.fontBody,
    required this.textBase,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusPill,
    required this.space1,
    required this.space2,
    required this.space3,
    required this.space4,
    required this.space6,
    required this.space8,
    required this.motionFastMs,
    required this.motionBaseMs,
    required this.containerMax,
    required this.componentGroups,
    required this.sourceClassCount,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final AnduraNativeBrightness nativeBrightness;
  final int background;
  final int surface;
  final int surfaceWarm;
  final int foreground;
  final int foregroundSecondary;
  final int muted;
  final int border;
  final int accent;
  final int accentOn;
  final int success;
  final int warning;
  final int danger;
  final String fontDisplay;
  final String fontBody;
  final double textBase;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusPill;
  final double space1;
  final double space2;
  final double space3;
  final double space4;
  final double space6;
  final double space8;
  final int motionFastMs;
  final int motionBaseMs;
  final double containerMax;
  final List<String> componentGroups;
  final int sourceClassCount;
}

/// Contextual semantic values consumed by shared Andura components.
@immutable
class AnduraThemeTokens extends ThemeExtension<AnduraThemeTokens> {
  const AnduraThemeTokens({
    required this.systemId,
    required this.background,
    required this.surface,
    required this.surfaceWarm,
    required this.foreground,
    required this.foregroundSecondary,
    required this.muted,
    required this.border,
    required this.accent,
    required this.accentOn,
    required this.success,
    required this.warning,
    required this.danger,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusPill,
    required this.space1,
    required this.space2,
    required this.space3,
    required this.space4,
    required this.space6,
    required this.space8,
    required this.motionFast,
    required this.motionBase,
    required this.containerMax,
  });

  factory AnduraThemeTokens.fromSystem(AnduraDesignSystem system) =>
      AnduraThemeTokens(
        systemId: system.id,
        background: Color(system.background),
        surface: Color(system.surface),
        surfaceWarm: Color(system.surfaceWarm),
        foreground: Color(system.foreground),
        foregroundSecondary: Color(system.foregroundSecondary),
        muted: Color(system.muted),
        border: Color(system.border),
        accent: Color(system.accent),
        accentOn: Color(system.accentOn),
        success: Color(system.success),
        warning: Color(system.warning),
        danger: Color(system.danger),
        radiusSm: system.radiusSm,
        radiusMd: system.radiusMd,
        radiusLg: system.radiusLg,
        radiusPill: system.radiusPill,
        space1: system.space1,
        space2: system.space2,
        space3: system.space3,
        space4: system.space4,
        space6: system.space6,
        space8: system.space8,
        motionFast: Duration(milliseconds: system.motionFastMs),
        motionBase: Duration(milliseconds: system.motionBaseMs),
        containerMax: system.containerMax,
      );

  static AnduraThemeTokens of(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AnduraThemeTokens>();
    if (tokens != null) return tokens;

    // Keep components usable inside ordinary MaterialApp themes. This fallback
    // preserves compatibility for widget tests and hosts that adopt Andura
    // components before adopting an AnduraTheme.
    final scheme = theme.colorScheme;
    return AnduraThemeTokens(
      systemId: 'material-fallback',
      background: scheme.surface,
      surface: scheme.surfaceContainerLow,
      surfaceWarm: scheme.surfaceContainerHighest,
      foreground: scheme.onSurface,
      foregroundSecondary: scheme.onSurfaceVariant,
      muted: scheme.onSurfaceVariant,
      border: scheme.outlineVariant,
      accent: scheme.primary,
      accentOn: scheme.onPrimary,
      success: const Color(0xFF6BD4AE),
      warning: const Color(0xFFFECC30),
      danger: scheme.error,
      radiusSm: 10,
      radiusMd: 14,
      radiusLg: 16,
      radiusPill: 999,
      space1: 4,
      space2: 8,
      space3: 12,
      space4: 16,
      space6: 24,
      space8: 32,
      motionFast: const Duration(milliseconds: 150),
      motionBase: const Duration(milliseconds: 250),
      containerMax: 1200,
    );
  }

  final String systemId;
  final Color background;
  final Color surface;
  final Color surfaceWarm;
  final Color foreground;
  final Color foregroundSecondary;
  final Color muted;
  final Color border;
  final Color accent;
  final Color accentOn;
  final Color success;
  final Color warning;
  final Color danger;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusPill;
  final double space1;
  final double space2;
  final double space3;
  final double space4;
  final double space6;
  final double space8;
  final Duration motionFast;
  final Duration motionBase;
  final double containerMax;

  @override
  AnduraThemeTokens copyWith({
    String? systemId,
    Color? background,
    Color? surface,
    Color? surfaceWarm,
    Color? foreground,
    Color? foregroundSecondary,
    Color? muted,
    Color? border,
    Color? accent,
    Color? accentOn,
    Color? success,
    Color? warning,
    Color? danger,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusPill,
    double? space1,
    double? space2,
    double? space3,
    double? space4,
    double? space6,
    double? space8,
    Duration? motionFast,
    Duration? motionBase,
    double? containerMax,
  }) => AnduraThemeTokens(
    systemId: systemId ?? this.systemId,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceWarm: surfaceWarm ?? this.surfaceWarm,
    foreground: foreground ?? this.foreground,
    foregroundSecondary: foregroundSecondary ?? this.foregroundSecondary,
    muted: muted ?? this.muted,
    border: border ?? this.border,
    accent: accent ?? this.accent,
    accentOn: accentOn ?? this.accentOn,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    radiusSm: radiusSm ?? this.radiusSm,
    radiusMd: radiusMd ?? this.radiusMd,
    radiusLg: radiusLg ?? this.radiusLg,
    radiusPill: radiusPill ?? this.radiusPill,
    space1: space1 ?? this.space1,
    space2: space2 ?? this.space2,
    space3: space3 ?? this.space3,
    space4: space4 ?? this.space4,
    space6: space6 ?? this.space6,
    space8: space8 ?? this.space8,
    motionFast: motionFast ?? this.motionFast,
    motionBase: motionBase ?? this.motionBase,
    containerMax: containerMax ?? this.containerMax,
  );

  @override
  AnduraThemeTokens lerp(covariant AnduraThemeTokens? other, double t) {
    if (other == null) return this;
    double value(double a, double b) => a + (b - a) * t;
    int millis(Duration a, Duration b) =>
        value(a.inMilliseconds.toDouble(), b.inMilliseconds.toDouble()).round();
    return AnduraThemeTokens(
      systemId: t < .5 ? systemId : other.systemId,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceWarm: Color.lerp(surfaceWarm, other.surfaceWarm, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      foregroundSecondary: Color.lerp(
        foregroundSecondary,
        other.foregroundSecondary,
        t,
      )!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentOn: Color.lerp(accentOn, other.accentOn, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      radiusSm: value(radiusSm, other.radiusSm),
      radiusMd: value(radiusMd, other.radiusMd),
      radiusLg: value(radiusLg, other.radiusLg),
      radiusPill: value(radiusPill, other.radiusPill),
      space1: value(space1, other.space1),
      space2: value(space2, other.space2),
      space3: value(space3, other.space3),
      space4: value(space4, other.space4),
      space6: value(space6, other.space6),
      space8: value(space8, other.space8),
      motionFast: Duration(milliseconds: millis(motionFast, other.motionFast)),
      motionBase: Duration(milliseconds: millis(motionBase, other.motionBase)),
      containerMax: value(containerMax, other.containerMax),
    );
  }
}
