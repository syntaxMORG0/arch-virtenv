#!/bin/bash

# This script provides a TUI menu for selecting and installing a desktop environment.
# Choices:
# 1. MATE
# 2. XFCE4
# 3. LXQt
# 4. Headless (no desktop environment, only terminal)

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

while true; do
	clear
	echo "==============================="
	echo "  Select Desktop Environment   "
	echo "==============================="
	echo "1) MATE"
	echo "2) XFCE4"
	echo "3) LXQt"
	echo "4) Headless (Terminal Only)"
	echo "5) Change environment (reset selection)"
	echo "6) Exit"
	echo "==============================="
	read -p "Enter your choice [1-6]: " choice

	case $choice in
		1)
			echo "[GHCS]: Installing MATE..."
			if [ -f "$BASE_DIR/env_MATE/install_MATE.sh" ]; then
				# If previous environment exists, offer cleanup
				INFO_JSON="$BASE_DIR/../info.json"
				if [ -f "$INFO_JSON" ] && grep -q 'InstalledEnviroment' "$INFO_JSON"; then
					read -p "Detected previous install. Clear previous packages before continuing? [y/N]: " CLEAR
					if [[ "$CLEAR" =~ ^[Yy]$ ]]; then
						bash "$BASE_DIR/cleanup.sh"
					fi
				fi
				bash "$BASE_DIR/env_MATE/install_MATE.sh"
				bash "$BASE_DIR/../install_prepack.sh" mate
			else
				echo "[GHCS]: MATE installer not found!"
			fi
			break
			;;
		2)
			echo "[GHCS]: Installing XFCE4..."
			if [ -f "$BASE_DIR/env_Xfce4/install_XFCE4.sh" ]; then
				INFO_JSON="$BASE_DIR/../info.json"
				if [ -f "$INFO_JSON" ] && grep -q 'InstalledEnviroment' "$INFO_JSON"; then
					read -p "Detected previous install. Clear previous packages before continuing? [y/N]: " CLEAR
					if [[ "$CLEAR" =~ ^[Yy]$ ]]; then
						bash "$BASE_DIR/cleanup.sh"
					fi
				fi
				bash "$BASE_DIR/env_Xfce4/install_XFCE4.sh"
				bash "$BASE_DIR/../install_prepack.sh" xfce4
			else
				echo "[GHCS]: XFCE4 installer not found!"
			fi
			break
			;;
		3)
			echo "[GHCS]: Installing LXQt..."
			if [ -f "$BASE_DIR/env_LXQT/install_LXQT.sh" ]; then
				INFO_JSON="$BASE_DIR/../info.json"
				if [ -f "$INFO_JSON" ] && grep -q 'InstalledEnviroment' "$INFO_JSON"; then
					read -p "Detected previous install. Clear previous packages before continuing? [y/N]: " CLEAR
					if [[ "$CLEAR" =~ ^[Yy]$ ]]; then
						bash "$BASE_DIR/cleanup.sh"
					fi
				fi
				bash "$BASE_DIR/env_LXQT/install_LXQT.sh"
				bash "$BASE_DIR/../install_prepack.sh" lxqt
			else
				echo "[GHCS]: LXQt installer not found!"
			fi
			break
			;;
		4)
			echo "[GHCS]: Headless mode selected. Installing headless utilities..."
			if [ -f "$BASE_DIR/env_headless/install_headless.sh" ]; then
				INFO_JSON="$BASE_DIR/../info.json"
				if [ -f "$INFO_JSON" ] && grep -q 'InstalledEnviroment' "$INFO_JSON"; then
					read -p "Detected previous install. Clear previous packages before continuing? [y/N]: " CLEAR
					if [[ "$CLEAR" =~ ^[Yy]$ ]]; then
						bash "$BASE_DIR/cleanup.sh"
					fi
				fi
				bash "$BASE_DIR/env_headless/install_headless.sh"
				bash "$BASE_DIR/../install_prepack.sh" headless
			else
				echo "[GHCS]: Headless installer not found!"
			fi
			break
			;;
		5)
			echo "[GHCS]: Resetting environment selection..."
			bash "$BASE_DIR/changeEnv.sh"
			echo "[GHCS]: Environment reset. Re-run run.sh to select a new environment."
			exit 0
			;;
		6)
			echo "Exiting installer."
			exit 0
			;;
		*)
			echo "Invalid choice. Please select 1-6."
			sleep 1
			;;
	esac
done