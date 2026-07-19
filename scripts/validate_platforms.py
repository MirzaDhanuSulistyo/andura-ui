#!/usr/bin/env python3
"""Validate component and 151-system parity across all platform adapters."""
import json
import re
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
manifest = json.loads((root / "platform_manifest.json").read_text())
components = json.loads((root / "component_manifest.json").read_text())["components"]
component_names = [component["name"] for component in components]
catalog = json.loads((root / manifest["catalog"]["source"]).read_text())
system_ids = [system["id"] for system in catalog["systems"]]
expected_systems = manifest["catalog"]["expectedSystems"]
errors = []

if len(system_ids) != expected_systems or len(set(system_ids)) != expected_systems:
    errors.append(
        f"catalog: expected {expected_systems} unique systems, found {len(set(system_ids))}"
    )

react_names = {
    "AnduraTextField": "Input",
    "AnduraUserAvatar": "Avatar",
}


def pascal_id(value):
    return "".join(
        part[:1].upper() + part[1:]
        for part in re.split(r"[^A-Za-z0-9]+", value)
        if part
    )


def system_file(platform, system_id):
    if platform == "flutter":
        filename = re.sub(r"[^a-z0-9]+", "_", system_id.lower()).strip("_")
        return root / "lib/src/theme/generated" / f"{filename}.dart"
    if platform == "react":
        return root / "packages/react/src/design-systems" / f"{system_id}.ts"
    if platform == "compose":
        return root / "packages/compose/andura/src/main/kotlin/com/andura/ui/designsystems" / f"{pascal_id(system_id)}DesignSystem.kt"
    return root / "packages/swift/Generated" / f"{pascal_id(system_id)}DesignSystem.swift"


def platform_name(platform, component):
    if platform == "react":
        return react_names.get(component, component.removeprefix("Andura"))
    return component


def source_text(path_value):
    path = root / path_value
    if not path.exists():
        errors.append(f"missing source: {path_value}")
        return ""
    if path.is_dir():
        extensions = {".dart", ".tsx", ".ts", ".kt", ".swift"}
        return "\n".join(
            item.read_text()
            for item in path.rglob("*")
            if item.is_file() and item.suffix in extensions
        )
    return path.read_text()


for platform, adapter in manifest["adapters"].items():
    text = source_text(adapter["source"])
    if adapter.get("extendedSource"):
        text += "\n" + source_text(adapter["extendedSource"])

    implemented = adapter["implemented"]
    expected = component_names if implemented == "all" else implemented
    for component in expected:
        api = platform_name(platform, component)
        if not re.search(rf"\b{re.escape(api)}\b", text):
            errors.append(f"{platform}: missing component API {api} ({component})")

    catalog_path = root / adapter["catalogSource"]
    if not catalog_path.exists():
        errors.append(f"{platform}: missing catalog source {adapter['catalogSource']}")
        continue
    generated_text = source_text(str(catalog_path.parent.relative_to(root)))
    missing_ids = [system_id for system_id in system_ids if system_id not in generated_text]
    if missing_ids:
        errors.append(
            f"{platform}: catalog missing {len(missing_ids)} IDs ({', '.join(missing_ids[:5])})"
        )
    missing_files = [
        system_id for system_id in system_ids
        if not system_file(platform, system_id).is_file()
    ]
    if missing_files:
        errors.append(
            f"{platform}: missing {len(missing_files)} per-system files "
            f"({', '.join(missing_files[:5])})"
        )
    print(
        f"{platform}: {len(expected)} components, {len(system_ids)} design systems, "
        f"{len(system_ids) - len(missing_files)} per-system files"
    )

if errors:
    print("\n".join(f"ERROR: {error}" for error in errors), file=sys.stderr)
    sys.exit(1)
