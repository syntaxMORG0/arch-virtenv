#!/bin/bash
# changeEnv.sh: Utility to change the desktop environment interactively

set -e

# Reset the environment flag in info.json (or create if missing)
INFO_JSON="info.json"
if [ ! -f "$INFO_JSON" ]; then
    echo '{"InstalledEnviroment": false}' > "$INFO_JSON"
else
    # Prefer jq if available, otherwise do a safe text-based update
    if command -v jq >/dev/null 2>&1; then
        jq '.InstalledEnviroment = false' "$INFO_JSON" > tmp.$$.json && mv tmp.$$.json "$INFO_JSON"
    else
        # If InstalledEnviroment exists, replace its value; otherwise insert before final }
        if grep -q 'InstalledEnviroment' "$INFO_JSON"; then
            sed -E 's/("InstalledEnviroment"[[:space:]]*:[[:space:]]*)(true|false)/\1false/' "$INFO_JSON" > tmp.$$.json && mv tmp.$$.json "$INFO_JSON"
        else
            # attempt to insert before trailing brace
            awk 'BEGIN{printed=0}{if(!printed && /}/){sub(/}/,",\n  \"InstalledEnviroment\": false\n}"); printed=1} print}' "$INFO_JSON" > tmp.$$.json && mv tmp.$$.json "$INFO_JSON" || echo '{"InstalledEnviroment": false}' > "$INFO_JSON"
        fi
    fi
fi

echo "[GHCS]: Desktop environment selection will be triggered on next run."
echo "[GHCS]: You can now re-run run.sh to select a new environment."
echo "[GHCS]: If you want to change now, run: bash run.sh"
