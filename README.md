 # arch-virtenv — Codespaces VNC Desktop

## Overview
This repository provides a guided installer to run a lightweight Arch Linux desktop inside GitHub Codespaces (or any Arch environment) and expose it in your browser using noVNC.

Key points:
- Interactive TUI to choose a desktop environment (MATE, XFCE4, LXQt, Headless)
- Prepack presets (minimal / standard / full) for installing application sets per DE
- TigerVNC for the desktop, noVNC (websockify) for browser access
- Single entrypoint: `install.sh` (guided) which runs `run.sh` under the hood

**Designed for developers and safe to run inside Codespaces.**

## Quick Start (one command)
1. Make the installer executable and run it:

```bash
chmod +x install.sh
bash install.sh
```

2. The script will:
- Run preflight checks and make installer scripts executable.
- Launch the guided installer (`run.sh`) if no environment is selected.
- Present a TUI to pick a desktop environment and package preset.
- Prompt (hidden) for a VNC password, then start TigerVNC and noVNC.

3. Open the desktop in your browser at:

- http://localhost:6080/  (or your Codespaces public URL ending with `:6080`)

## Installer flow and commands
- `install.sh` — preflight, chmod +x, then runs `run.sh` (recommended for non-technical users)
- `run.sh` — unified startup: if `info.json` lacks `InstalledEnviroment: true` it runs `utils/EnviromentInstaller.sh`, then installs VNC/noVNC and exposes the desktop
- `utils/EnviromentInstaller.sh` — TUI to choose DE and run prepack presets
- `utils/install_prepack.sh` — helper that runs a preset script under `utils/utils_prepack/` (minimal/standard/full)
- `utils/changeEnv.sh` — resets `info.json` so `run.sh` will re-run the TUI

Example manual flow:

```bash
bash utils/changeEnv.sh   # reset if needed
bash run.sh              # guided selection and start
```

## Prepack presets
Under `utils/utils_prepack/` there are per-DE preset folders. Presets are application sets only (they do not install the desktop). Presets:
- `minimal` — essential apps (file manager, terminal)
- `standard` — dev tools + browser
- `full` — full desktop experience with common utilities

The TUI will ask which preset to install after selecting a DE. You can also run `utils/install_prepack.sh <de>` to be prompted manually.

## Replacing the Desktop (change environment)
If the user wants a different desktop later:

```bash
bash utils/changeEnv.sh
bash run.sh
```

This resets the selection and re-runs the TUI so you can pick a different DE and presets.

## Troubleshooting & Notes
- This project targets Arch Linux (uses `pacman`). Running on other distros will require editing `install_*` scripts.
- Recommended: install `jq` for safe `info.json` edits. Without `jq` the scripts do best-effort text updates.
- If you get lock errors, run:

```bash
sudo rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1
```

- If noVNC doesn't start, check that `/opt/noVNC` and `/opt/websockify` exist (install scripts clone them to `/opt`).
- VNC password: the installer will prompt for a password (hidden). Default if skipped is `vncpass` — change it using `vncpasswd`.

## For giving to non-technical users (grandma-ready)
1. Run `chmod +x install.sh` once.
2. Run `bash install.sh` and follow the simple TUI prompts.
3. Open the provided URL in a browser.

If you'd like, I can add a fully non-interactive `--yes` mode so the whole process runs unattended with sensible defaults.

## Repository
[https://github.com/syntaxMORG0/arch-virtenv](https://github.com/syntaxMORG0/arch-virtenv)

## License
See `LICENSE` for details.