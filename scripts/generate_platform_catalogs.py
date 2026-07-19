#!/usr/bin/env python3
"""Generate React, Compose, and Swift catalogs from design_systems/catalog.json."""
from __future__ import annotations

import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "design_systems/catalog.json"
CHUNK_SIZE = 20
systems = json.loads(CATALOG.read_text())["systems"]
chunks = [systems[i:i + CHUNK_SIZE] for i in range(0, len(systems), CHUNK_SIZE)]


def quoted(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def css_color(argb: int) -> str:
    alpha = (argb >> 24) & 255
    rgb = argb & 0xFFFFFF
    return f"#{rgb:06x}" if alpha == 255 else f"#{rgb:06x}{alpha:02x}"


def clean_dir(path: Path, pattern: str) -> None:
    path.mkdir(parents=True, exist_ok=True)
    for stale in path.glob(pattern):
        stale.unlink()


# React / TypeScript ---------------------------------------------------------
ts_dir = ROOT / "packages/react/src/design-systems"
clean_dir(ts_dir, "chunk-*.ts")
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

for index, chunk in enumerate(chunks, 1):
    lines = ["// GENERATED FILE - DO NOT EDIT.", "import type { AnduraDesignSystem } from './types';", "", f"export const designSystemsChunk{index:02d} = ["]
    for s in chunk:
        lines.extend([
            "  {",
            f"    id: {quoted(s['id'])}, name: {quoted(s['name'])}, category: {quoted(s['category'])},",
            f"    description: {quoted(s['description'])}, brightness: {quoted(s['brightness'])},",
            f"    background: {quoted(css_color(s['bg']))}, surface: {quoted(css_color(s['surface']))}, surfaceWarm: {quoted(css_color(s['surfaceWarm']))},",
            f"    foreground: {quoted(css_color(s['fg']))}, foregroundSecondary: {quoted(css_color(s['fg2']))}, muted: {quoted(css_color(s['muted']))}, border: {quoted(css_color(s['border']))},",
            f"    accent: {quoted(css_color(s['accent']))}, accentOn: {quoted(css_color(s['accentOn']))}, success: {quoted(css_color(s['success']))}, warning: {quoted(css_color(s['warning']))}, danger: {quoted(css_color(s['danger']))},",
            f"    fontDisplay: {quoted(s['fontDisplay'])}, fontBody: {quoted(s['fontBody'])}, textBase: {s['textBase']},",
            f"    radiusSm: {s['radiusSm']}, radiusMd: {s['radiusMd']}, radiusLg: {s['radiusLg']}, radiusPill: {s['radiusPill']},",
            f"    space1: {s['space1']}, space2: {s['space2']}, space3: {s['space3']}, space4: {s['space4']}, space6: {s['space6']}, space8: {s['space8']},",
            f"    motionFastMs: {s['motionFast']}, motionBaseMs: {s['motionBase']}, containerMax: {s['containerMax']},",
            f"    componentGroups: {json.dumps(s['groups'])}, sourceClassCount: {s['sourceClassCount']},",
            "  },",
        ])
    lines.extend(["] as const satisfies readonly AnduraDesignSystem[];", ""])
    (ts_dir / f"chunk-{index:02d}.ts").write_text("\n".join(lines))

imports = [f"import {{ designSystemsChunk{i:02d} }} from './chunk-{i:02d}';" for i in range(1, len(chunks) + 1)]
spreads = [f"  ...designSystemsChunk{i:02d}," for i in range(1, len(chunks) + 1)]
(ts_dir / "index.ts").write_text("\n".join([
    "// GENERATED FILE - DO NOT EDIT.",
    "import type { AnduraDesignSystem } from './types';",
    *imports,
    "export type { AnduraDesignSystem } from './types';",
    "",
    "export const designSystems = [",
    *spreads,
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
clean_dir(kt_dir, "AnduraDesignSystems*.kt")
model = """// GENERATED FILE - DO NOT EDIT.
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
"""
(kt_dir / "AnduraDesignSystem.kt").write_text(model)

def ku(value: int) -> str:
    return f"0x{value:08X}u"

def kstr(value: str) -> str:
    return quoted(value).replace("\\/", "/").replace("$", "\\$")

for index, chunk in enumerate(chunks, 1):
    lines = ["// GENERATED FILE - DO NOT EDIT.", "package com.andura.ui.designsystems", "", f"internal val anduraDesignSystemsChunk{index:02d} = listOf("]
    for s in chunk:
        lines.extend([
            "    AnduraDesignSystem(",
            f"        id = {kstr(s['id'])}, name = {kstr(s['name'])}, category = {kstr(s['category'])}, description = {kstr(s['description'])}, nativeDark = {str(s['brightness'] == 'dark').lower()},",
            f"        background = {ku(s['bg'])}, surface = {ku(s['surface'])}, surfaceWarm = {ku(s['surfaceWarm'])}, foreground = {ku(s['fg'])}, foregroundSecondary = {ku(s['fg2'])}, muted = {ku(s['muted'])}, border = {ku(s['border'])},",
            f"        accent = {ku(s['accent'])}, accentOn = {ku(s['accentOn'])}, success = {ku(s['success'])}, warning = {ku(s['warning'])}, danger = {ku(s['danger'])},",
            f"        fontDisplay = {kstr(s['fontDisplay'])}, fontBody = {kstr(s['fontBody'])}, textBase = {s['textBase']}f, radiusSm = {s['radiusSm']}f, radiusMd = {s['radiusMd']}f, radiusLg = {s['radiusLg']}f, radiusPill = {s['radiusPill']}f,",
            f"        space1 = {s['space1']}f, space2 = {s['space2']}f, space3 = {s['space3']}f, space4 = {s['space4']}f, space6 = {s['space6']}f, space8 = {s['space8']}f,",
            f"        motionFastMs = {s['motionFast']}, motionBaseMs = {s['motionBase']}, containerMax = {s['containerMax']}f, componentGroups = listOf({', '.join(kstr(x) for x in s['groups'])}), sourceClassCount = {s['sourceClassCount']},",
            "    ),",
        ])
    lines.extend([")", ""])
    (kt_dir / f"AnduraDesignSystems{index:02d}.kt").write_text("\n".join(lines))
(kt_dir / "AnduraDesignSystems.kt").write_text("\n".join([
    "// GENERATED FILE - DO NOT EDIT.", "package com.andura.ui.designsystems", "",
    "object AnduraDesignSystems {",
    "    val all: List<AnduraDesignSystem> = buildList {",
    *[f"        addAll(anduraDesignSystemsChunk{i:02d})" for i in range(1, len(chunks) + 1)],
    "    }",
    "    fun byId(id: String): AnduraDesignSystem = all.firstOrNull { it.id == id } ?: defaultSystem",
    "    val defaultSystem: AnduraDesignSystem get() = all.firstOrNull { it.id == \"default\" } ?: all.first()",
    "}", "",
]))

# Swift ----------------------------------------------------------------------
swift_dir = ROOT / "packages/swift/Generated"
clean_dir(swift_dir, "AnduraDesignSystems*.swift")
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

for index, chunk in enumerate(chunks, 1):
    lines = ["// GENERATED FILE - DO NOT EDIT.", "import Foundation", "", f"let anduraDesignSystemsChunk{index:02d}: [AnduraDesignSystem] = ["]
    for s in chunk:
        lines.extend([
            "    AnduraDesignSystem(",
            f"        id: {sw(s['id'])}, name: {sw(s['name'])}, category: {sw(s['category'])}, description: {sw(s['description'])}, nativeDark: {str(s['brightness'] == 'dark').lower()},",
            f"        background: 0x{s['bg']:08X}, surface: 0x{s['surface']:08X}, surfaceWarm: 0x{s['surfaceWarm']:08X}, foreground: 0x{s['fg']:08X}, foregroundSecondary: 0x{s['fg2']:08X}, muted: 0x{s['muted']:08X}, border: 0x{s['border']:08X},",
            f"        accent: 0x{s['accent']:08X}, accentOn: 0x{s['accentOn']:08X}, success: 0x{s['success']:08X}, warning: 0x{s['warning']:08X}, danger: 0x{s['danger']:08X},",
            f"        fontDisplay: {sw(s['fontDisplay'])}, fontBody: {sw(s['fontBody'])}, textBase: {s['textBase']}, radiusSm: {s['radiusSm']}, radiusMd: {s['radiusMd']}, radiusLg: {s['radiusLg']}, radiusPill: {s['radiusPill']},",
            f"        space1: {s['space1']}, space2: {s['space2']}, space3: {s['space3']}, space4: {s['space4']}, space6: {s['space6']}, space8: {s['space8']}, motionFastMs: {s['motionFast']}, motionBaseMs: {s['motionBase']}, containerMax: {s['containerMax']},",
            f"        componentGroups: [{', '.join(sw(x) for x in s['groups'])}], sourceClassCount: {s['sourceClassCount']}),",
        ])
    lines.extend(["]", ""])
    (swift_dir / f"AnduraDesignSystems{index:02d}.swift").write_text("\n".join(lines))
(swift_dir / "AnduraDesignSystems.swift").write_text("\n".join([
    "// GENERATED FILE - DO NOT EDIT.", "import Foundation", "",
    "public enum AnduraDesignSystems {",
    "    public static let all: [AnduraDesignSystem] = [",
    *[f"        anduraDesignSystemsChunk{i:02d}," for i in range(1, len(chunks) + 1)],
    "    ].flatMap { $0 }",
    "    public static func byID(_ id: String) -> AnduraDesignSystem { all.first { $0.id == id } ?? defaultSystem }",
    "    public static var defaultSystem: AnduraDesignSystem { all.first { $0.id == \"default\" } ?? all[0] }",
    "}", "",
]))

print(f"Generated {len(systems)} design systems for React, Compose, and Swift in {len(chunks)} chunks each.")
