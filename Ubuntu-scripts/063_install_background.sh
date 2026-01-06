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

# Copy backgrounds to XFCE expected location
# XFCE uses /usr/share/backgrounds/ for system backgrounds
if ls /opt/ingredients/usr/share/backgrounds/ccxBackground* 1> /dev/null 2>&1; then
  cp /opt/ingredients/usr/share/backgrounds/ccxBackground* /usr/share/backgrounds/ || { echo "✗ Failed to copy backgrounds"; exit 1; }
  show_status "backgrounds copied to /usr/share/backgrounds/"
else
  echo "✗ /opt/ingredients/usr/share/backgrounds/ccxBackground* not found"
fi

# Verify background file exists for XFCE config
if [ ! -f /usr/share/backgrounds/ccxBackground5.jpg ] && [ ! -f /usr/share/backgrounds/ccxBackground5.png ]; then
  echo "⚠ Warning: ccxBackground5.jpg or ccxBackground5.png not found in /usr/share/backgrounds/"
  echo "   XFCE background configuration may not work correctly"
fi

# Configure XFCE default background
echo "Configuring XFCE default background..."
# Install xfconf-query if not already installed (should be part of xfce4 package)
apt install -y xfce4-settings || true

# Create XFCE desktop configuration with ccxBackground5.jpg as default
XFCE_DESKTOP_CONFIG='<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="picture-style" type="int" value="5"/>
          <property name="picture-options" type="int" value="1"/>
          <property name="last-image" type="string" value="/usr/share/backgrounds/ccxBackground5.jpg"/>
          <property name="last-single-image" type="string" value="/usr/share/backgrounds/ccxBackground5.jpg"/>
        </property>
      </property>
    </property>
  </property>
</channel>'

# Set default background for new users via /etc/skel
mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
echo "$XFCE_DESKTOP_CONFIG" > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
chmod 644 /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
show_status "XFCE default background configured for new users (via /etc/skel)"

# Set it for existing conceal user
if id -u conceal >/dev/null 2>&1; then
    USER_HOME=$(eval echo ~conceal)
    if [ -d "$USER_HOME" ]; then
        mkdir -p "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
        echo "$XFCE_DESKTOP_CONFIG" > "$USER_HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
        chown -R conceal:conceal "$USER_HOME/.config"
        show_status "XFCE background configured for conceal user"
    fi
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