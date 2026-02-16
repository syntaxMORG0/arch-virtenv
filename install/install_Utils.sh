#!/bin/bash
# install_Utils.sh: Installs utility packages

set -e

sudo pacman -Sy --noconfirm curl wget git nano unzip zip

echo "Utility packages installation complete."
