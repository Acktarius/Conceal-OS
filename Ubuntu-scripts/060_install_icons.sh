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
  show_status "icons installed to /etc/skel"
  
  # Also copy to the current user's home directory
  # Get username from cloud-init user-data (where we defined it)
  USERNAME=$(grep -E "^\s+username:\s+" /var/lib/cloud/seed/nocloud/user-data 2>/dev/null | awk '{print $2}' | tr -d '"' || echo "")
  
  # Fallback: get first user home directory from /home
  if [ -z "$USERNAME" ]; then
    USERNAME=$(ls -1 /home 2>/dev/null | grep -v "lost+found" | head -1)
  fi
  
  if [ -n "$USERNAME" ] && [ -d "/home/$USERNAME" ]; then
    mkdir -p "/home/$USERNAME/.icons"
    cp /opt/ingredients/etc/skel/.icons/* "/home/$USERNAME/.icons/"
    chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.icons"
    show_status "icons installed to /home/$USERNAME/.icons"
  fi
else
  echo "✗ /opt/ingredients/etc/skel/.icons/ is empty or not found"
fi