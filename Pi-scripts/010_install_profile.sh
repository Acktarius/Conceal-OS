#!/bin/bash
echo "installing profile"
cd /opt/conceal-toolbox
cp -r /opt/Conceal-OS/ingredients/opt/conceal-toolbox/custom_setup/ ./
cd custom_setup
chmod 755 setup_script.sh
cp ss.png /etc/skel/.icons/
cp setup_script.desktop /etc/skel/.local/share/applications/
cp /opt/Conceal-OS/ingredients/etc/skel/.face /etc/skel/
cp /opt/Conceal-OS/ingredients/etc/skel/.bash* /etc/skel/