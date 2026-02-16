#!/bin/bash
# install_MATE.sh: Installs MATE desktop environment

set -e

# Update package lists
sudo pacman -Sy --noconfirm

# Install MATE and related packages
sudo pacman -Sy --noconfirm mate mate-extra

echo "MATE installation complete."
