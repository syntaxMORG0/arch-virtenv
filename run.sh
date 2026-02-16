#!/bin/bash

bash install/install_Xfce4.sh
bash install/install_noVNC.sh
bash install/install_Utils.sh
bash install/enable_XdisplayServer.sh
bash install/enable_noVNC.sh
bash install/expose.sh
bash install/generate_gh_link.sh