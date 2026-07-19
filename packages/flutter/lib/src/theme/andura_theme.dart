import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../foundations/andura_colors.dart';
import '../foundations/andura_tokens.dart';
import 'andura_design_system.dart';
import 'generated_design_systems.dart';

/// Andura themes plus the complete imported Open Design theme catalog.
abstract final class AnduraTheme {
  /// Controls whether Google Fonts may fetch Poppins at runtime.
  /// Disable this when the host application bundles the font assets.
  static void configureFonts({required bool allowRuntimeFetching}) {
    GoogleFonts.config.allowRuntimeFetching = allowRuntimeFetching;
  }

  /// Backwards-compatible Andura themes used by existing applications.
  static ThemeData get light => create(Brightness.light);
  static ThemeData get dark => create(Brightness.dark);

  /// Creates one of the 151 imported Open Design systems by ID.
  ///
  /// When [brightness] differs from the system's native canvas, Material
  /// derives accessible surfaces while retaining its identity accent.
  static ThemeData forSystem(String id, [Brightness? brightness]) =>
      fromSystem(AnduraDesignSystems.byId(id), brightness);

  /// Creates a Material theme from a bundled or app-local design system.
  ///
  /// This is additive to [forSystem]: custom systems do not need to be added to
  /// Andura's generated catalog.
  static ThemeData fromSystem(
    AnduraDesignSystem system, [
    Brightness? brightness,
  ]) {
    final preferred = system.nativeBrightness == AnduraNativeBrightness.dark
        ? Brightness.dark
        : Brightness.light;
    return _createSystem(system, brightness ?? preferred);
  }

  /// Creates the original Andura theme. Kept stable for KeyNest and other
  /// existing consumers.
  static ThemeData create(Brightness brightness, {Color? seedColor}) {
    final isDark = brightness == Brightness.dark;
    final primary = seedColor ?? AnduraColors.primary;
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      surface: isDark ? const Color(0xFF121218) : AnduraColors.scaffold,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
    );
    final text = GoogleFonts.poppinsTextTheme(
      base.textTheme,
    ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
    final themedText = text.copyWith(
      titleLarge: text.titleLarge?.merge(AnduraTextStyles.title),
      titleMedium: text.titleMedium?.merge(AnduraTextStyles.section),
      labelLarge: text.labelLarge?.merge(AnduraTextStyles.label),
      bodySmall: text.bodySmall?.merge(AnduraTextStyles.caption),
    );
    final tokens = AnduraThemeTokens(
      systemId: 'andura',
      background: scheme.surface,
      surface: scheme.surfaceContainerLow,
      surfaceWarm: scheme.surfaceContainerHighest,
      foreground: scheme.onSurface,
      foregroundSecondary: scheme.onSurfaceVariant,
      muted: scheme.onSurfaceVariant,
      border: scheme.outlineVariant,
      accent: primary,
      accentOn: scheme.onPrimary,
      success: AnduraColors.success,
      warning: AnduraColors.warning,
      danger: AnduraColors.danger,
      radiusSm: AnduraRadii.sm,
      radiusMd: AnduraRadii.md,
      radiusLg: AnduraRadii.lg,
      radiusPill: AnduraRadii.pill,
      space1: AnduraSpacing.xs,
      space2: AnduraSpacing.sm,
      space3: AnduraSpacing.md,
      space4: AnduraSpacing.lg,
      space6: AnduraSpacing.xl,
      space8: AnduraSpacing.xxl,
      motionFast: AnduraMotion.fast,
      motionBase: AnduraMotion.standard,
      containerMax: AnduraLayout.maxContentWidth,
    );
    return _finishTheme(base, themedText, tokens, isDark);
  }

  static ThemeData _createSystem(
    AnduraDesignSystem system,
    Brightness brightness,
  ) {
    final native = system.nativeBrightness == AnduraNativeBrightness.dark
        ? Brightness.dark
        : Brightness.light;
    final accent = Color(system.accent);
    final derived = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
    );
    final useSourceSurfaces = native == brightness;
    final surface = useSourceSurfaces
        ? Color(system.background)
        : derived.surface;
    final onSurface = useSourceSurfaces
        ? Color(system.foreground)
        : derived.onSurface;
    final sourceTokens = AnduraThemeTokens.fromSystem(system);
    final tokens = sourceTokens.copyWith(
      background: surface,
      surface: useSourceSurfaces
          ? Color(system.surface)
          : derived.surfaceContainerLow,
      surfaceWarm: useSourceSurfaces
          ? Color(system.surfaceWarm)
          : derived.surfaceContainerHighest,
      foreground: onSurface,
      foregroundSecondary: useSourceSurfaces
          ? Color(system.foregroundSecondary)
          : derived.onSurfaceVariant,
      muted: useSourceSurfaces ? Color(system.muted) : derived.onSurfaceVariant,
      border: useSourceSurfaces ? Color(system.border) : derived.outlineVariant,
    );
    final scheme = derived.copyWith(
      primary: accent,
      onPrimary: Color(system.accentOn),
      surface: tokens.background,
      onSurface: tokens.foreground,
      error: Color(system.danger),
      outline: tokens.border,
      outlineVariant: tokens.border,
      surfaceContainerLow: tokens.surface,
      surfaceContainerHighest: tokens.surfaceWarm,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: tokens.background,
    );
    final text = base.textTheme
        .apply(
          fontFamily: system.fontBody,
          bodyColor: tokens.foreground,
          displayColor: tokens.foreground,
        )
        .copyWith(
          displayLarge: base.textTheme.displayLarge?.copyWith(
            fontFamily: system.fontDisplay,
          ),
          headlineLarge: base.textTheme.headlineLarge?.copyWith(
            fontFamily: system.fontDisplay,
          ),
          bodyMedium: base.textTheme.bodyMedium?.copyWith(
            fontSize: system.textBase,
            fontFamily: system.fontBody,
          ),
        );
    return _finishTheme(base, text, tokens, brightness == Brightness.dark);
  }

  static ThemeData _finishTheme(
    ThemeData base,
    TextTheme text,
    AnduraThemeTokens tokens,
    bool isDark,
  ) {
    final legacy = tokens.systemId == 'andura';
    final themedText = text.copyWith(
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
    final mediumShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(tokens.radiusMd),
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(tokens.radiusMd),
      borderSide: legacy ? BorderSide.none : BorderSide(color: tokens.border),
    );
    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[tokens],
      textTheme: themedText,
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.background,
        foregroundColor: tokens.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: themedText.titleLarge?.copyWith(
          color: tokens.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.accent,
          foregroundColor: tokens.accentOn,
          elevation: 0,
          minimumSize: const Size.fromHeight(AnduraSizes.control),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radiusPill),
          ),
          textStyle: themedText.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.surface,
        elevation: AnduraElevation.card,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusLg),
          side: legacy ? BorderSide.none : BorderSide(color: tokens.border),
        ),
      ),
      dialogTheme: legacy
          ? base.dialogTheme
          : DialogThemeData(shape: mediumShape),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tokens.surface,
        modalBackgroundColor: tokens.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(legacy ? AnduraRadii.sheet : tokens.radiusLg),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: tokens.surfaceWarm,
        contentTextStyle: themedText.bodyMedium?.copyWith(
          color: tokens.foreground,
          fontWeight: FontWeight.w500,
        ),
        elevation: AnduraElevation.card,
        shape: mediumShape,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: tokens.accent,
        inactiveTrackColor: tokens.muted.withValues(alpha: .25),
        thumbColor: isDark ? tokens.foreground : tokens.accentOn,
        overlayColor: tokens.accent.withValues(alpha: .12),
        trackHeight: 6,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.surfaceWarm,
        hintStyle: themedText.bodyMedium?.copyWith(color: tokens.muted),
        errorStyle: themedText.bodySmall?.copyWith(color: tokens.danger),
        helperStyle: themedText.bodySmall?.copyWith(color: tokens.muted),
        contentPadding: EdgeInsets.symmetric(
          horizontal: legacy ? 20 : tokens.space4,
          vertical: legacy ? 16 : tokens.space3,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
      ),
      dividerColor: tokens.border,
    );
  }
}
