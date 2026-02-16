#!/bin/bash
# enable_noVNC.sh: Starts noVNC server

set -e

# Set display and websockify port
export DISPLAY=:1
NOVNC_DIR="/opt/noVNC"
WEBSOCKIFY_DIR="/opt/websockify"
PORT=6080

# Start websockify and noVNC, listen on all interfaces for Codespaces
nohup "$WEBSOCKIFY_DIR/run" 0.0.0.0:$PORT --web "$NOVNC_DIR" --wrap-mode=ignore &

echo "noVNC server enabled on 0.0.0.0:$PORT."
