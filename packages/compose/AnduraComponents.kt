package com.andura.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Badge
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
fun AnduraButton(label: String, onClick: () -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true, loading: Boolean = false) = Button(onClick = onClick, enabled = enabled && !loading, modifier = modifier) {
    if (loading) CircularProgressIndicator() else Text(label)
}

@Composable
fun AnduraIconButton(onClick: () -> Unit, contentDescription: String, modifier: Modifier = Modifier, content: @Composable () -> Unit) = IconButton(onClick, modifier) { content() }

@Composable
fun AnduraCard(content: @Composable () -> Unit, modifier: Modifier = Modifier) = Card(modifier = modifier) { content() }

@Composable
fun AnduraTextField(value: String, onValueChange: (String) -> Unit, label: String, modifier: Modifier = Modifier, isError: Boolean = false, enabled: Boolean = true) = TextField(value, onValueChange, label = { Text(label) }, isError = isError, enabled = enabled, modifier = modifier)

@Composable
fun AnduraTextArea(value: String, onValueChange: (String) -> Unit, label: String, modifier: Modifier = Modifier, isError: Boolean = false) = AnduraTextField(value, onValueChange, label, modifier, isError)

@Composable
fun AnduraPasswordField(value: String, onValueChange: (String) -> Unit, modifier: Modifier = Modifier) = AnduraTextField(value, onValueChange, "Password", modifier)

@Composable
fun AnduraSelect(label: String, options: List<String>, selected: String, onSelected: (String) -> Unit, modifier: Modifier = Modifier) = Row(modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) { Text("$label: $selected"); options.filter { it != selected }.forEach { OutlinedButton({ onSelected(it) }) { Text(it) } } }

@Composable
fun AnduraBadge(label: String) = Badge { Text(label) }

@Composable
fun AnduraDialog(title: String, onDismissRequest: () -> Unit, content: @Composable () -> Unit) = AlertDialog(onDismissRequest = onDismissRequest, title = { Text(title) }, text = content, confirmButton = { TextButton(onClick = onDismissRequest) { Text("Close") } })

@Composable
fun AnduraChoiceRow(values: List<String>, selected: String, onSelected: (String) -> Unit, modifier: Modifier = Modifier) = Row(modifier, horizontalArrangement = Arrangement.spacedBy(AnduraTokens.spacingMd)) { values.forEach { OutlinedButton({ onSelected(it) }, enabled = it != selected) { Text(it) } } }

@Composable
fun AnduraCheckOption(label: String, checked: Boolean, onCheckedChange: (Boolean) -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true) = Row(modifier) { Checkbox(checked, onCheckedChange, enabled = enabled); Text(label) }

@Composable
fun AnduraSettingsTile(title: String, onClick: () -> Unit, modifier: Modifier = Modifier) = OutlinedButton(onClick, modifier.fillMaxWidth()) { Text(title) }

@Composable
fun AnduraSearchField(value: String, onValueChange: (String) -> Unit, modifier: Modifier = Modifier) = AnduraTextField(value, onValueChange, "Search", modifier)

@Composable
fun AnduraEmptyState(message: String, modifier: Modifier = Modifier) = Text(message, modifier)

@Composable
fun AnduraLoadingOverlay(loading: Boolean, content: @Composable () -> Unit) { content(); if (loading) CircularProgressIndicator() }

@Composable
fun AnduraErrorText(message: String) = Text(message)

@Composable
fun AnduraUserAvatar(initial: String) = Badge { Text(initial.take(1).uppercase()) }

@Composable
fun AnduraNotificationButton(onClick: () -> Unit, hasNotification: Boolean = false) = IconButton(onClick) { Text(if (hasNotification) "●" else "○") }

@Composable
fun AnduraPage(content: @Composable () -> Unit) { content() }
