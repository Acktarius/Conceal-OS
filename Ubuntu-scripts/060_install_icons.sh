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

echo "===     060_install_icons.sh       ==="
echo "=== installing icons ==="
mkdir -p /etc/skel/.icons
if [ -d /opt/ingredients/etc/skel/.icons ]; then
  cp /opt/ingredients/etc/skel/.icons/* /etc/skel/.icons/
  show_status "icons installed"
else
  echo "✗ /opt/ingredients/etc/skel/.icons/ is empty or not found"
fi