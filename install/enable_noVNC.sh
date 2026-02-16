#!/bin/bash
# enable_noVNC.sh: Starts noVNC server

set -e

# Set display and websockify port
export DISPLAY=:1
NOVNC_DIR="/opt/noVNC"
WEBSOCKIFY_DIR="/opt/websockify"
PORT=6080

# Start websockify and noVNC
nohup "$WEBSOCKIFY_DIR/run" $PORT --web "$NOVNC_DIR" --wrap-mode=ignore &

echo "noVNC server enabled on port $PORT."
