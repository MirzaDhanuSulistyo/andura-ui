package com.andura.ui

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.material3.Shapes
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.andura.ui.designsystems.AnduraDesignSystem
import com.andura.ui.designsystems.AnduraDesignSystems

val LocalAnduraDesignSystem = staticCompositionLocalOf { AnduraDesignSystems.defaultSystem }

/** Applies any of the 151 normalized Open Design systems to Compose content. */
@Composable
fun AnduraDesignSystemTheme(
    system: AnduraDesignSystem = AnduraDesignSystems.defaultSystem,
    darkTheme: Boolean = system.nativeDark || isSystemInDarkTheme(),
    content: @Composable () -> Unit,
) {
    val base = if (darkTheme) darkColorScheme(primary = Color(system.accent)) else lightColorScheme(primary = Color(system.accent))
    val useNativeCanvas = darkTheme == system.nativeDark
    val colors = base.copy(
        primary = Color(system.accent),
        onPrimary = Color(system.accentOn),
        secondary = Color(system.success),
        error = Color(system.danger),
        background = if (useNativeCanvas) Color(system.background) else base.background,
        onBackground = if (useNativeCanvas) Color(system.foreground) else base.onBackground,
        surface = if (useNativeCanvas) Color(system.surface) else base.surface,
        onSurface = if (useNativeCanvas) Color(system.foreground) else base.onSurface,
        surfaceVariant = if (useNativeCanvas) Color(system.surfaceWarm) else base.surfaceVariant,
        onSurfaceVariant = if (useNativeCanvas) Color(system.foregroundSecondary) else base.onSurfaceVariant,
        outline = if (useNativeCanvas) Color(system.border) else base.outline,
    )
    val family = when {
        system.fontBody.contains("mono", ignoreCase = true) -> FontFamily.Monospace
        system.fontBody.contains("serif", ignoreCase = true) -> FontFamily.Serif
        else -> FontFamily.SansSerif
    }
    val typography = Typography(bodyMedium = TextStyle(fontFamily = family, fontSize = system.textBase.sp))
    val shapes = Shapes(
        small = androidx.compose.foundation.shape.RoundedCornerShape(system.radiusSm.dp),
        medium = androidx.compose.foundation.shape.RoundedCornerShape(system.radiusMd.dp),
        large = androidx.compose.foundation.shape.RoundedCornerShape(system.radiusLg.dp),
    )
    CompositionLocalProvider(LocalAnduraDesignSystem provides system) {
        MaterialTheme(colorScheme = colors, typography = typography, shapes = shapes, content = content)
    }
}
