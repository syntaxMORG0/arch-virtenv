#!/bin/bash
# enable_noVNC.sh: Cleans up stale locks, restarts VNC server, and starts noVNC

set -e

export DISPLAY=:1
NOVNC_DIR="/opt/noVNC"
WEBSOCKIFY_DIR="/opt/websockify"
PORT=6080
VNC_PORT=5901

echo "[GHCS]: Cleaning up stale VNC/X lock and socket files..."
sudo rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

echo "[GHCS]: Killing any running VNC server on :1..."
vncserver -kill :1 || true

echo "[GHCS]: Starting TigerVNC server on :1..."
vncserver :1

echo "[GHCS]: Starting noVNC/websockify on 0.0.0.0:6080 -> localhost:5901..."
nohup "$WEBSOCKIFY_DIR/run" 0.0.0.0:$PORT localhost:$VNC_PORT --web "$NOVNC_DIR" --wrap-mode=ignore &
sleep 2
echo "[GHCS]: noVNC is running at http://localhost:$PORT/ (or Codespaces public URL)."
