#!/bin/bash
# install_prepack.sh: run a prepack preset for a given desktop environment
# Usage: install_prepack.sh <de> [preset]

set -e

DE="$1"
PRESET="$2"
DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$DE" ]; then
    echo "[GHCS]: No DE provided to install_prepack.sh"; exit 1
fi

# Ask user for preset if not provided
if [ -z "$PRESET" ]; then
    echo "Select package preset to install for $DE:"
    echo "1) minimal"
    echo "2) standard"
    echo "3) full"
    read -p "Choice [1-3]: " p
    case $p in
        1) PRESET=minimal ;;
        2) PRESET=standard ;;
        3) PRESET=full ;;
        *) PRESET=standard ;;
    esac
fi

# map DE to prepack folder name
case "$DE" in
    mate) FOLDER="prepack_appliactions_MATE" ;;
    xfce4) FOLDER="prepack_appliactions_XFCE4" ;;
    lxqt) FOLDER="prepack_appliactions_LXQT" ;;
    headless) FOLDER="prepack_appliactions_headless" ;;
    *) FOLDER="prepack_appliactions_${DE^^}" ;;
esac

PREPACK_DIR="$DIR/utils_prepack/$FOLDER"
SCRIPT="$PREPACK_DIR/preset_packages_${PRESET}.sh"

if [ -f "$SCRIPT" ]; then
    echo "[GHCS]: Running prepack preset '$PRESET' for $DE"
    bash "$SCRIPT"
else
    echo "[GHCS]: No prepack script found at $SCRIPT — skipping prepack step."
fi

# Record selection to info.json for future cleanup or change
INFO_JSON="$DIR/../info.json"
if command -v jq >/dev/null 2>&1; then
    if [ -f "$INFO_JSON" ]; then
        jq --arg de "$DE" --arg preset "$PRESET" '.InstalledDE=$de | .InstalledPreset=$preset | .InstalledEnviroment=true' "$INFO_JSON" > tmp.$$.json && mv tmp.$$.json "$INFO_JSON"
    else
        echo "{\"InstalledEnviroment\": true, \"InstalledDE\": \"$DE\", \"InstalledPreset\": \"$PRESET\"}" > "$INFO_JSON"
    fi
else
    if [ -f "$INFO_JSON" ]; then
        # best-effort append/update
        sed -i '/InstalledDE/d' "$INFO_JSON" || true
        sed -i '/InstalledPreset/d' "$INFO_JSON" || true
        sed -i '/InstalledEnviroment/d' "$INFO_JSON" || true
        tmp="$(cat "$INFO_JSON" | sed 's/}\s*$/,&/')"
        echo "$tmp \"InstalledEnviroment\": true, \"InstalledDE\": \"$DE\", \"InstalledPreset\": \"$PRESET\"}" > "$INFO_JSON" || echo "{\"InstalledEnviroment\": true, \"InstalledDE\": \"$DE\", \"InstalledPreset\": \"$PRESET\"}" > "$INFO_JSON"
    else
        echo "{\"InstalledEnviroment\": true, \"InstalledDE\": \"$DE\", \"InstalledPreset\": \"$PRESET\"}" > "$INFO_JSON"
    fi
fi
