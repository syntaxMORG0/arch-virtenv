#!/bin/bash
# install_headless.sh: Sets up a minimal headless environment (terminal + utils)

set -e

echo "[GHCS]: Installing headless utilities..."
# Install a few helpful packages; adjust as needed
sudo pacman -Sy --noconfirm bash-completion tmux htop nano

echo "[GHCS]: Headless environment setup complete."

# Run prepack if requested
if [ -n "$PREPACK_CHOICE" ]; then
	DIR="$(cd "$(dirname "$0")/.." && pwd)"
	if [ -x "$DIR/install_prepack.sh" ]; then
		bash "$DIR/install_prepack.sh" headless "$PREPACK_CHOICE"
	fi
fi
