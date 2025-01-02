#!/bin/bash

# Post-installation script for Conceal OS update configurations

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Configure automatic updates
echo "Configuring automatic updates..."

# 20auto-upgrades - Basic update settings
cat > /etc/apt/apt.conf.d/20auto-upgrades << EOF
APT::Periodic::Enable "1";
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF

# 50unattended-upgrades - Security updates only, protect mining-related packages
cat > /etc/apt/apt.conf.d/50unattended-upgrades << EOF
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}-security";
};
Unattended-Upgrade::Package-Blacklist {
    "linux-*";
    "*nvidia*";
    "amdgpu*";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "1";
Unattended-Upgrade::MinimalSteps "1";
Unattended-Upgrade::InstallOnShutdown "0";
EOF

# 99update-notifier - Disable upgrade notifications
cat > /etc/apt/apt.conf.d/99update-notifier << EOF
Update-Manager::Launch-Time "0";
Update-Manager::Show-Remains-Time "0";
Update-Manager::Check-Dist-Upgrades "0";
Update-Manager::Release-Upgrade-Mode "never";
EOF

# Set correct permissions
chmod 644 /etc/apt/apt.conf.d/20auto-upgrades
chmod 644 /etc/apt/apt.conf.d/50unattended-upgrades
chmod 644 /etc/apt/apt.conf.d/99update-notifier

# Restart unattended-upgrades service
systemctl restart unattended-upgrades

# Verify and update GRUB if needed
if [ -f /opt/grub_backup/grub ]; then
    echo "Restoring custom GRUB configuration..."
    sudo cp /opt/grub_backup/grub /etc/default/grub
    sudo update-grub
    echo "GRUB configuration restored and updated."
fi

# At the end of the script, disable the service
systemctl disable post-install-updates.service
rm /etc/systemd/system/post-install-updates.service

echo "Update configurations have been applied successfully"