#!/bin/bash
# install_VNC.sh: Installs and configures TigerVNC server for MATE

set -e

echo "TigerVNC server installed and configured."
# Install TigerVNC
echo "[GHCS]: Starting TigerVNC installation and configuration..."
echo "[GHCS]: Installing TigerVNC..."
sudo pacman -Sy --noconfirm tigervnc

# Set up VNC password for devuser
echo "[GHCS]: Setting up VNC password for devuser..."
mkdir -p $HOME/.vnc
# You can change the password below as needed
VNC_PASS="password"
echo $VNC_PASS | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

# Create xstartup file for MATE
echo "[GHCS]: Creating xstartup file for MATE..."
cat > $HOME/.vnc/xstartup <<EOF
#!/bin/sh
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=MATE
mate-session &
EOF
chmod +x $HOME/.vnc/xstartup

echo "TigerVNC server installed and configured."
echo "[GHCS]: TigerVNC server installation and configuration complete."
