#!/bin/bash
set -e

echo "[GHCS]: Starting expose.sh script..."

# Set environment variables
export DISPLAY=:1
NOVNC_DIR="/opt/noVNC"
WEBSOCKIFY_DIR="/opt/websockify"
PORT=6080
VNC_PORT=5901

# Robust stale lock cleanup for vncserver
if [ -f /tmp/.X1-lock ] && ! pgrep -af "Xvnc.*:1" > /dev/null; then
    echo "[GHCS]: Removing stale /tmp/.X1-lock..."
    sudo rm -f /tmp/.X1-lock
fi
if [ -S /tmp/.X11-unix/X1 ] && ! pgrep -af "Xvnc.*:1" > /dev/null; then
    echo "[GHCS]: Removing stale /tmp/.X11-unix/X1 socket..."
    sudo rm -f /tmp/.X11-unix/X1
fi

# Ensure VNC server is running on :1
echo "[GHCS]: Checking if VNC server is running on :1 (port $VNC_PORT)..."
if pgrep -af "Xvnc.*:1" > /dev/null || pgrep -af "Xtigervnc" > /dev/null; then
    echo "[GHCS]: VNC server is already running."
else
    echo "[GHCS]: VNC server not running. Attempting to start TigerVNC on :1..."
    VNC_OUT=$(vncserver :1 2>&1) || true
    if echo "$VNC_OUT" | grep -q 'A VNC server is already running as'; then
        echo "[GHCS]: VNC server was already running as :1."
    elif echo "$VNC_OUT" | grep -qi 'failed' || echo "$VNC_OUT" | grep -qi 'error'; then
        echo "[GHCS]: ERROR: Failed to start VNC server on :1. Output:"; echo "$VNC_OUT"; exit 1;
    else
        echo "[GHCS]: VNC server started."
    fi
fi

# Debug output for all variables
echo "[GHCS]: DEBUG: NOVNC_DIR=$NOVNC_DIR WEBSOCKIFY_DIR=$WEBSOCKIFY_DIR PORT=$PORT VNC_PORT=$VNC_PORT"

# Check if websockify/noVNC is already running
echo "[GHCS]: Checking if websockify/noVNC is already running on port $PORT..."
if ps aux | grep '[w]ebsockify' | grep -q ":$PORT"; then
    echo "[GHCS]: websockify/noVNC is already running on port $PORT."
else
    if [ ! -x "/opt/websockify/run" ] && [ -f "/opt/websockify/run" ]; then
        chmod +x /opt/websockify/run || true
    fi
    if [ ! -f "/opt/websockify/run" ]; then
        echo "[GHCS]: ERROR: /opt/websockify/run not found. Please install websockify to /opt/websockify."; exit 1;
    fi
    echo "[GHCS]: Starting websockify/noVNC proxy on 0.0.0.0:$PORT -> localhost:$VNC_PORT..."
    nohup /opt/websockify/run 0.0.0.0:$PORT localhost:$VNC_PORT --web /opt/noVNC --wrap-mode=ignore >/tmp/websockify.$$.log 2>&1 &
    sleep 2
    if ps aux | grep '[w]ebsockify' | grep -q ":$PORT"; then
        echo "[GHCS]: websockify/noVNC started successfully."
    else
        echo "[GHCS]: ERROR: Failed to start websockify/noVNC on port $PORT. See /tmp/websockify.$$.log"; tail -n 50 /tmp/websockify.$$.log; exit 1;
    fi
fi
