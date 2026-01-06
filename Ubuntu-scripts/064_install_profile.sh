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

echo "===     064_install_profile.sh       ==="
echo "=== installing profile ==="
echo ""
mkdir -p /opt/conceal-toolbox
cd /opt/conceal-toolbox
if [ -d /opt/ingredients/opt/conceal-toolbox/custom_setup ]; then
  cp -r /opt/ingredients/opt/conceal-toolbox/custom_setup/ ./
  cd custom_setup
  chmod 755 setup_script.sh
  [ -f ss.png ] && cp ss.png /etc/skel/.icons/ || echo "⚠ ss.png not found in custom_setup"
  [ -f setup_script.desktop ] && cp setup_script.desktop /etc/skel/.local/share/applications/ || echo "⚠ setup_script.desktop not found"
else
  echo "✗ /opt/ingredients/opt/conceal-toolbox/custom_setup/ not found"
fi

if [ -f /opt/ingredients/etc/skel/.face ]; then
  cp /opt/ingredients/etc/skel/.face /etc/skel/
else
  echo "⚠ /opt/ingredients/etc/skel/.face not found"
fi

if ls /opt/ingredients/etc/skel/.bash* 1> /dev/null 2>&1; then
  cp /opt/ingredients/etc/skel/.bash* /etc/skel/
else
  echo "⚠ /opt/ingredients/etc/skel/.bash* files not found"
fi

show_status "profile installed"