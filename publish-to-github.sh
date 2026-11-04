#!/usr/bin/env bash
set -euo pipefail
repo="vebai/linux-for-devops-engineers"
cd "$(dirname "$0")"

command -v git >/dev/null || { echo 'Install Git before publishing.' >&2; exit 1; }
command -v gh >/dev/null || { echo 'Install GitHub CLI (gh) before publishing.' >&2; exit 1; }
gh auth status >/dev/null || { echo 'Sign in using: gh auth login' >&2; exit 1; }

if [[ -d .git ]]; then
  echo 'A Git repository already exists here; refusing to initialise or overwrite it.' >&2
  exit 1
fi
if gh repo view "$repo" >/dev/null 2>&1; then
  echo "GitHub repository $repo already exists; refusing to overwrite it." >&2
  exit 1
fi

bash tests/validate-files.sh
printf '\nThis will create PUBLIC GitHub repository %s and push the current files.\n' "$repo"
read -r -p 'Type PUBLISH to continue: ' answer
[[ "$answer" == 'PUBLISH' ]] || { echo 'Cancelled. No repository created.'; exit 0; }

git init -b main
git add .
git diff --cached --check
git commit -m 'Publish Linux for DevOps Engineers companion labs'
gh repo create "$repo" --public --source=. --remote=origin --push
printf '\nPublished: https://github.com/%s\n' "$repo"
