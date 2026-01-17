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

echo "===     063_install_background.sh       ==="
echo "=== installing background ==="
echo ""

# Regular Ubuntu/GNOME build
echo "Configuring Ubuntu/GNOME default background..."

# Copy backgrounds from /opt/ingredients/usr/share/backgrounds/
cp /opt/ingredients/usr/share/backgrounds/ccxBackground* /usr/share/backgrounds/ 2>/dev/null || true
show_status "backgrounds copied from /opt/ingredients/usr/share/backgrounds/"

# Remove default Ubuntu wallpaper and create symlink
cd /usr/share/backgrounds
rm -f ubuntu-default-greyscale-wallpaper.png
# Create a new symlink to your custom background
if [ -f ccxBackground5.jpg ]; then
    ln -s ccxBackground5.jpg ubuntu-default-greyscale-wallpaper.png
    show_status "backgrounds copied and symlink created"
elif [ -f ccxBackground5.png ]; then
    ln -s ccxBackground5.png ubuntu-default-greyscale-wallpaper.png
    show_status "backgrounds copied and symlink created"
else
    echo "⚠ Warning: ccxBackground5.jpg or ccxBackground5.png not found"
fi


if [ -f /opt/ingredients/usr/share/plymouth/ubuntu-logo.png ]; then
  mv /opt/ingredients/usr/share/plymouth/ubuntu-logo.png /usr/share/plymouth/
  show_status "plymouth logo copied"
else
  echo "✗ /opt/ingredients/usr/share/plymouth/ubuntu-logo.png not found"
fi
echo ""

echo "=== Plymouth Splash Screen ==="
echo ""
# Install Plymouth tools
apt install -y plymouth-themes plymouth-theme-spinner
# Create a custom theme directory
mkdir -p /usr/share/plymouth/themes/conceal-logo

if [ -d /opt/ingredients/usr/share/plymouth/themes/conceal-logo ]; then
  [ -f /opt/ingredients/usr/share/plymouth/themes/conceal-logo/splash.png ] && mv /opt/ingredients/usr/share/plymouth/themes/conceal-logo/splash.png /usr/share/plymouth/themes/conceal-logo/ || echo "⚠ splash.png not found"
  [ -f /opt/ingredients/usr/share/plymouth/themes/conceal-logo/progress_box.png ] && mv /opt/ingredients/usr/share/plymouth/themes/conceal-logo/progress_box.png /usr/share/plymouth/themes/conceal-logo/ || echo "⚠ progress_box.png not found"
  [ -f /opt/ingredients/usr/share/plymouth/themes/conceal-logo/progress_bar.png ] && mv /opt/ingredients/usr/share/plymouth/themes/conceal-logo/progress_bar.png /usr/share/plymouth/themes/conceal-logo/ || echo "⚠ progress_bar.png not found"
  [ -f /opt/ingredients/usr/share/plymouth/themes/conceal-logo/conceal-logo.plymouth ] && mv /opt/ingredients/usr/share/plymouth/themes/conceal-logo/conceal-logo.plymouth /usr/share/plymouth/themes/conceal-logo/ || echo "⚠ conceal-logo.plymouth not found"
  [ -f /opt/ingredients/usr/share/plymouth/themes/conceal-logo/conceal-logo.script ] && mv /opt/ingredients/usr/share/plymouth/themes/conceal-logo/conceal-logo.script /usr/share/plymouth/themes/conceal-logo/ || echo "⚠ conceal-logo.script not found"
  
  chmod 644 /usr/share/plymouth/themes/conceal-logo/* 2>/dev/null || true
else
  echo "✗ /opt/ingredients/usr/share/plymouth/themes/conceal-logo/ directory not found"
fi

  
# Set the custom theme
update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/conceal-logo/conceal-logo.plymouth 100
update-alternatives --set default.plymouth /usr/share/plymouth/themes/conceal-logo/conceal-logo.plymouth

# Ensure Plymouth is in initramfs
echo "FRAMEBUFFER=y" > /etc/initramfs-tools/conf.d/plymouth

# Update initramfs for all installed kernels (or current kernel if specific version needed)
update-initramfs -u -k all || update-initramfs -u

# List available themes
update-alternatives --list default.plymouth

show_status "Plymouth Splash Screen pre-set"