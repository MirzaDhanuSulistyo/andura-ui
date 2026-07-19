#!/usr/bin/env python3
import re, sys
from pathlib import Path
root = Path(__file__).resolve().parents[1]
source = (root / 'packages/react/src/index.tsx').read_text()
expected = ['Button','IconButton','Card','Input','TextArea','Select','Dialog','Badge','ErrorText','SearchField','EmptyState','LoadingOverlay','Avatar','NotificationButton','ChoiceRow','CheckOption','SettingsTile']
missing = [name for name in expected if not re.search(rf'export (?:const|function|interface) {name}\b', source)]
if missing:
    print('Missing React APIs:', ', '.join(missing), file=sys.stderr); sys.exit(1)
print(f'Validated {len(expected)} React public APIs.')
