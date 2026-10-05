# Image-builder check. Run from a clone after prepare-lab.ps1.
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$app = Join-Path $root "lab\app"
$failed = $false

function Check([string]$Name, [bool]$Ok, [string]$Detail) {
    if ($Ok) {
        Write-Host "PASS  $Name"
    } else {
        Write-Host "FAIL  $Name - $Detail"
        $script:failed = $true
    }
}

$nodeVersion = ""
try {
    $nodeVersion = (& node --version 2>&1 | Out-String).Trim()
} catch {
    $nodeVersion = ""
}
$nodeOk = $nodeVersion -match '^v(\d+)\.' -and [int]$Matches[1] -ge 22
Check "Node.js 22 or later" $nodeOk "found '$nodeVersion'"

$gitOk = $false
try {
    & git --version | Out-Null
    $gitOk = $LASTEXITCODE -eq 0
} catch {
    $gitOk = $false
}
Check "Git on PATH" $gitOk "git --version failed"

$copilotOk = [bool](Get-Command copilot -ErrorAction SilentlyContinue)
Check "Copilot CLI on PATH" $copilotOk "install with: winget install GitHub.Copilot"

$instructionsPath = Join-Path $app ".github\copilot-instructions.md"
$instructionsOk = (Test-Path -LiteralPath $instructionsPath) -and ((Get-Content -LiteralPath $instructionsPath -Raw) -match '(?m)^Code only, no explanation\.')
Check "Lean Copilot instructions" $instructionsOk "file must start with 'Code only, no explanation.'"

$pricingPath = Join-Path $app "src\pricing.js"
$pricingOk = (Test-Path -LiteralPath $pricingPath) -and ((Get-Content -LiteralPath $pricingPath -Raw) -match 'quantity >= 2')
Check "Pricing bug still present" $pricingOk "src\pricing.js must contain quantity >= 2"

$gitRootOk = $false
$gitDetail = "lab\app is not a Git repository. Run scripts\prepare-lab.ps1"
if (Test-Path -LiteralPath (Join-Path $app ".git")) {
    $top = (& git -C $app rev-parse --show-toplevel | Out-String).Trim()
    $expected = (Resolve-Path -LiteralPath $app).Path.TrimEnd('\')
    $actual = [System.IO.Path]::GetFullPath($top).TrimEnd('\')
    $gitRootOk = $actual -eq $expected
    $gitDetail = "git root is '$top'"
}
Check "Git root is lab\app" $gitRootOk $gitDetail

Push-Location -LiteralPath $app
try {
    $testOutput = (& node --test 2>&1 | Out-String)
} finally {
    Pop-Location
}
$testsOk = $testOutput -match '# fail 2' -or ($testOutput -match 'not ok 2' -and $testOutput -match '# pass 1')
if (-not $testsOk) {
    $testsOk = ($testOutput -match 'fail 2') -and ($testOutput -match 'pass 1')
}
Check "Tests: 1 passing, 2 failing" $testsOk "node --test output did not show 1 pass and 2 fails"

$estimator = Join-Path $root "lab\tools\estimate-tokens.mjs"
$estimateOutput = (& node $estimator (Join-Path $app ".github\copilot-instructions.md") (Join-Path $root "lab\fixtures\copilot-instructions.bloated.md") 2>&1 | Out-String)
$estimateOk = $estimateOutput -match 'copilot-instructions\.md\s+\d+\s+\d+\s+40' -and $estimateOutput -match 'copilot-instructions\.bloated\.md\s+\d+\s+\d+\s+2378'
Check "Estimator about 40 vs 2378" $estimateOk "unexpected estimator output"

if ($failed) {
    Write-Host ""
    Write-Host "Image check failed."
    exit 1
}

Write-Host ""
Write-Host "Image check passed. Copilot login is still a manual pilot: copilot login, then /instructions and /context."
exit 0
