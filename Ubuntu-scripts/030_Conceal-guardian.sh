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

echo "===     030_Conceal-guardian.sh       ==="
echo "===    installing conceal-guardian    ==="
echo ""

# Install conceal-guardian
cd /opt
git clone https://github.com/ConcealNetwork/conceal-guardian.git || { echo "✗ git clone failed"; exit 1; }
cd conceal-guardian
npm install || { echo "✗ npm install failed"; exit 1; }
show_status "conceal-guardian pre-installed"

echo "copying config and service"
if [ -f /opt/ingredients/opt/conceal-guardian/config.json ]; then
  mv /opt/ingredients/opt/conceal-guardian/config.json /opt/conceal-guardian/config.json
  show_status "config.json copied"
else
  echo "✗ /opt/ingredients/opt/conceal-guardian/config.json not found"
fi

if [ -f /opt/ingredients/etc/systemd/system/ccx-guardian.service ]; then
  mv /opt/ingredients/etc/systemd/system/ccx-guardian.service /etc/systemd/system/ccx-guardian.service
  chmod 644 /etc/systemd/system/ccx-guardian.service
  chown root:root /etc/systemd/system/ccx-guardian.service
  systemctl daemon-reload
  show_status "ccx-guardian service pre-installed"
else
  echo "✗ /opt/ingredients/etc/systemd/system/ccx-guardian.service not found"
fi