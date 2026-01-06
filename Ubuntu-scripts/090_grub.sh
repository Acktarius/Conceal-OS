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

echo "===     090_grub.sh       ==="
echo "=== configuring grub ==="
echo ""

# Append amdgpu.ppfeaturemask to GRUB_CMDLINE_LINUX_DEFAULT
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amdgpu.ppfeaturemask=0xffffffff"/' /etc/default/grub

# Append plymouth.enable=1 to GRUB_CMDLINE_LINUX_DEFAULT
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 plymouth.enable=1"/' /etc/default/grub

show_status "GRUB_CMDLINE_LINUX_DEFAULT updated"

# Change OS name to "Conceal OS" in GRUB
echo "Changing OS name to Conceal OS..."
# Replace OS="${GRUB_DISTRIBUTOR}" with OS="Conceal OS"
sed -i 's/OS="${GRUB_DISTRIBUTOR}"/OS="Conceal OS"/' /etc/grub.d/10_linux
show_status "OS name changed to Conceal OS"


mkdir -p /usr/share/grub/default
cp /etc/default/grub /usr/share/grub/default/grub
mkdir -p /opt/grub_backup
cp /etc/default/grub /opt/grub_backup/grub
show_status "grub configured"

echo "=== post-install-updates.sh ==="
echo ""
if [ -f /opt/ingredients/opt/post-install-updates.sh ]; then
  cp /opt/ingredients/opt/post-install-updates.sh /opt/post-install-updates.sh
  chmod +x /opt/post-install-updates.sh
  show_status "post-install-updates.sh copied"
else
  echo "⚠ Warning: /opt/ingredients/opt/post-install-updates.sh not found"
fi

if [ -f /opt/ingredients/etc/systemd/system/post-install-updates.service ]; then
  cp /opt/ingredients/etc/systemd/system/post-install-updates.service /etc/systemd/system/post-install-updates.service
  chmod 664 /etc/systemd/system/post-install-updates.service
  systemctl enable post-install-updates.service
  show_status "post-install-updates.service installed"
else
  echo "⚠ Warning: /opt/ingredients/etc/systemd/system/post-install-updates.service not found"
fi
