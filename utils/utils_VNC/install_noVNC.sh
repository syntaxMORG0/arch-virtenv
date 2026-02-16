#!/bin/bash
# install_noVNC.sh: Installs noVNC and its dependencies

set -e


# Install dependencies
echo "[GHCS]: Installing dependencies (git, python, python-pip)..."
sudo pacman -Sy --noconfirm git python python-pip

echo "[GHCS]: Checking for noVNC repository..."
if [ ! -d "/opt/noVNC" ]; then
    echo "[GHCS]: Cloning noVNC repository..."
    sudo git clone https://github.com/novnc/noVNC.git /opt/noVNC
else
    echo "[GHCS]: noVNC repository already present."
fi

echo "[GHCS]: Checking for websockify repository..."
if [ ! -d "/opt/websockify" ]; then
    echo "[GHCS]: Cloning websockify repository..."
    sudo git clone https://github.com/novnc/websockify.git /opt/websockify
else
    echo "[GHCS]: websockify repository already present."
fi

echo "noVNC installation complete."
echo "[GHCS]: noVNC installation complete."
