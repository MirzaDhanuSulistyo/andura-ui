#!/usr/bin/env python3
import json, re, sys
from pathlib import Path
root = Path(__file__).resolve().parents[1]
manifest = json.loads((root / 'platform_manifest.json').read_text())
components = json.loads((root / 'component_manifest.json').read_text())['components']
expected = {c['name'] for c in components}
errors = []
for platform, adapter in manifest['adapters'].items():
    source = adapter['source']
    if source != 'lib' and not (root / source).exists():
        errors.append(f'{platform}: missing source {source}')
        continue
    if adapter['implemented'] == 'all':
        continue
    text = (root / source).read_text()
    for name in adapter['implemented']:
        if not re.search(rf'\b{name}\b', text): errors.append(f'{platform}: missing {name}')
    unsupported = sorted(expected - set(adapter['implemented']))
    print(f'{platform}: {len(adapter["implemented"])} implemented, {len(unsupported)} pending')
if errors:
    print('\n'.join(errors), file=sys.stderr); sys.exit(1)
