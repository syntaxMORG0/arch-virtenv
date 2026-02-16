#!/bin/bash
# install_LXQT.sh: Installs LXQt desktop environment

set -e

echo "[GHCS]: Installing LXQt and related packages..."
sudo pacman -Sy --noconfirm lxqt sddm

echo "[GHCS]: LXQt installation complete."

# Run prepack if requested
if [ -n "$PREPACK_CHOICE" ]; then
	DIR="$(cd "$(dirname "$0")/.." && pwd)"
	if [ -x "$DIR/install_prepack.sh" ]; then
		bash "$DIR/install_prepack.sh" lxqt "$PREPACK_CHOICE"
	fi
fi
