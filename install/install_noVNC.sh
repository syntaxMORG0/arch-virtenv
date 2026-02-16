#!/bin/bash
# install_noVNC.sh: Installs noVNC and its dependencies

set -e

# Install dependencies
sudo apt update
sudo apt install -y git python3 python3-pip websockify

# Clone noVNC repository if not already present
if [ ! -d "/opt/noVNC" ]; then
    sudo git clone https://github.com/novnc/noVNC.git /opt/noVNC
fi

# Install websockify if not already present
if [ ! -d "/opt/websockify" ]; then
    sudo git clone https://github.com/novnc/websockify.git /opt/websockify
fi

echo "noVNC installation complete."
