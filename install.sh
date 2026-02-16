#!/usr/bin/env bash
set -e

# install.sh - Complete installer and preflight helper
# - Makes repo scripts executable
# - Runs basic preflight checks
# - Launches the guided `run.sh` installer

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS=(
  "$REPO_ROOT/run.sh"
  "$REPO_ROOT/utils/EnviromentInstaller.sh"
  "$REPO_ROOT/utils/changeEnv.sh"
  "$REPO_ROOT/utils/install_prepack.sh"
)

# Add installers and VNC scripts
for f in "$REPO_ROOT"/utils/env_*/*.sh "$REPO_ROOT"/utils/utils_VNC/*.sh "$REPO_ROOT"/utils/utils_expose/*.sh "$REPO_ROOT"/utils/utils_prepack/**/preset_packages_*.sh; do
  SCRIPTS+=("$f")
done

echo "[GHCS]: Running preflight checks..."

# Check for sudo
if ! command -v sudo >/dev/null 2>&1; then
  echo "[GHCS]: WARNING: 'sudo' not found. Some install steps may need root.
"
fi

# Check for pacman (Arch)
if ! command -v pacman >/dev/null 2>&1; then
  echo "[GHCS]: WARNING: 'pacman' not found. This repository targets Arch Linux.
"
fi

# Check for vncserver (TigerVNC)
if ! command -v vncserver >/dev/null 2>&1; then
  echo "[GHCS]: NOTE: 'vncserver' not found. The installer will attempt to install tigervnc when needed."
fi

# Make scripts executable (best-effort)
echo "[GHCS]: Making installer scripts executable..."
for s in "${SCRIPTS[@]}"; do
  if [ -f "$s" ]; then
    chmod +x "$s" || true
  fi
done

# Ensure utils/install_prepack.sh is executable
if [ -f "$REPO_ROOT/utils/install_prepack.sh" ]; then
  chmod +x "$REPO_ROOT/utils/install_prepack.sh" || true
fi

cat <<EOF
[GHCS]: Preflight complete.
- Scripts were made executable where found.
- If this is the first run, you will be prompted to select a desktop environment and packages.

Ready to start the guided installer now? (y/N)
EOF

read -r REPLY
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  echo "[GHCS]: Launching run.sh..."
  bash "$REPO_ROOT/run.sh"
else
  echo "[GHCS]: Install aborted. To start later run: bash install.sh"
fi
