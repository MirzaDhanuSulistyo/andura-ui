#!/usr/bin/env python3
"""Validate the public React API surface."""
import re
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
source = "\n".join(
    (root / path).read_text()
    for path in [
        "packages/react/src/index.tsx",
        "packages/react/src/extended.tsx",
        "packages/react/src/design-system-provider.tsx",
    ]
)
expected = [
    "Button", "IconButton", "Card", "Input", "TextArea", "Select",
    "PasswordField", "Dialog", "Badge", "ErrorText", "SearchField",
    "EmptyState", "LoadingOverlay", "Avatar", "NotificationButton",
    "ChoiceRow", "CheckOption", "SettingsTile", "Page", "SectionHeader",
    "Link", "KeyboardKey", "Chip", "Alert", "Switch", "Checkbox", "Radio",
    "Tabs", "Progress", "Skeleton", "Accordion", "Stat", "ListItem",
    "MenuButton", "BottomSheet", "ResponsiveContainer", "ResponsiveGrid",
    "Divider", "DesignSystemProvider",
]
missing = [name for name in expected if not re.search(rf"\b(?:function|const)\s+{name}\b", source)]
if missing:
    print("Missing React APIs:", ", ".join(missing), file=sys.stderr)
    sys.exit(1)
print(f"Validated {len(expected)} React public APIs and the design-system provider.")
