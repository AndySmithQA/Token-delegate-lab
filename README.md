# Spend less, ship the same — delegate lab

Base files for the 30-minute online lab that follows the live course **Spend less, ship the same**. Delegates clone this repository and follow the steps. The sample project is AndyCorp Lite, a small order-pricing app with one intentional bug.

Trainer notes and the answer key are not in this repository.

## Course owner: fill these in before you publish the link

| Item | Value |
| --- | --- |
| Lab URL | This GitHub repository |
| Submit the scorecard to | _insert route_ |
| Deadline | _insert date_ |
| Help | _insert support channel_ |

## What a delegate does

1. Use a machine that matches [docs/image-requirements.md](docs/image-requirements.md).
2. Clone this repository.
3. Run the prepare script.
4. Follow [docs/lab-steps.md](docs/lab-steps.md) from step 1.
5. Record results in [delegate/scorecard.md](delegate/scorecard.md) and submit that file.

The same lab, written as the course workbook, is [delegate/workbook.md](delegate/workbook.md). The step file is the one to follow after cloning. It uses the same parts A–E.

## Clone and prepare

```powershell
git clone <repository-url> token-delegate-lab
cd token-delegate-lab
powershell -ExecutionPolicy Bypass -File .\scripts\prepare-lab.ps1
```

On macOS or Linux, including a GitHub Codespace:

```bash
git clone <repository-url> token-delegate-lab
cd token-delegate-lab
bash scripts/prepare-lab.sh
```

Then open `lab/app` in VS Code. Do not open the repository root as the Copilot workspace.

## Layout

```text
docs/image-requirements.md   Machine image the lab must run on
docs/lab-steps.md             Every delegate step
delegate/scorecard.md         What delegates fill in and submit
delegate/workbook.md          Course workbook
scripts/prepare-lab.ps1       Windows setup after clone
scripts/prepare-lab.sh        macOS, Linux, and Codespaces setup
scripts/verify-image.ps1      Image-builder acceptance check
scripts/verify-image.sh       Same check on macOS or Linux
lab/app                       AndyCorp Lite. This is the folder delegates open.
lab/fixtures                  Files to measure. Do not load the bloated ones into Copilot.
lab/tools                     Token estimator and bundle writer. No npm install.
.devcontainer                 Codespace definition for the browser lab
```

`lab/app` must be its own Git repository. Copilot CLI loads `.github/copilot-instructions.md` from the working directory up to the Git root. The prepare script creates that repository and makes the first commit, with the pricing bug still in place.

## Check the app before handing the image to delegates

From `lab/app`, after prepare:

```powershell
node --test
node ..\tools\estimate-tokens.mjs .github\copilot-instructions.md ..\fixtures\copilot-instructions.bloated.md
```

`node --test` must fail two tests and pass one. Quantity 2 returns 108 and the test expects 120. The bloated instructions file must estimate far above the four-line Copilot file (about 2,400 tokens versus about 40).

There is no `npm install`. The app has no dependencies.
