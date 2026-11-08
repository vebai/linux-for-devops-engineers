#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

bash -n scripts/verify-nginx.sh
bash -n tests/test-verify-nginx.sh
bash -n tests/validate-files.sh
bash -n tests/validate-ubuntu-live.sh
bash tests/test-verify-nginx.sh

python3 - <<'PYTEST'
from pathlib import Path
import re
root=Path('.')
errors=[]
for file in root.rglob('*.md'):
    content=file.read_text(encoding='utf-8')
    for target in re.findall(r'(?<!!)\[[^]]+\]\(([^)]+)\)',content):
        if target.startswith(('http://','https://','mailto:','#')):
            continue
        path=target.partition('#')[0].partition('?')[0]
        if not path:
            continue
        if not (file.parent/path).exists():
            errors.append(f'{file}: missing link {target}')
if errors:
    raise SystemExit('\n'.join(errors))
print('Markdown relative-link checks: passed')
for p in root.rglob('*.md'):
    if 'BOOK-CODE.md' in p.read_text():
        raise SystemExit(f'Unexpected editorial file reference in {p}')
print('Reader-facing documentation audit: passed')
PYTEST

echo 'Static repository checks passed. Live service tests are not performed.'
