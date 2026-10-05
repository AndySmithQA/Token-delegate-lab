#!/usr/bin/env bash
# Run from the clone root: bash scripts/prepare-lab.sh
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
app="$root/lab/app"
lean="$root/lab/fixtures/copilot-instructions.lean.md"
instructions="$app/.github/copilot-instructions.md"
pricing="$app/src/pricing.js"

if [[ ! -d "$app" ]]; then
  echo "lab/app was not found. Run this script from a clone of the delegate lab repository." >&2
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is not on PATH. Install Node.js 22 or later." >&2
  exit 1
fi

node_version="$(node --version)"
node_major="${node_version#v}"
node_major="${node_major%%.*}"
if [[ "$node_major" -lt 22 ]]; then
  echo "Node.js 22 or later is required. Found $node_version." >&2
  exit 1
fi
echo "Node.js $node_version"

if ! command -v git >/dev/null 2>&1; then
  echo "Git is not on PATH." >&2
  exit 1
fi

if ! command -v copilot >/dev/null 2>&1; then
  if command -v npm >/dev/null 2>&1; then
    echo "Installing GitHub Copilot CLI..."
    npm install -g @github/copilot
  else
    echo "copilot is not on PATH. Install @github/copilot and run: copilot login" >&2
  fi
fi

if ! grep -q '^Code only, no explanation\.' "$instructions"; then
  cp "$lean" "$instructions"
  echo "Restored the four-line Copilot instructions file."
fi

if ! grep -q 'quantity >= 2' "$pricing"; then
  echo "Warning: src/pricing.js no longer contains the lab bug (quantity >= 2)." >&2
fi

if [[ ! -d "$app/.git" ]]; then
  git -C "$app" init
  git -C "$app" config user.name "Lab Delegate"
  git -C "$app" config user.email "delegate@lab.local"
  git -C "$app" add -A
  git -C "$app" commit -m "Lab start: keep the quantity discount bug."
  echo "Created a Git repository in lab/app so Copilot can load instruction files."
fi

top="$(git -C "$app" rev-parse --show-toplevel)"
if [[ "$top" != "$app" ]]; then
  echo "Git root is '$top'. Copilot must be started in lab/app with that folder as the Git root." >&2
  exit 1
fi

echo "Git root: $top"
echo
echo "Preparation finished."
echo "Next: open lab/app in VS Code and follow docs/lab-steps.md from step 3."
