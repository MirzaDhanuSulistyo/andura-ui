package com.andura.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Checkbox
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.stateDescription
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp

@Composable
fun AnduraSectionHeader(title: String, action: String? = null, onAction: (() -> Unit)? = null, modifier: Modifier = Modifier) =
    Row(modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
        Text(title, style = MaterialTheme.typography.titleMedium)
        if (action != null) TextButton(onClick = { onAction?.invoke() }, enabled = onAction != null) { Text(action) }
    }

@Composable
fun AnduraLink(label: String, onClick: () -> Unit, modifier: Modifier = Modifier) = TextButton(onClick = onClick, modifier = modifier) { Text(label) }

@Composable
fun AnduraKeyboardKey(label: String, modifier: Modifier = Modifier) = Surface(
    modifier = modifier.semantics { stateDescription = "Keyboard key $label" },
    color = MaterialTheme.colorScheme.surfaceVariant,
    shape = MaterialTheme.shapes.small,
) { Text(label, modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp), fontFamily = FontFamily.Monospace) }

@Composable
fun AnduraChip(label: String, selected: Boolean = false, onSelected: (Boolean) -> Unit = {}, modifier: Modifier = Modifier) =
    FilterChip(selected = selected, onClick = { onSelected(!selected) }, label = { Text(label) }, modifier = modifier)

enum class AnduraIntent { Neutral, Info, Success, Warning, Danger }

@Composable
fun AnduraAlert(message: String, modifier: Modifier = Modifier, title: String? = null, intent: AnduraIntent = AnduraIntent.Info) {
    val system = LocalAnduraDesignSystem.current
    val color = when (intent) {
        AnduraIntent.Neutral -> Color(system.muted)
        AnduraIntent.Info -> Color(system.accent)
        AnduraIntent.Success -> Color(system.success)
        AnduraIntent.Warning -> Color(system.warning)
        AnduraIntent.Danger -> Color(system.danger)
    }
    Surface(modifier = modifier.fillMaxWidth(), color = color.copy(alpha = .12f), shape = MaterialTheme.shapes.medium) {
        Column(Modifier.padding(16.dp)) {
            if (title != null) Text(title, style = MaterialTheme.typography.titleSmall)
            Text(message)
        }
    }
}

@Composable
fun AnduraSwitch(label: String, checked: Boolean, onCheckedChange: (Boolean) -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true) =
    Row(modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text(label); Switch(checked, onCheckedChange, enabled = enabled) }

@Composable
fun AnduraCheckbox(label: String, checked: Boolean, onCheckedChange: (Boolean) -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true) =
    Row(modifier) { Checkbox(checked, onCheckedChange, enabled = enabled); Text(label) }

@Composable
fun <T> AnduraRadio(label: String, value: T, selected: T?, onSelected: (T) -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true) =
    Row(modifier) { RadioButton(selected = value == selected, onClick = { onSelected(value) }, enabled = enabled); Text(label) }

@Composable
fun <T> AnduraTabs(values: List<T>, selected: T, label: (T) -> String, onSelected: (T) -> Unit, modifier: Modifier = Modifier) =
    Row(modifier, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        values.forEach { value -> OutlinedButton(onClick = { onSelected(value) }, enabled = value != selected) { Text(label(value)) } }
    }

@Composable
fun AnduraProgress(progress: Float? = null, label: String? = null, modifier: Modifier = Modifier) = Column(modifier) {
    if (label != null) Text(label)
    if (progress == null) LinearProgressIndicator(Modifier.fillMaxWidth())
    else LinearProgressIndicator(progress = { progress.coerceIn(0f, 1f) }, modifier = Modifier.fillMaxWidth())
}

@Composable
fun AnduraSkeleton(modifier: Modifier = Modifier, circular: Boolean = false) {
    val shape = if (circular) CircleShape else MaterialTheme.shapes.small
    Box(modifier.clip(shape).background(MaterialTheme.colorScheme.onSurface.copy(alpha = .12f)))
}

@Composable
fun AnduraAccordion(title: String, modifier: Modifier = Modifier, initiallyExpanded: Boolean = false, content: @Composable () -> Unit) {
    var expanded by remember { mutableStateOf(initiallyExpanded) }
    Column(modifier) {
        TextButton(onClick = { expanded = !expanded }, modifier = Modifier.fillMaxWidth()) { Text(title) }
        if (expanded) content()
    }
}

@Composable
fun AnduraStat(label: String, value: String, modifier: Modifier = Modifier, change: String? = null, intent: AnduraIntent = AnduraIntent.Neutral) =
    Column(modifier) { Text(label, style = MaterialTheme.typography.labelMedium); Text(value, style = MaterialTheme.typography.headlineMedium); if (change != null) Text(change) }

@Composable
fun AnduraListItem(title: String, modifier: Modifier = Modifier, subtitle: String? = null, leading: (@Composable () -> Unit)? = null, trailing: (@Composable () -> Unit)? = null) =
    ListItem(headlineContent = { Text(title) }, modifier = modifier, supportingContent = subtitle?.let { { Text(it) } }, leadingContent = leading, trailingContent = trailing)

@Composable
fun AnduraMenuButton(label: String, items: List<String>, onSelected: (String) -> Unit, modifier: Modifier = Modifier) {
    var expanded by remember { mutableStateOf(false) }
    Box(modifier) {
        OutlinedButton(onClick = { expanded = true }) { Text(label) }
        DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
            items.forEach { item -> DropdownMenuItem(text = { Text(item) }, onClick = { expanded = false; onSelected(item) }) }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AnduraBottomSheet(visible: Boolean, onDismissRequest: () -> Unit, content: @Composable ColumnScope.() -> Unit) {
    if (visible) ModalBottomSheet(onDismissRequest = onDismissRequest, content = content)
}

@Composable
fun AnduraResponsiveContainer(modifier: Modifier = Modifier, content: @Composable () -> Unit) {
    val system = LocalAnduraDesignSystem.current
    Box(modifier.fillMaxWidth().widthIn(max = system.containerMax.dp).padding(horizontal = system.space4.dp)) { content() }
}

@Composable
fun AnduraResponsiveGrid(modifier: Modifier = Modifier, content: @Composable RowScope.() -> Unit) =
    Row(modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(16.dp), content = content)

@Composable
fun AnduraDivider(label: String? = null, modifier: Modifier = Modifier) {
    if (label == null) HorizontalDivider(modifier) else Row(modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(12.dp)) {
        HorizontalDivider(Modifier.weight(1f)); Text(label); HorizontalDivider(Modifier.weight(1f))
    }
}
