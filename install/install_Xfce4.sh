#!/bin/bash
# install_Xfce4.sh: Installs Xfce4 desktop environment

set -e

# Update package lists
sudo apt update

# Install Xfce4 and related packages
sudo apt install -y xfce4 xfce4-goodies

echo "Xfce4 installation complete."
