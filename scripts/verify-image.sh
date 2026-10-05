#!/usr/bin/env bash
# Image-builder check. Run from a clone after prepare-lab.sh.
set -u

root="$(cd "$(dirname "$0")/.." && pwd)"
app="$root/lab/app"
failed=0

check() {
  local name="$1"
  local ok="$2"
  local detail="$3"
  if [[ "$ok" -eq 0 ]]; then
    echo "PASS  $name"
  else
    echo "FAIL  $name — $detail"
    failed=1
  fi
}

node_version="$(node --version 2>/dev/null || true)"
node_major="${node_version#v}"
node_major="${node_major%%.*}"
if [[ "$node_version" == v* ]] && [[ "$node_major" -ge 22 ]]; then
  check "Node.js 22 or later" 0 ""
else
  check "Node.js 22 or later" 1 "found '$node_version'"
fi

if command -v git >/dev/null 2>&1; then
  check "Git on PATH" 0 ""
else
  check "Git on PATH" 1 "git --version failed"
fi

if command -v copilot >/dev/null 2>&1; then
  check "Copilot CLI on PATH" 0 ""
else
  check "Copilot CLI on PATH" 1 "install with: npm install -g @github/copilot"
fi

if grep -q '^Code only, no explanation\.' "$app/.github/copilot-instructions.md"; then
  check "Lean Copilot instructions" 0 ""
else
  check "Lean Copilot instructions" 1 "file must start with 'Code only, no explanation.'"
fi

if grep -q 'quantity >= 2' "$app/src/pricing.js"; then
  check "Pricing bug still present" 0 ""
else
  check "Pricing bug still present" 1 "src/pricing.js must contain quantity >= 2"
fi

if [[ -d "$app/.git" ]]; then
  top="$(git -C "$app" rev-parse --show-toplevel)"
  if [[ "$top" == "$app" ]]; then
    check "Git root is lab/app" 0 ""
  else
    check "Git root is lab/app" 1 "git root is '$top'"
  fi
else
  check "Git root is lab/app" 1 "run scripts/prepare-lab.sh"
fi

test_output="$(cd "$app" && node --test 2>&1 || true)"
if [[ "$test_output" == *"fail 2"* ]] && [[ "$test_output" == *"pass 1"* ]]; then
  check "Tests: 1 passing, 2 failing" 0 ""
else
  check "Tests: 1 passing, 2 failing" 1 "node --test output did not show 1 pass and 2 fails"
fi

estimate_output="$(node "$root/lab/tools/estimate-tokens.mjs" "$app/.github/copilot-instructions.md" "$root/lab/fixtures/copilot-instructions.bloated.md" 2>&1 || true)"
if [[ "$estimate_output" == *" 40"* ]] && [[ "$estimate_output" == *" 2414"* ]]; then
  check "Estimator about 40 vs 2414" 0 ""
else
  check "Estimator about 40 vs 2414" 1 "unexpected estimator output"
fi

if [[ "$failed" -ne 0 ]]; then
  echo
  echo "Image check failed."
  exit 1
fi

echo
echo "Image check passed. Copilot login is still a manual pilot: copilot login, then /instructions and /context."
exit 0
