#!/bin/bash
# install_XFCE4.sh: Installs XFCE4 desktop environment

set -e

echo "[GHCS]: Installing XFCE4 and related packages..."
sudo pacman -Sy --noconfirm xfce4 xfce4-goodies

echo "[GHCS]: XFCE4 installation complete."

# Run prepack if requested
if [ -n "$PREPACK_CHOICE" ]; then
	DIR="$(cd "$(dirname "$0")/.." && pwd)"
	if [ -x "$DIR/install_prepack.sh" ]; then
		bash "$DIR/install_prepack.sh" xfce4 "$PREPACK_CHOICE"
	fi
fi
