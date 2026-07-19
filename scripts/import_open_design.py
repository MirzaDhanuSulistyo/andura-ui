#!/usr/bin/env python3
"""Import Open Design into Andura's cross-platform theme catalogs.

Usage:
  python3 scripts/import_open_design.py [path/to/open-design/design-systems]

The importer stores normalized semantic values and generates Dart, TypeScript,
Kotlin, and Swift catalogs rather than copying web CSS directly.
The original manifests remain the source of truth and are never modified.
"""
from __future__ import annotations

import json
import re
import shutil
import subprocess
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE = Path.home() / "code/open-design/design-systems"
SOURCE = Path(sys.argv[1]).expanduser().resolve() if len(sys.argv) > 1 else DEFAULT_SOURCE
OUT_DART = ROOT / "packages/flutter/lib/src/theme/generated_design_systems.dart"
OUT_CATALOG = ROOT / "design_systems/catalog.json"
OUT_JSON = ROOT / "docs/open_design_audit.json"
OUT_MD = ROOT / "docs/open_design_audit.md"

if not SOURCE.is_dir():
    raise SystemExit(f"Open Design catalog not found: {SOURCE}")


def css_vars(path: Path) -> dict[str, str]:
    text = re.sub(r"/\*.*?\*/", "", path.read_text(), flags=re.S)
    return {m.group(1): m.group(2).strip() for m in re.finditer(r"(--[\w-]+)\s*:\s*([^;]+);", text)}


def token_vars(folder: Path) -> dict[str, str]:
    path = folder / "design-tokens.json"
    if path.exists():
        data = json.loads(path.read_text())
        return {token["name"]: str(token["value"]) for token in data.get("tokens", [])}
    return css_vars(folder / "tokens.css")


def resolve(value: str, values: dict[str, str], seen: set[str] | None = None) -> str:
    seen = seen or set()
    match = re.fullmatch(r"var\((--[\w-]+)\)", value.strip())
    if not match or match.group(1) in seen:
        return value.strip()
    name = match.group(1)
    return resolve(values.get(name, value), values, seen | {name})


def color_int(value: str, values: dict[str, str], fallback: int) -> int:
    value = resolve(value, values)
    # color-mix values in the source represent interaction states. Their base
    # semantic color is the safest portable Flutter approximation.
    var_match = re.search(r"var\((--[\w-]+)\)", value)
    if var_match:
        return color_int(values.get(var_match.group(1), ""), values, fallback)
    match = re.fullmatch(r"#([0-9a-fA-F]{3,8})", value)
    if match:
        raw = match.group(1)
        if len(raw) == 3:
            raw = "".join(ch * 2 for ch in raw)
        if len(raw) == 6:
            return 0xFF000000 | int(raw, 16)
        if len(raw) == 8:
            return int(raw[6:8] + raw[:6], 16)  # CSS RRGGBBAA -> Flutter AARRGGBB
    match = re.fullmatch(r"rgba?\(([^)]+)\)", value)
    if match:
        parts = [part.strip() for part in match.group(1).replace("/", ",").split(",")]
        try:
            rgb = [round(float(parts[i].rstrip("%")) * (2.55 if "%" in parts[i] else 1)) for i in range(3)]
            alpha = round(float(parts[3]) * 255) if len(parts) > 3 else 255
            return (alpha << 24) | (rgb[0] << 16) | (rgb[1] << 8) | rgb[2]
        except (ValueError, IndexError):
            pass
    return fallback


def number(value: str, fallback: float) -> float:
    match = re.search(r"-?\d+(?:\.\d+)?", value)
    return float(match.group()) if match else fallback


def duration(value: str, fallback: int) -> int:
    amount = number(value, float(fallback))
    return round(amount * 1000) if value.strip().endswith("s") and not value.strip().endswith("ms") else round(amount)


def font(value: str, fallback: str) -> str:
    first = value.split(",", 1)[0].strip().strip("\"'")
    return fallback if first in {"system-ui", "sans-serif", "serif", "ui-monospace"} else first


def dart_string(value: str) -> str:
    return "'" + value.replace("\\", "\\\\").replace("'", "\\'") + "'"


def brightness(argb: int) -> str:
    r, g, b = (argb >> 16) & 255, (argb >> 8) & 255, argb & 255
    luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
    return "dark" if luminance < 0.45 else "light"


GROUP_IMPLEMENTATIONS = {
    "buttons": ["AnduraButton", "AnduraIconButton"],
    "inputs": ["AnduraTextField", "AnduraTextArea", "AnduraSelect", "AnduraCheckbox", "AnduraRadio", "AnduraSwitch"],
    "cards": ["AnduraCard", "AnduraStat", "AnduraAccordion"],
    "badges": ["AnduraBadge", "AnduraChip"],
    "links": ["AnduraLink"],
    "keyboard": ["AnduraKeyboardKey"],
    "icons": ["AnduraIconButton"],
    "typography": ["AnduraSectionHeader", "AnduraErrorText"],
    "layout": ["AnduraPage", "AnduraResponsiveContainer", "AnduraResponsiveGrid", "AnduraDivider"],
}

folders = sorted(p for p in SOURCE.iterdir() if p.is_dir() and p.name != "_schema")
systems = []
group_counts: Counter[str] = Counter()
class_counts: Counter[str] = Counter()
missing = []

for folder in folders:
    manifest = json.loads((folder / "manifest.json").read_text())
    values = token_vars(folder)
    component_path = folder / "components.manifest.json"
    component_groups = []
    source_class_count = 0
    if component_path.exists():
        component_data = json.loads(component_path.read_text())
        component_groups = [group["id"] for group in component_data.get("groups", []) if group.get("present")]
        source_class_count = len(component_data.get("classes", []))
        group_counts.update(component_groups)
        class_counts.update(component_data.get("classes", []))
    else:
        # tom-modern predates the generated cache but ships the same reference fixture.
        component_groups = ["buttons", "inputs", "cards", "badges", "links", "keyboard", "icons", "typography", "layout"]
        group_counts.update(component_groups)
        missing.append(folder.name)

    def val(name: str, default: str) -> str:
        return resolve(values.get(name, default), values)

    bg = color_int(val("--bg", "#ffffff"), values, 0xFFFFFFFF)
    systems.append({
        "id": manifest.get("id", folder.name),
        "name": manifest.get("name", folder.name),
        "category": manifest.get("category", "Other"),
        "description": manifest.get("description", ""),
        "brightness": brightness(bg),
        "bg": bg,
        "surface": color_int(val("--surface", "#ffffff"), values, bg),
        "surfaceWarm": color_int(val("--surface-warm", "var(--surface)"), values, bg),
        "fg": color_int(val("--fg", "#16161e"), values, 0xFF16161E),
        "fg2": color_int(val("--fg-2", "var(--fg)"), values, 0xFF3F3F46),
        "muted": color_int(val("--muted", "#71717a"), values, 0xFF71717A),
        "border": color_int(val("--border", "#d4d4d8"), values, 0xFFD4D4D8),
        "accent": color_int(val("--accent", "#6b72ff"), values, 0xFF6B72FF),
        "accentOn": color_int(val("--accent-on", "#ffffff"), values, 0xFFFFFFFF),
        "success": color_int(val("--success", "#16a34a"), values, 0xFF16A34A),
        "warning": color_int(val("--warn", "#eab308"), values, 0xFFEAB308),
        "danger": color_int(val("--danger", "#dc2626"), values, 0xFFDC2626),
        "fontDisplay": font(val("--font-display", "Poppins"), "Poppins"),
        "fontBody": font(val("--font-body", "Poppins"), "Poppins"),
        "textBase": number(val("--text-base", "14px"), 14),
        "radiusSm": number(val("--radius-sm", "10px"), 10),
        "radiusMd": number(val("--radius-md", "14px"), 14),
        "radiusLg": number(val("--radius-lg", "16px"), 16),
        "radiusPill": number(val("--radius-pill", "999px"), 999),
        "space1": number(val("--space-1", "4px"), 4),
        "space2": number(val("--space-2", "8px"), 8),
        "space3": number(val("--space-3", "12px"), 12),
        "space4": number(val("--space-4", "16px"), 16),
        "space6": number(val("--space-6", "24px"), 24),
        "space8": number(val("--space-8", "32px"), 32),
        "motionFast": duration(val("--motion-fast", "150ms"), 150),
        "motionBase": duration(val("--motion-base", "250ms"), 250),
        "containerMax": number(val("--container-max", "1200px"), 1200),
        "groups": component_groups,
        "sourceClassCount": source_class_count,
    })

def dart_system_lines(item: dict, indent: str = "  ") -> list[str]:
    return [
        f"{indent}AnduraDesignSystem(",
        f"{indent}  id: {dart_string(item['id'])}, name: {dart_string(item['name'])},",
        f"{indent}  category: {dart_string(item['category'])},",
        f"{indent}  description: {dart_string(item['description'])},",
        f"{indent}  nativeBrightness: AnduraNativeBrightness.{item['brightness']},",
        f"{indent}  background: 0x{item['bg']:08X}, surface: 0x{item['surface']:08X}, surfaceWarm: 0x{item['surfaceWarm']:08X},",
        f"{indent}  foreground: 0x{item['fg']:08X}, foregroundSecondary: 0x{item['fg2']:08X}, muted: 0x{item['muted']:08X}, border: 0x{item['border']:08X},",
        f"{indent}  accent: 0x{item['accent']:08X}, accentOn: 0x{item['accentOn']:08X}, success: 0x{item['success']:08X}, warning: 0x{item['warning']:08X}, danger: 0x{item['danger']:08X},",
        f"{indent}  fontDisplay: {dart_string(item['fontDisplay'])}, fontBody: {dart_string(item['fontBody'])}, textBase: {item['textBase']},",
        f"{indent}  radiusSm: {item['radiusSm']}, radiusMd: {item['radiusMd']}, radiusLg: {item['radiusLg']}, radiusPill: {item['radiusPill']},",
        f"{indent}  space1: {item['space1']}, space2: {item['space2']}, space3: {item['space3']}, space4: {item['space4']}, space6: {item['space6']}, space8: {item['space8']},",
        f"{indent}  motionFastMs: {item['motionFast']}, motionBaseMs: {item['motionBase']}, containerMax: {item['containerMax']},",
        f"{indent}  componentGroups: <String>[{', '.join(dart_string(x) for x in item['groups'])}], sourceClassCount: {item['sourceClassCount']},",
        f"{indent}),",
    ]


def system_identifier(value: str) -> str:
    return "".join(part[:1].upper() + part[1:] for part in re.split(r"[^A-Za-z0-9]+", value) if part)


def dart_file_name(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "_", value.lower()).strip("_")


generated_dir = OUT_DART.parent / "generated"
generated_dir.mkdir(parents=True, exist_ok=True)
for stale in generated_dir.glob("*.dart"):
    stale.unlink()

for item in systems:
    name = f"anduraDesignSystem{system_identifier(item['id'])}"
    declaration = dart_system_lines(item, "")
    declaration[0] = f"const {name} = AnduraDesignSystem("
    declaration[-1] = ");"
    system_lines = [
        "// GENERATED FILE - DO NOT EDIT.",
        "import '../andura_design_system.dart';",
        "",
        *declaration,
        "",
    ]
    (generated_dir / f"{dart_file_name(item['id'])}.dart").write_text("\n".join(system_lines))

lines = [
    "// GENERATED FILE - DO NOT EDIT.",
    "// Source: Open Design design-systems catalog.",
    "import 'andura_design_system.dart';",
    *[f"import 'generated/{dart_file_name(item['id'])}.dart';" for item in systems],
    "",
    "abstract final class AnduraDesignSystems {",
    "  static const all = <AnduraDesignSystem>[",
    *[f"    anduraDesignSystem{system_identifier(item['id'])}," for item in systems],
    "  ];",
    "",
    "  static AnduraDesignSystem byId(String id) => all.firstWhere(",
    "    (system) => system.id == id,",
    "    orElse: () => defaultSystem,",
    "  );",
    "",
    "  static AnduraDesignSystem get defaultSystem => all.firstWhere(",
    "    (system) => system.id == 'default',",
    "    orElse: () => all.first,",
    "  );",
    "}",
    "",
]
OUT_DART.parent.mkdir(parents=True, exist_ok=True)
OUT_DART.write_text("\n".join(lines))
dart = shutil.which("dart")
if dart:
    subprocess.run(
        [dart, "format", str(OUT_DART), str(generated_dir)],
        check=True,
        stdout=subprocess.DEVNULL,
    )

OUT_CATALOG.parent.mkdir(parents=True, exist_ok=True)
OUT_CATALOG.write_text(json.dumps({
    "schemaVersion": "andura-design-systems/v1",
    "source": "open-design/design-systems",
    "systems": systems,
}, indent=2) + "\n")

audit = {
    "schemaVersion": 1,
    "source": "open-design/design-systems",
    "systemCount": len(systems),
    "systemsWithGeneratedComponentManifest": len(systems) - len(missing),
    "legacyComponentFixtures": missing,
    "normalizedComponentGroups": {
        name: {"systems": count, "flutterImplementations": GROUP_IMPLEMENTATIONS[name]}
        for name, count in sorted(group_counts.items())
    },
    "topSourceClasses": [{"name": name, "systems": count} for name, count in class_counts.most_common(100)],
    "systems": [
        {
            **{k: item[k] for k in ("id", "name", "category", "groups", "sourceClassCount")},
            "flutterCoverage": {
                group: GROUP_IMPLEMENTATIONS[group] for group in item["groups"]
            },
        }
        for item in systems
    ],
}
OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
OUT_JSON.write_text(json.dumps(audit, indent=2) + "\n")
OUT_MD.write_text("\n".join([
    "# Open Design catalog audit",
    "",
    "> Generated by `scripts/import_open_design.py`. Do not edit manually.",
    "",
    f"- Design systems: **{len(systems)}**",
    f"- Generated component manifests: **{len(systems) - len(missing)}**",
    f"- Legacy fixtures normalized by the importer: **{len(missing)}** ({', '.join(missing) or 'none'})",
    f"- Shared component groups: **{len(group_counts)}**",
    "",
    "## Normalized component coverage",
    "",
    "| Group | Systems | Flutter implementations |",
    "|---|---:|---|",
    *[
        f"| {name} | {count} | {', '.join(GROUP_IMPLEMENTATIONS[name])} |"
        for name, count in sorted(group_counts.items())
    ],
    "",
    "The manifests expose nine normalized reference groups. Brand-specific CSS classes are recipes and page compositions, not stable reusable component APIs. See `open_design_audit.json` for the complete 151-system matrix and the most common source classes.",
    "",
]))
subprocess.run(
    [sys.executable, str(ROOT / "scripts/generate_platform_catalogs.py")],
    check=True,
)
print(
    f"Imported {len(systems)} systems; wrote {OUT_CATALOG.relative_to(ROOT)}, "
    f"{OUT_DART.relative_to(ROOT)}, {OUT_JSON.relative_to(ROOT)}, and "
    f"{OUT_MD.relative_to(ROOT)}"
)
