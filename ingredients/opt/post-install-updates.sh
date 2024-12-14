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
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::InstallOnShutdown "false";
EOF

# 99update-notifier - Disable upgrade notifications
cat > /etc/apt/apt.conf.d/99update-notifier << EOF
Update-Manager::Launch-Time "0";
Update-Manager::Show-Remains-Time "false";
Update-Manager::Check-Dist-Upgrades "false";
Update-Manager::Release-Upgrade-Mode "never";
EOF

# Set correct permissions
chmod 644 /etc/apt/apt.conf.d/20auto-upgrades
chmod 644 /etc/apt/apt.conf.d/50unattended-upgrades
chmod 644 /etc/apt/apt.conf.d/99update-notifier

# Restart unattended-upgrades service
systemctl restart unattended-upgrades

echo "Update configurations have been applied successfully"