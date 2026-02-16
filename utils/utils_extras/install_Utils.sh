#!/bin/bash
# install_Utils.sh: Installs utility packages

set -e


echo "[GHCS]: Starting utility packages installation..."
echo "[GHCS]: Installing curl, wget, git, nano, unzip, zip..."
sudo pacman -Sy --noconfirm curl wget git nano unzip zip

echo "Utility packages installation complete."
echo "[GHCS]: Utility packages installation complete."
