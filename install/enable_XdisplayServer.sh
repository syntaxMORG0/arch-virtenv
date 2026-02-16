#!/bin/bash
# enable_XdisplayServer.sh: Starts X display server (Xvfb)

set -e

# Install Xvfb if not present
sudo apt update
sudo apt install -y xvfb

# Start Xvfb on display :1
nohup Xvfb :1 -screen 0 1024x768x16 &

export DISPLAY=:1

echo "X display server enabled on :1."
