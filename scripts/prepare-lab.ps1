# Requires Windows PowerShell 5.1 or later.
# Run from anywhere: powershell -File .\scripts\prepare-lab.ps1
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$app = Join-Path $root "lab\app"
$lean = Join-Path $root "lab\fixtures\copilot-instructions.lean.md"
$instructions = Join-Path $app ".github\copilot-instructions.md"
$pricing = Join-Path $app "src\pricing.js"

function Fail([string]$Message) {
    Write-Error $Message
    exit 1
}

if (-not (Test-Path -LiteralPath $app)) {
    Fail "lab\app was not found. Run this script from a clone of the delegate lab repository."
}

$nodeVersion = (& node --version 2>&1 | Out-String).Trim()
if ($nodeVersion -notmatch '^v(\d+)\.') {
    Fail "Node.js is not on PATH. Install Node.js 22 or later and open a new terminal."
}
if ([int]$Matches[1] -lt 22) {
    Fail "Node.js 22 or later is required. Found $nodeVersion."
}
Write-Host "Node.js $nodeVersion"

& git --version | Out-Null
if ($LASTEXITCODE -ne 0) {
    Fail "Git is not on PATH."
}

if (-not (Get-Command copilot -ErrorAction SilentlyContinue)) {
    Write-Warning "copilot is not on PATH. Install GitHub Copilot CLI, open a new terminal, then run: copilot login"
}

$currentInstructions = Get-Content -LiteralPath $instructions -Raw
if ($currentInstructions -notmatch '(?m)^Code only, no explanation\.') {
    Copy-Item -LiteralPath $lean -Destination $instructions -Force
    Write-Host "Restored the four-line Copilot instructions file."
}

$pricingText = Get-Content -LiteralPath $pricing -Raw
if ($pricingText -notmatch 'quantity >= 2') {
    Write-Warning "src\pricing.js no longer contains the lab bug (quantity >= 2). Restore the shipped file before measuring tests."
}

Push-Location -LiteralPath $app
try {
    $hasGit = Test-Path -LiteralPath (Join-Path $app ".git")
    if (-not $hasGit) {
        & git init | Out-Null
        & git config user.name "Lab Delegate"
        & git config user.email "delegate@lab.local"
        & git add -A
        & git commit -m "Lab start: keep the quantity discount bug." | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Fail "Could not create the starting commit in lab\app."
        }
        Write-Host "Created a Git repository in lab\app so Copilot can load instruction files."
    }

    $top = (& git rev-parse --show-toplevel | Out-String).Trim()
    $expected = (Resolve-Path -LiteralPath $app).Path.TrimEnd('\')
    $actual = [System.IO.Path]::GetFullPath($top).TrimEnd('\')
    if ($actual -ne $expected) {
        Fail "Git root is '$top'. Copilot must be started in lab\app with that folder as the Git root. Remove any extra .git above lab\app only if you know this clone is disposable, then run this script again."
    }
    Write-Host "Git root: $top"
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "Preparation finished."
Write-Host "Next: open lab\app in VS Code and follow docs\lab-steps.md from step 3."
