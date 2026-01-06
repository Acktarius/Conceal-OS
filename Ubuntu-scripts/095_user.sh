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

echo "===     095_user.sh       ==="
echo "=== creating user ==="
echo ""

groupadd conceal
useradd -r -g conceal concealer
show_status "Conceal group and user created"

# Change ownership of all Conceal components
[ -d /opt/conceal-core ] && chown -R concealer:conceal /opt/conceal-core
[ -d /opt/conceal-guardian ] && chown -R concealer:conceal /opt/conceal-guardian
[ -d /opt/conceal-desktop ] && chown -R concealer:conceal /opt/conceal-desktop
[ -d /opt/conceal-assistant ] && chown -R concealer:conceal /opt/conceal-assistant
[ -d /opt/conceal-toolbox ] && chown -R concealer:conceal /opt/conceal-toolbox

# Set group permissions
[ -d /opt/conceal-core ] && chmod -R g+w /opt/conceal-core
[ -d /opt/conceal-guardian ] && chmod -R g+w /opt/conceal-guardian
[ -d /opt/conceal-desktop ] && chmod -R g+w /opt/conceal-desktop
[ -d /opt/conceal-assistant ] && chmod -R g+w /opt/conceal-assistant
[ -d /opt/conceal-toolbox ] && chmod -R g+w /opt/conceal-toolbox

# Update service files with sed (only if they exist)
if ls /etc/systemd/system/ccx-*.service 1> /dev/null 2>&1; then
  sed -i 's/User=.*/User=concealer/' /etc/systemd/system/ccx-*.service
  show_status "Service User updated"
  sed -i 's/Group=.*/Group=conceal/' /etc/systemd/system/ccx-*.service
  show_status "Service Group updated"
else
  echo "⚠ Warning: No ccx-*.service files found to update"
fi