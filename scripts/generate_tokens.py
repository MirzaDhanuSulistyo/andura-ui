#!/usr/bin/env python3
"""Generate platform token files from tokens/andura_tokens.json."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
source = json.loads((ROOT / "tokens/andura_tokens.json").read_text())

def dart_name(value):
    return value

def dart_value(value):
    if isinstance(value, str):
        if value.startswith("#"):
            return f"Color(0xFF{value[1:]})"
        return repr(value)
    return f"{value}.0"

lines = ["// GENERATED FILE - DO NOT EDIT.", "import 'package:flutter/material.dart';", "", "abstract final class AnduraGeneratedTokens {"]
for group, values in source.items():
    lines.append(f"  // {group}")
    for name, value in values.items():
        generated = str(value) if group == "motion" else dart_value(value)
        lines.append(f"  static const {group}{name[0].upper() + name[1:]} = {generated};")
lines += ["}", ""]
(ROOT / "packages/flutter/lib/src/foundations/generated_tokens.dart").write_text("\n".join(lines))

css = [":root {"]
for group, values in source.items():
    for name, value in values.items():
        kebab = re.sub(r"(?<!^)([A-Z])", r"-\1", name).lower().replace('_', '-')
        css_name = f"--andura-{group}-{kebab}"
        if isinstance(value, (int, float)):
            suffix = "ms" if group == "motion" else "px"
            value = f"{value}{suffix}"
        css.append(f"  {css_name}: {value};")
css += ["}", "", "[data-theme='dark'] {", "  --andura-color-scaffold: #121218;", "  --andura-color-text-dark: #F5F5FA;", "  --andura-color-text-gray: #B2B2C2;", "  --andura-color-subtle-surface: #242432;", "}", ""]
(ROOT / "packages/react/tokens.css").write_text("\n".join(css))

ts = ["// GENERATED FILE - DO NOT EDIT.", "export const anduraTokens = {"]
for group, values in source.items():
    ts.append(f"  {group}: {{")
    for name, value in values.items():
        ts.append(f"    {name}: {json.dumps(value)},")
    ts.append("  },")
ts += ["} as const;", ""]
(ROOT / "packages/react/tokens.ts").write_text("\n".join(ts))

kotlin = ["// GENERATED FILE - DO NOT EDIT.", "package com.andura.ui", "", "import androidx.compose.ui.graphics.Color", "import androidx.compose.ui.unit.dp", "import androidx.compose.ui.unit.sp", "", "object AnduraTokens {"]
for group, values in source.items():
    for name, value in values.items():
        if isinstance(value, str) and value.startswith('#'):
            value = f"Color(0xFF{value[1:]})"
        elif isinstance(value, str):
            value = f'"{value}"'
        elif group in ('spacing', 'radius', 'size', 'elevation', 'layout'):
            value = f"{value}.dp"
        elif group == 'typography' and name.endswith('Size'):
            value = f"{value}.sp"
        elif group == 'motion':
            value = f"{value}L"
        else:
            value = f"{value}f"
        kotlin.append(f"    val {group}{name[0].upper() + name[1:]} = {value}")
kotlin += ["}", ""]
compose_tokens = "\n".join(kotlin)
(ROOT / "packages/compose/AnduraTokens.kt").write_text(compose_tokens)
(ROOT / "packages/compose/andura/src/main/kotlin/com/andura/ui/AnduraTokens.kt").write_text(compose_tokens)

swift = ["// GENERATED FILE - DO NOT EDIT.", "import SwiftUI", "", "public enum AnduraTokens {"]
for group, values in source.items():
    for name, value in values.items():
        if isinstance(value, str) and value.startswith('#'):
            rgb = [int(value[i:i + 2], 16) / 255 for i in (1, 3, 5)]
            value = f"Color(red: {rgb[0]:.6f}, green: {rgb[1]:.6f}, blue: {rgb[2]:.6f})"
        elif isinstance(value, str):
            value = f'\"{value}\"'
        else:
            value = f"{value}.0"
        swift.append(f"    public static let {group}{name[0].upper() + name[1:]} = {value}")
swift += ["}", ""]
swift_tokens = "\n".join(swift)
(ROOT / "packages/swift/AnduraTokens.swift").write_text(swift_tokens)
