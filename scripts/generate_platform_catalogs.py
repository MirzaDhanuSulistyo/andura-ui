#!/usr/bin/env python3
"""Generate one React, Compose, and Swift source file per design system."""
from __future__ import annotations

import json
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "design_systems/catalog.json"
systems = json.loads(CATALOG.read_text())["systems"]


def quoted(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def css_color(argb: int) -> str:
    alpha = (argb >> 24) & 255
    rgb = argb & 0xFFFFFF
    return f"#{rgb:06x}" if alpha == 255 else f"#{rgb:06x}{alpha:02x}"


def pascal_id(value: str) -> str:
    return "".join(
        part[:1].upper() + part[1:]
        for part in re.split(r"[^A-Za-z0-9]+", value)
        if part
    )


def variable_id(value: str) -> str:
    name = pascal_id(value)
    return name[:1].lower() + name[1:]


def reset_dir(path: Path) -> None:
    if path.exists():
        shutil.rmtree(path)
    path.mkdir(parents=True)


# React / TypeScript ---------------------------------------------------------
ts_dir = ROOT / "packages/react/src/design-systems"
reset_dir(ts_dir)
ts_fields = [
    ("id", "string"), ("name", "string"), ("category", "string"),
    ("description", "string"), ("brightness", "'light' | 'dark'"),
    ("background", "string"), ("surface", "string"), ("surfaceWarm", "string"),
    ("foreground", "string"), ("foregroundSecondary", "string"), ("muted", "string"),
    ("border", "string"), ("accent", "string"), ("accentOn", "string"),
    ("success", "string"), ("warning", "string"), ("danger", "string"),
    ("fontDisplay", "string"), ("fontBody", "string"), ("textBase", "number"),
    ("radiusSm", "number"), ("radiusMd", "number"), ("radiusLg", "number"),
    ("radiusPill", "number"), ("space1", "number"), ("space2", "number"),
    ("space3", "number"), ("space4", "number"), ("space6", "number"),
    ("space8", "number"), ("motionFastMs", "number"), ("motionBaseMs", "number"),
    ("containerMax", "number"), ("componentGroups", "readonly string[]"),
    ("sourceClassCount", "number"),
]
(ts_dir / "types.ts").write_text("\n".join([
    "// GENERATED FILE - DO NOT EDIT.",
    "export interface AnduraDesignSystem {",
    *[f"  readonly {name}: {kind};" for name, kind in ts_fields],
    "}", "",
]))

for system in systems:
    name = f"{variable_id(system['id'])}DesignSystem"
    lines = [
        "// GENERATED FILE - DO NOT EDIT.",
        "import type { AnduraDesignSystem } from './types';",
        "",
        f"export const {name} = {{",
        f"  id: {quoted(system['id'])},",
        f"  name: {quoted(system['name'])},",
        f"  category: {quoted(system['category'])},",
        f"  description: {quoted(system['description'])},",
        f"  brightness: {quoted(system['brightness'])},",
        f"  background: {quoted(css_color(system['bg']))},",
        f"  surface: {quoted(css_color(system['surface']))},",
        f"  surfaceWarm: {quoted(css_color(system['surfaceWarm']))},",
        f"  foreground: {quoted(css_color(system['fg']))},",
        f"  foregroundSecondary: {quoted(css_color(system['fg2']))},",
        f"  muted: {quoted(css_color(system['muted']))},",
        f"  border: {quoted(css_color(system['border']))},",
        f"  accent: {quoted(css_color(system['accent']))},",
        f"  accentOn: {quoted(css_color(system['accentOn']))},",
        f"  success: {quoted(css_color(system['success']))},",
        f"  warning: {quoted(css_color(system['warning']))},",
        f"  danger: {quoted(css_color(system['danger']))},",
        f"  fontDisplay: {quoted(system['fontDisplay'])},",
        f"  fontBody: {quoted(system['fontBody'])},",
        f"  textBase: {system['textBase']},",
        f"  radiusSm: {system['radiusSm']},",
        f"  radiusMd: {system['radiusMd']},",
        f"  radiusLg: {system['radiusLg']},",
        f"  radiusPill: {system['radiusPill']},",
        f"  space1: {system['space1']},",
        f"  space2: {system['space2']},",
        f"  space3: {system['space3']},",
        f"  space4: {system['space4']},",
        f"  space6: {system['space6']},",
        f"  space8: {system['space8']},",
        f"  motionFastMs: {system['motionFast']},",
        f"  motionBaseMs: {system['motionBase']},",
        f"  containerMax: {system['containerMax']},",
        f"  componentGroups: {json.dumps(system['groups'])},",
        f"  sourceClassCount: {system['sourceClassCount']},",
        "} as const satisfies AnduraDesignSystem;",
        "",
    ]
    (ts_dir / f"{system['id']}.ts").write_text("\n".join(lines))

imports = [
    f"import {{ {variable_id(system['id'])}DesignSystem }} from './{system['id']}';"
    for system in systems
]
entries = [f"  {variable_id(system['id'])}DesignSystem," for system in systems]
(ts_dir / "index.ts").write_text("\n".join([
    "// GENERATED FILE - DO NOT EDIT.",
    "import type { AnduraDesignSystem } from './types';",
    *imports,
    "export type { AnduraDesignSystem } from './types';",
    "",
    "export const designSystems = [",
    *entries,
    "] as const satisfies readonly AnduraDesignSystem[];",
    "",
    "export function getDesignSystem(id: string): AnduraDesignSystem {",
    "  return designSystems.find(system => system.id === id) ?? designSystems.find(system => system.id === 'default') ?? designSystems[0];",
    "}",
    "",
    "export function designSystemVariables(system: AnduraDesignSystem): Record<`--${string}`, string> {",
    "  const px = (value: number) => `${value}px`;",
    "  return {",
    "    '--andura-bg': system.background, '--andura-surface': system.surface, '--andura-surface-warm': system.surfaceWarm,",
    "    '--andura-fg': system.foreground, '--andura-fg-2': system.foregroundSecondary, '--andura-muted': system.muted, '--andura-border': system.border,",
    "    '--andura-accent': system.accent, '--andura-accent-on': system.accentOn, '--andura-success': system.success, '--andura-warning': system.warning, '--andura-danger': system.danger,",
    "    '--andura-font-display': system.fontDisplay, '--andura-font-body': system.fontBody, '--andura-text-base': px(system.textBase),",
    "    '--andura-radius-sm': px(system.radiusSm), '--andura-radius-md': px(system.radiusMd), '--andura-radius-lg': px(system.radiusLg), '--andura-radius-pill': px(system.radiusPill),",
    "    '--andura-space-1': px(system.space1), '--andura-space-2': px(system.space2), '--andura-space-3': px(system.space3), '--andura-space-4': px(system.space4), '--andura-space-6': px(system.space6), '--andura-space-8': px(system.space8),",
    "    '--andura-motion-fast': `${system.motionFastMs}ms`, '--andura-motion-base': `${system.motionBaseMs}ms`, '--andura-container-max': px(system.containerMax),",
    "  };",
    "}", "",
]))

# Kotlin / Compose -----------------------------------------------------------
kt_dir = ROOT / "packages/compose/andura/src/main/kotlin/com/andura/ui/designsystems"
reset_dir(kt_dir)
(kt_dir / "AnduraDesignSystem.kt").write_text("""// GENERATED FILE - DO NOT EDIT.
package com.andura.ui.designsystems

data class AnduraDesignSystem(
    val id: String, val name: String, val category: String, val description: String,
    val nativeDark: Boolean,
    val background: ULong, val surface: ULong, val surfaceWarm: ULong,
    val foreground: ULong, val foregroundSecondary: ULong, val muted: ULong, val border: ULong,
    val accent: ULong, val accentOn: ULong, val success: ULong, val warning: ULong, val danger: ULong,
    val fontDisplay: String, val fontBody: String, val textBase: Float,
    val radiusSm: Float, val radiusMd: Float, val radiusLg: Float, val radiusPill: Float,
    val space1: Float, val space2: Float, val space3: Float, val space4: Float, val space6: Float, val space8: Float,
    val motionFastMs: Int, val motionBaseMs: Int, val containerMax: Float,
    val componentGroups: List<String>, val sourceClassCount: Int,
)
""")


def ku(value: int) -> str:
    return f"0x{value:08X}u"


def kstr(value: str) -> str:
    return quoted(value).replace("\\/", "/").replace("$", "\\$")


for system in systems:
    name = f"{variable_id(system['id'])}DesignSystem"
    lines = [
        "// GENERATED FILE - DO NOT EDIT.",
        "package com.andura.ui.designsystems",
        "",
        f"internal val {name} = AnduraDesignSystem(",
        f"    id = {kstr(system['id'])},",
        f"    name = {kstr(system['name'])},",
        f"    category = {kstr(system['category'])},",
        f"    description = {kstr(system['description'])},",
        f"    nativeDark = {str(system['brightness'] == 'dark').lower()},",
        f"    background = {ku(system['bg'])},",
        f"    surface = {ku(system['surface'])},",
        f"    surfaceWarm = {ku(system['surfaceWarm'])},",
        f"    foreground = {ku(system['fg'])},",
        f"    foregroundSecondary = {ku(system['fg2'])},",
        f"    muted = {ku(system['muted'])},",
        f"    border = {ku(system['border'])},",
        f"    accent = {ku(system['accent'])},",
        f"    accentOn = {ku(system['accentOn'])},",
        f"    success = {ku(system['success'])},",
        f"    warning = {ku(system['warning'])},",
        f"    danger = {ku(system['danger'])},",
        f"    fontDisplay = {kstr(system['fontDisplay'])},",
        f"    fontBody = {kstr(system['fontBody'])},",
        f"    textBase = {system['textBase']}f,",
        f"    radiusSm = {system['radiusSm']}f,",
        f"    radiusMd = {system['radiusMd']}f,",
        f"    radiusLg = {system['radiusLg']}f,",
        f"    radiusPill = {system['radiusPill']}f,",
        f"    space1 = {system['space1']}f,",
        f"    space2 = {system['space2']}f,",
        f"    space3 = {system['space3']}f,",
        f"    space4 = {system['space4']}f,",
        f"    space6 = {system['space6']}f,",
        f"    space8 = {system['space8']}f,",
        f"    motionFastMs = {system['motionFast']},",
        f"    motionBaseMs = {system['motionBase']},",
        f"    containerMax = {system['containerMax']}f,",
        f"    componentGroups = listOf({', '.join(kstr(x) for x in system['groups'])}),",
        f"    sourceClassCount = {system['sourceClassCount']},",
        ")",
        "",
    ]
    (kt_dir / f"{pascal_id(system['id'])}DesignSystem.kt").write_text("\n".join(lines))

(kt_dir / "AnduraDesignSystems.kt").write_text("\n".join([
    "// GENERATED FILE - DO NOT EDIT.",
    "package com.andura.ui.designsystems",
    "",
    "object AnduraDesignSystems {",
    "    val all: List<AnduraDesignSystem> = listOf(",
    *[f"        {variable_id(system['id'])}DesignSystem," for system in systems],
    "    )",
    "    fun byId(id: String): AnduraDesignSystem = all.firstOrNull { it.id == id } ?: defaultSystem",
    "    val defaultSystem: AnduraDesignSystem get() = all.firstOrNull { it.id == \"default\" } ?: all.first()",
    "}", "",
]))

# Swift ----------------------------------------------------------------------
swift_dir = ROOT / "packages/swift/Generated"
reset_dir(swift_dir)
(swift_dir / "AnduraDesignSystem.swift").write_text("""// GENERATED FILE - DO NOT EDIT.
import SwiftUI

public struct AnduraDesignSystem: Identifiable, Hashable, Sendable {
    public let id: String; public let name: String; public let category: String; public let description: String
    public let nativeDark: Bool
    public let background: UInt32; public let surface: UInt32; public let surfaceWarm: UInt32
    public let foreground: UInt32; public let foregroundSecondary: UInt32; public let muted: UInt32; public let border: UInt32
    public let accent: UInt32; public let accentOn: UInt32; public let success: UInt32; public let warning: UInt32; public let danger: UInt32
    public let fontDisplay: String; public let fontBody: String; public let textBase: Double
    public let radiusSm: Double; public let radiusMd: Double; public let radiusLg: Double; public let radiusPill: Double
    public let space1: Double; public let space2: Double; public let space3: Double; public let space4: Double; public let space6: Double; public let space8: Double
    public let motionFastMs: Int; public let motionBaseMs: Int; public let containerMax: Double
    public let componentGroups: [String]; public let sourceClassCount: Int
}

public extension Color {
    init(anduraARGB value: UInt32) {
        self.init(.sRGB, red: Double((value >> 16) & 255) / 255, green: Double((value >> 8) & 255) / 255, blue: Double(value & 255) / 255, opacity: Double((value >> 24) & 255) / 255)
    }
}
""")


def sw(value: str) -> str:
    return quoted(value).replace("\\/", "/")


for system in systems:
    name = f"{variable_id(system['id'])}DesignSystem"
    lines = [
        "// GENERATED FILE - DO NOT EDIT.",
        "import Foundation",
        "",
        f"let {name} = AnduraDesignSystem(",
        f"    id: {sw(system['id'])},",
        f"    name: {sw(system['name'])},",
        f"    category: {sw(system['category'])},",
        f"    description: {sw(system['description'])},",
        f"    nativeDark: {str(system['brightness'] == 'dark').lower()},",
        f"    background: 0x{system['bg']:08X},",
        f"    surface: 0x{system['surface']:08X},",
        f"    surfaceWarm: 0x{system['surfaceWarm']:08X},",
        f"    foreground: 0x{system['fg']:08X},",
        f"    foregroundSecondary: 0x{system['fg2']:08X},",
        f"    muted: 0x{system['muted']:08X},",
        f"    border: 0x{system['border']:08X},",
        f"    accent: 0x{system['accent']:08X},",
        f"    accentOn: 0x{system['accentOn']:08X},",
        f"    success: 0x{system['success']:08X},",
        f"    warning: 0x{system['warning']:08X},",
        f"    danger: 0x{system['danger']:08X},",
        f"    fontDisplay: {sw(system['fontDisplay'])},",
        f"    fontBody: {sw(system['fontBody'])},",
        f"    textBase: {system['textBase']},",
        f"    radiusSm: {system['radiusSm']},",
        f"    radiusMd: {system['radiusMd']},",
        f"    radiusLg: {system['radiusLg']},",
        f"    radiusPill: {system['radiusPill']},",
        f"    space1: {system['space1']},",
        f"    space2: {system['space2']},",
        f"    space3: {system['space3']},",
        f"    space4: {system['space4']},",
        f"    space6: {system['space6']},",
        f"    space8: {system['space8']},",
        f"    motionFastMs: {system['motionFast']},",
        f"    motionBaseMs: {system['motionBase']},",
        f"    containerMax: {system['containerMax']},",
        f"    componentGroups: [{', '.join(sw(x) for x in system['groups'])}],",
        f"    sourceClassCount: {system['sourceClassCount']}",
        ")",
        "",
    ]
    (swift_dir / f"{pascal_id(system['id'])}DesignSystem.swift").write_text("\n".join(lines))

(swift_dir / "AnduraDesignSystems.swift").write_text("\n".join([
    "// GENERATED FILE - DO NOT EDIT.",
    "import Foundation",
    "",
    "public enum AnduraDesignSystems {",
    "    public static let all: [AnduraDesignSystem] = [",
    *[f"        {variable_id(system['id'])}DesignSystem," for system in systems],
    "    ]",
    "    public static func byID(_ id: String) -> AnduraDesignSystem { all.first { $0.id == id } ?? defaultSystem }",
    "    public static var defaultSystem: AnduraDesignSystem { all.first { $0.id == \"default\" } ?? all[0] }",
    "}", "",
]))

print(
    f"Generated {len(systems)} design systems for React, Compose, and Swift "
    "with one source file per system."
)
