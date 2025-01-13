#!/bin/bash
echo "installing box app updater"
cd /opt/conceal-toolbox
git clone https://github.com/Acktarius/CCX-BOX_Apps.git
cd CCX-BOX_Apps
chmod 755 updater.sh
cp ./icon/update_box.png /etc/skel/.icons/
mkdir -p /etc/skel/.local/share/applications/
cp /opt/Conceal-OS/ingredients/etc/skel/.local/share/applications/CCX-BOX_Apps_updater.desktop /etc/skel/.local/share/applications/CCX-BOX_Apps_updater.desktop
cp /opt/Conceal-OS/ingredients/opt/conceal-toolbox/ccx-assistant_firefox.sh /opt/conceal-toolbox/ccx-assistant_firefox.sh
chmod 755 /opt/conceal-toolbox/ccx-assistant_firefox.sh
cp /opt/Conceal-OS/ingredients/etc/skel/.local/share/applications/ccx-assistant_firefox.desktop /etc/skel/.local/share/applications/ccx-assistant_firefox.desktop
cp /opt/Conceal-OS/ingredients/etc/profile.d/zmotd-Pi.sh etc/profile.d/zmotd-Pi.sh