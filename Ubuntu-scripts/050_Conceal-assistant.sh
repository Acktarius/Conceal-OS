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

echo "===     050_Conceal-assistant.sh       ==="
echo "=== installing conceal-assistant ==="
echo ""

# Install conceal-assistant
npm i -g nodemon
show_status "nodemon installed"
cd /opt
git clone https://github.com/Acktarius/conceal-assistant.git
cd conceal-assistant
npm install
if [ -f /opt/ingredients/etc/skel/.local/share/applications/ccx-assistant_firefox.desktop ]; then
  mv /opt/ingredients/etc/skel/.local/share/applications/ccx-assistant_firefox.desktop /etc/skel/.local/share/applications/ccx-assistant_firefox.desktop
  show_status "ccx-assistant_firefox.desktop pre-installed"
else
  echo "✗ /opt/ingredients/etc/skel/.local/share/applications/ccx-assistant_firefox.desktop not found"
fi

echo "setting up service"
if [ -f /opt/ingredients/etc/systemd/system/ccx-assistant.service ]; then
  mv /opt/ingredients/etc/systemd/system/ccx-assistant.service /etc/systemd/system/ccx-assistant.service
  chmod 644 /etc/systemd/system/ccx-assistant.service
  chown root:root /etc/systemd/system/ccx-assistant.service
  systemctl daemon-reload
  # systemctl enable ccx-assistant.service
  show_status "ccx-assistant service pre-installed"
else
  echo "✗ /opt/ingredients/etc/systemd/system/ccx-assistant.service not found"
fi

echo ""
echo "=== ZMotd ==="
echo ""

if [ -f /opt/ingredients/etc/profile.d/zmotd.sh ]; then
  mv /opt/ingredients/etc/profile.d/zmotd.sh /etc/profile.d/zmotd.sh
  show_status "zmotd pre-set"
else
  echo "✗ /opt/ingredients/etc/profile.d/zmotd.sh not found"
fi