#!/bin/bash
# install_Utils.sh: Installs utility packages

set -e

sudo apt update
sudo apt install -y curl wget git nano unzip zip

echo "Utility packages installation complete."
