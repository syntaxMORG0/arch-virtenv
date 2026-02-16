#!/bin/bash

bash install/install_MATE.sh
bash install/install_VNC.sh
bash install/install_noVNC.sh
bash install/install_Utils.sh
bash install/enable_XdisplayServer.sh
bash install/enable_noVNC.sh
bash install/expose.sh
bash install/generate_gh_link.sh