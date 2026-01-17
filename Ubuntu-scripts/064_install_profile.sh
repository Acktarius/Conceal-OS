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

# Get username from cloud-init user-data (where we defined it)
USERNAME=$(grep -E "^\s+username:\s+" /var/lib/cloud/seed/nocloud/user-data 2>/dev/null | awk '{print $2}' | tr -d '"' || echo "")
# Fallback: get first user home directory from /home
if [ -z "$USERNAME" ]; then
    USERNAME=$(ls -1 /home 2>/dev/null | grep -v "lost+found" | head -1)
fi

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
  # Also copy to current user's home directory
  if [ -n "$USERNAME" ] && [ -d "/home/$USERNAME" ]; then
    [ -f ss.png ] && (mkdir -p "/home/$USERNAME/.icons" && cp ss.png "/home/$USERNAME/.icons/" && chown "$USERNAME:$USERNAME" "/home/$USERNAME/.icons/ss.png") || true
    [ -f setup_script.desktop ] && (mkdir -p "/home/$USERNAME/.local/share/applications" && cp setup_script.desktop "/home/$USERNAME/.local/share/applications/" && chown "$USERNAME:$USERNAME" "/home/$USERNAME/.local/share/applications/setup_script.desktop") || true
  fi
else
  echo "✗ /opt/ingredients/opt/conceal-toolbox/custom_setup/ not found"
fi

if [ -f /opt/ingredients/etc/skel/.face ]; then
  cp /opt/ingredients/etc/skel/.face /etc/skel/
  # Also copy to current user's home directory
  if [ -n "$USERNAME" ] && [ -d "/home/$USERNAME" ]; then
    cp /etc/skel/.face "/home/$USERNAME/.face"
    chown "$USERNAME:$USERNAME" "/home/$USERNAME/.face"
  fi
else
  echo "⚠ /opt/ingredients/etc/skel/.face not found"
fi

if ls /opt/ingredients/etc/skel/.bash* 1> /dev/null 2>&1; then
  cp /opt/ingredients/etc/skel/.bash* /etc/skel/
  # Also copy to current user's home directory
  if [ -n "$USERNAME" ] && [ -d "/home/$USERNAME" ]; then
    cp /opt/ingredients/etc/skel/.bash* "/home/$USERNAME/"
    chown "$USERNAME:$USERNAME" "/home/$USERNAME/.bash"*
  fi
else
  echo "⚠ /opt/ingredients/etc/skel/.bash* files not found"
fi

show_status "profile installed"