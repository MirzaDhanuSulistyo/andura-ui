#!/usr/bin/env python3
"""Validate Andura's machine-readable design-system files."""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
errors = []

def load(path):
    try:
        return json.loads(path.read_text())
    except Exception as exc:
        errors.append(f"{path}: invalid JSON ({exc})")
        return {}

manifest = load(ROOT / "component_manifest.json")
tokens = load(ROOT / "tokens/andura_tokens.json")

for group in ("color", "spacing", "radius", "size", "elevation", "motion", "layout", "typography"):
    if not isinstance(tokens.get(group), dict) or not tokens[group]:
        errors.append(f"tokens: missing non-empty group '{group}'")

source_text = "\n".join(
    p.read_text() for p in (ROOT / "packages/flutter/lib").rglob("*.dart")
)
seen = set()
for component in manifest.get("components", []):
    name = component.get("name")
    if not name or name in seen:
        errors.append(f"manifest: missing or duplicate component '{name}'")
    seen.add(name)
    if not re.search(rf"\bclass\s+{re.escape(name)}\b", source_text):
        errors.append(f"manifest: component '{name}' is not implemented")
    if not component.get("category"):
        errors.append(f"manifest: component '{name}' has no category")
    if not component.get("states"):
        errors.append(f"manifest: component '{name}' has no states")

for path in [
    "packages/flutter/lib/src/foundations/generated_tokens.dart",
    "packages/react/tokens.css",
    "packages/compose/AnduraTokens.kt",
    "packages/swift/AnduraTokens.swift",
]:
    if not (ROOT / path).exists():
        errors.append(f"generated file missing: {path}")

if errors:
    print("\n".join(f"ERROR: {error}" for error in errors), file=sys.stderr)
    sys.exit(1)
print(f"Validated {len(seen)} components and {sum(len(v) for v in tokens.values() if isinstance(v, dict))} tokens.")
