#!/bin/bash
# enable_XdisplayServer.sh: Starts X display server (Xvfb)

set -e


# Install Xvfb if not present
sudo pacman -Sy --noconfirm xorg-server-xvfb

# Start Xvfb on display :1
nohup Xvfb :1 -screen 0 1024x768x16 &

export DISPLAY=:1

# Start TigerVNC server on display :1
vncserver :1 -geometry 1024x768 -depth 16

echo "X display server and VNC enabled on :1."
