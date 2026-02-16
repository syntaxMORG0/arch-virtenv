#!/bin/bash
set -e

# Unified startup script: selects environment, installs VNC/noVNC utilities, and exposes noVNC.
DIR="$(cd "$(dirname "$0")" && pwd)"
INFO_JSON="$DIR/info.json"

ensure_installed_env() {
    if [ ! -f "$INFO_JSON" ]; then
        return 1
    fi
    if command -v jq >/dev/null 2>&1; then
        jq -e '.InstalledEnviroment == true' "$INFO_JSON" >/dev/null 2>&1
        return $?
    else
        grep -q '"InstalledEnviroment": *true' "$INFO_JSON" >/dev/null 2>&1
        return $?
    fi
}

mark_installed_env() {
    if command -v jq >/dev/null 2>&1; then
        if [ -f "$INFO_JSON" ]; then
            jq '.InstalledEnviroment = true' "$INFO_JSON" > tmp.$$.json && mv tmp.$$.json "$INFO_JSON"
        else
            echo '{"InstalledEnviroment": true}' > "$INFO_JSON"
        fi
    else
        if [ -f "$INFO_JSON" ]; then
            if grep -q '"InstalledEnviroment"' "$INFO_JSON"; then
                sed -E 's/("InstalledEnviroment"[[:space:]]*:[[:space:]]*)(true|false)/\1true/' "$INFO_JSON" > tmp.$$.json && mv tmp.$$.json "$INFO_JSON" || true
            else
                cp "$INFO_JSON" "$INFO_JSON".bak || true
                # Best-effort: append the InstalledEnviroment flag (may break complex JSON structures)
                awk 'BEGIN{print "{"; print "  \"InstalledEnviroment\": true"; print "}"; exit}' > tmp.$$.json && mv tmp.$$.json "$INFO_JSON" || echo '{"InstalledEnviroment": true}' > "$INFO_JSON"
            fi
        else
            echo '{"InstalledEnviroment": true}' > "$INFO_JSON"
        fi
    fi
}

if ! ensure_installed_env; then
    echo "[GHCS]: No desktop selected yet — launching EnviromentInstaller."
    bash "$DIR/utils/EnviromentInstaller.sh"
    mark_installed_env
fi

# Install VNC / noVNC utilities (idempotent)
if [ -f "$DIR/utils/utils_VNC/install_VNC.sh" ]; then
    bash "$DIR/utils/utils_VNC/install_VNC.sh"
fi
if [ -f "$DIR/utils/utils_VNC/install_noVNC.sh" ]; then
    bash "$DIR/utils/utils_VNC/install_noVNC.sh"
fi
if [ -f "$DIR/utils/install_Utils.sh" ]; then
    bash "$DIR/utils/install_Utils.sh"
fi

# VNC password handling: prompt user with a sensible default
VNC_PASS_FILE="$HOME/.vnc/passwd"
if [ -f "$VNC_PASS_FILE" ]; then
    echo "[GHCS]: VNC password already configured. Press ENTER to keep it or type a new password (input hidden):"
    read -s NEWPW
    echo
    if [ -n "$NEWPW" ]; then
        mkdir -p "$HOME/.vnc"
        echo "$NEWPW" | vncpasswd -f > "$VNC_PASS_FILE"
        chmod 600 "$VNC_PASS_FILE"
        echo "[GHCS]: VNC password updated."
    else
        echo "[GHCS]: Keeping existing VNC password."
    fi
else
    echo "[GHCS]: No VNC password found. Press ENTER to use the default password 'vncpass' or type a new one (input hidden):"
    read -s PW
    echo
    PW=${PW:-vncpass}
    mkdir -p "$HOME/.vnc"
    echo "$PW" | vncpasswd -f > "$VNC_PASS_FILE"
    chmod 600 "$VNC_PASS_FILE"
    echo "[GHCS]: VNC password configured."
fi

# Start VNC and expose via noVNC using the unified expose script
if [ -f "$DIR/utils/utils_VNC/expose.sh" ]; then
    bash "$DIR/utils/utils_VNC/expose.sh"
else
    echo "[GHCS]: expose.sh not found in utils_VNC — attempting legacy utils_expose path"
    if [ -f "$DIR/utils/utils_expose/expose.sh" ]; then
        bash "$DIR/utils/utils_expose/expose.sh"
    else
        echo "[GHCS]: ERROR: No expose.sh found. Aborting." >&2
        exit 1
    fi
fi

echo "[GHCS]: run.sh completed. noVNC should be available at http://localhost:6080/ (or Codespaces public URL)."

# Optionally generate GitHub link if script exists
if [ -f "$DIR/utils/utils_expose/generate_gh_link.sh" ]; then
    bash "$DIR/utils/utils_expose/generate_gh_link.sh"
fi
