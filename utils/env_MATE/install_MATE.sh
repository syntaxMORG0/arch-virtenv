#!/bin/bash
# install_MATE.sh: Installs MATE desktop environment

set -e

# Update package lists
echo "[GHCS]: Starting MATE desktop installation..."
echo "[GHCS]: Updating package lists..."
sudo pacman -Sy --noconfirm

# Install MATE and related packages
echo "[GHCS]: Installing MATE and mate-extra packages..."
sudo pacman -Sy --noconfirm mate mate-extra

echo "MATE installation complete."
echo "[GHCS]: MATE installation complete."

# If PREPACK_CHOICE provided, run prepack helper
if [ -n "$PREPACK_CHOICE" ]; then
	DIR="$(cd "$(dirname "$0")/.." && pwd)"
	if [ -x "$DIR/install_prepack.sh" ]; then
		bash "$DIR/install_prepack.sh" mate "$PREPACK_CHOICE"
	fi
fi
