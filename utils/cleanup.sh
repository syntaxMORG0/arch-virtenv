#!/usr/bin/env bash
# cleanup.sh - remove packages installed by previous prepack preset
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
INFO_JSON="$DIR/../info.json"

if [ ! -f "$INFO_JSON" ]; then
  echo "[GHCS]: No info.json found; nothing to clean."; exit 0
fi

# read InstalledDE and InstalledPreset
if command -v jq >/dev/null 2>&1; then
  DE=$(jq -r '.InstalledDE // empty' "$INFO_JSON")
  PRESET=$(jq -r '.InstalledPreset // empty' "$INFO_JSON")
else
  DE=$(grep -oP '"InstalledDE"\s*:\s*"\K[^"]+' "$INFO_JSON" || true)
  PRESET=$(grep -oP '"InstalledPreset"\s*:\s*"\K[^"]+' "$INFO_JSON" || true)
fi

if [ -z "$DE" ] || [ -z "$PRESET" ]; then
  echo "[GHCS]: No previous DE/preset recorded; nothing to clean."; exit 0
fi

PREPACK_DIR="$DIR/utils_prepack/prepack_appliactions_${DE^^}"
# Fallback folder names
if [ ! -d "$PREPACK_DIR" ]; then
  # try common names
  PREPACK_DIR="$DIR/utils_prepack/prepack_appliactions_${DE,,}"
fi

SCRIPT="$PREPACK_DIR/preset_packages_${PRESET}.sh"
if [ ! -f "$SCRIPT" ]; then
  echo "[GHCS]: No preset script found at $SCRIPT; cannot determine packages to remove."; exit 0
fi

## Gather packages from both the DE installer and the prepack preset (pacman -S usage)
gather_pkgs_from_script() {
  local f="$1"
  if [ ! -f "$f" ]; then
    return
  fi
  # Match lines invoking pacman with -S, capture the rest of the line
  grep -oE "pacman[[:space:]]+[^\n]*-S[^\n]*" "$f" 2>/dev/null | \
    sed -E 's/.*-S[[:space:]]+//' | \
    sed -E 's/--[a-zA-Z0-9-]+//g' | \
    sed -E 's/-[a-zA-Z0-9]+//g' | \
    sed -E 's/[;&|].*$//' | \
    tr '\n' ' ' || true
}

PKGS_ALL=""

# packages from preset script
PKGS_PRESET="$(gather_pkgs_from_script "$SCRIPT")"
PKGS_ALL="$PKGS_ALL $PKGS_PRESET"

# attempt to find DE installer script and gather its packages
DE_INSTALL_SCRIPT=""
case "${DE,,}" in
  mate)
    DE_INSTALL_SCRIPT="$DIR/../utils/env_MATE/install_MATE.sh" ;;
  xfce4)
    DE_INSTALL_SCRIPT="$DIR/../utils/env_Xfce4/install_XFCE4.sh" ;;
  lxqt)
    DE_INSTALL_SCRIPT="$DIR/../utils/env_LXQT/install_LXQT.sh" ;;
  headless)
    DE_INSTALL_SCRIPT="$DIR/../utils/env_headless/install_headless.sh" ;;
  *)
    DE_INSTALL_SCRIPT="$DIR/../utils/env_${DE}/install_${DE}.sh" ;;
esac

PKGS_DE="$(gather_pkgs_from_script "$DE_INSTALL_SCRIPT")"
PKGS_ALL="$PKGS_ALL $PKGS_DE"

# Normalize, split, uniq
PKG_LIST="$(echo "$PKGS_ALL" | tr ' ' '\n' | sed '/^\s*$/d' | sed 's/\s\+//g' | sort -u | tr '\n' ' ' )"

if [ -z "$PKG_LIST" ]; then
  echo "[GHCS]: No package install lines found in installer/preset scripts; nothing to remove."; exit 0
fi

echo "[GHCS]: Detected packages to remove: $PKG_LIST"
read -p "Do you want to proceed and remove these packages? [y/N]: " CONF
if [[ ! "$CONF" =~ ^[Yy]$ ]]; then
  echo "Aborted cleanup."; exit 0
fi

# Remove packages via pacman
echo "[GHCS]: Removing packages..."
sudo pacman -Rns --noconfirm $PKG_LIST || true

echo "[GHCS]: Cleanup finished."

# Remove info.json entries
if command -v jq >/dev/null 2>&1; then
  jq 'del(.InstalledDE, .InstalledPreset, .InstalledEnviroment)' "$INFO_JSON" > tmp.$$.json && mv tmp.$$.json "$INFO_JSON" || true
else
  sed -i '/InstalledDE/d' "$INFO_JSON" || true
  sed -i '/InstalledPreset/d' "$INFO_JSON" || true
  sed -i '/InstalledEnviroment/d' "$INFO_JSON" || true
fi
