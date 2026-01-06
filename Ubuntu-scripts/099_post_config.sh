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

echo "===     099_post_config.sh       ==="
echo "===   Ubuntu Post Configuration   ==="
echo ""

# Cleanup build artifacts
echo "Cleaning up build artifacts..."
if [ -d "/opt/Conceal-OS" ]; then
    rm -rf /opt/Conceal-OS
    show_status "Conceal-OS build directory removed"
fi

# Restore resolv.conf if it was modified during build
# Ubuntu uses systemd-resolved, so we let it manage resolv.conf
# But we ensure it's properly configured
if [ -f /etc/resolv.conf.orig ]; then
    rm -f /etc/resolv.conf
    mv /etc/resolv.conf.orig /etc/resolv.conf
    show_status "resolv.conf restored"
elif [ -L /etc/resolv.conf ]; then
    # If it's already a symlink to systemd-resolved, leave it
    echo "✓ resolv.conf already managed by systemd-resolved"
else
    # Ensure systemd-resolved manages it
    if systemctl is-enabled systemd-resolved >/dev/null 2>&1; then
        rm -f /etc/resolv.conf
        ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
        show_status "resolv.conf configured for systemd-resolved"
    fi
fi

# Setup disk resize on first boot
echo "Setting up disk resize service..."
if [ -f /opt/ingredients/opt/resize-disk-once.sh ]; then
  cp /opt/ingredients/opt/resize-disk-once.sh /opt/resize-disk-once.sh
  chmod +x /opt/resize-disk-once.sh
  show_status "resize-disk-once.sh copied"
else
  echo "⚠ Warning: /opt/ingredients/opt/resize-disk-once.sh not found"
fi

if [ -f /opt/ingredients/etc/systemd/system/resize-disk-once.service ]; then
  cp /opt/ingredients/etc/systemd/system/resize-disk-once.service /etc/systemd/system/resize-disk-once.service
  chmod 644 /etc/systemd/system/resize-disk-once.service
  systemctl enable resize-disk-once.service
  show_status "resize-disk-once.service installed and enabled"
else
  echo "⚠ Warning: /opt/ingredients/etc/systemd/system/resize-disk-once.service not found"
fi

# Clean up temporary files
echo "Cleaning temporary files..."
rm -rf /opt/ingredients
show_status "Temporary files cleaned"

# Setup first-boot user creation (optional - user can delete "conceal" and create their own)
# Note: "conceal" user is kept as default for now
# To enable first-boot user creation, uncomment the following:
# echo "Setting up first-boot user creation..."
# mkdir -p /etc/systemd/system/getty@tty1.service.d/
# cat > /etc/systemd/system/getty@tty1.service.d/override.conf << 'EOF'
# [Service]
# ExecStart=
# ExecStart=-/sbin/agetty --noclear %I $TERM
# EOF
# systemctl daemon-reload
# show_status "First-boot user creation configured "

# Minimize image size
echo ""
echo "Minimizing image size..."

# Step 1: Identify and remove large unnecessary packages
echo "Identifying large packages..."
dpkg-query -Wf='${Installed-Size}\t${Package}\n' | sort -n | tail -20 > /tmp/large_packages.txt || true
echo "Top 20 largest packages saved to /tmp/large_packages.txt"

# Purge unnecessary packages (be selective - don't remove essential packages)
echo "Purging unnecessary packages..."
# Remove snap completely (not needed for XFCE desktop)
apt-get purge -y snapd || true
systemctl disable snapd 2>/dev/null || true
systemctl disable snapd.socket 2>/dev/null || true
systemctl disable snapd.seeded 2>/dev/null || true
rm -rf /var/lib/snapd /var/cache/snapd /snap || true

# Keep cloud-init for network configuration on first boot
# Only disable it after network is configured (don't purge it)
# cloud-init handles initial network setup via DHCP
systemctl enable cloud-init 2>/dev/null || true
systemctl enable cloud-init-local 2>/dev/null || true
systemctl enable cloud-config 2>/dev/null || true
systemctl enable cloud-final 2>/dev/null || true

# Ensure NetworkManager is also enabled and will manage interfaces after cloud-init
systemctl enable NetworkManager
systemctl start NetworkManager || true

# Remove multipath-tools if not using multipath
apt-get purge -y multipath-tools || true

# Remove unnecessary kernel modules (keep only current kernel)
apt-get purge -y linux-modules-extra-* || true

# Clean package cache
apt-get clean
rm -rf /var/lib/apt/lists/*
show_status "Package cache cleaned"

# Remove unnecessary packages and files
apt-get autoremove -y --purge
apt-get autoclean -y
show_status "Unnecessary packages removed"

# Step 2: Strip documentation, manpages, and info pages
echo "Stripping documentation and manpages..."
rm -rf /usr/share/doc/* || true
rm -rf /usr/share/man/* || true
rm -rf /usr/share/info/* || true
rm -rf /usr/share/lintian/* || true
show_status "Documentation stripped"

# Keep only English locale (or your preferred language)
echo "Configuring locales..."
# Remove other locale data (keep en_US and en_CA)
find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name 'en_US*' ! -name 'en_CA*' ! -name 'locale.alias' -exec rm -rf {} + 2>/dev/null || true
# Clean locale-archive (keep only en_US and en_CA)
if command -v localedef >/dev/null 2>&1; then
    localedef --list-archive | grep -v -E '^(en_US|en_CA)' | xargs -r localedef --delete-from-archive 2>/dev/null || true
fi
show_status "Locales minimized"

# Step 3: Kill caches and logs before image capture
echo "Clearing logs and caches..."

# Truncate all log files
find /var/log -type f -exec truncate -s 0 {} \; 2>/dev/null || true

# Clear journal logs
journalctl --rotate
journalctl --vacuum-time=1s
show_status "Logs cleared"

# Clear temporary system files
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf /var/cache/apt/archives/*
rm -rf /var/cache/debconf/*
rm -rf /root/.cache/*
rm -rf /home/*/.cache/* 2>/dev/null || true
show_status "Temporary system files and caches cleared"

# Zero out free space to improve compression (if converting to ISO later)
echo "Zeroing out free space for better compression..."
dd if=/dev/zero of=/EMPTY bs=1M 2>/dev/null || true
rm -f /EMPTY
show_status "Free space zeroed"

# Show final disk usage
echo ""
echo "Final disk usage:"
df -h /

echo ""
echo "=== Ubuntu post configuration completed ==="
