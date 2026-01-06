#!/bin/bash

export NEEDRESTART_SUSPEND=true
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

# Function to show status
show_status() {
    if [ $? -eq 0 ]; then
        echo "✓ $1"
    else
        echo "✗ $1"
    fi
}

echo "===     062_install_CCX_Box.sh       ==="
echo "=== installing CCX Box Updater ==="
echo ""

mkdir -p /opt/conceal-toolbox
cd /opt/conceal-toolbox
git clone https://github.com/Acktarius/CCX-BOX_Apps.git
cd CCX-BOX_Apps
chmod 755 updater.sh
mkdir -p /etc/skel/.local/share/applications/
if [ -f /opt/ingredients/etc/skel/.local/share/applications/CCX-BOX_Apps_updater.desktop ]; then
  mv /opt/ingredients/etc/skel/.local/share/applications/CCX-BOX_Apps_updater.desktop /etc/skel/.local/share/applications/CCX-BOX_Apps_updater.desktop
  show_status "CCX Box Updater installed"
else
  echo "✗ /opt/ingredients/etc/skel/.local/share/applications/CCX-BOX_Apps_updater.desktop not found"
fi

echo ""
echo "=== EZ_Privacy ==="
echo ""

cd /opt
git clone https://github.com/Acktarius/EZ_Privacy.git
cd EZ_Privacy
chmod 755 EZ_Privacy.sh
mv ez_privacy_logo3_128.png /etc/skel/.icons/
mv ez_privacy.desktop /etc/skel/.local/share/applications/
show_status "EZ_Privacy installed"