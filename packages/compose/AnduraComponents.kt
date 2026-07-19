package com.andura.ui

import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
fun AnduraButton(
    label: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
) = Button(onClick = onClick, enabled = enabled, modifier = modifier) {
    Text(label)
}

@Composable
fun AnduraCard(content: @Composable () -> Unit, modifier: Modifier = Modifier) =
    Card(modifier = modifier) { content() }

@Composable
fun AnduraTextField(
    value: String,
    onValueChange: (String) -> Unit,
    label: String,
    modifier: Modifier = Modifier,
    isError: Boolean = false,
) = TextField(value, onValueChange, label = { Text(label) }, isError = isError, modifier = modifier)

@Composable
fun AnduraBadge(label: String) = Text(label)

@Composable
fun AnduraDialog(
    title: String,
    onDismissRequest: () -> Unit,
    content: @Composable () -> Unit,
) = AlertDialog(
    onDismissRequest = onDismissRequest,
    title = { Text(title) },
    text = content,
    confirmButton = { TextButton(onClick = onDismissRequest) { Text("Close") } },
)
