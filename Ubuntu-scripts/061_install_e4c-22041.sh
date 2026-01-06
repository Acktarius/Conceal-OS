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

echo "===     061_install_e4c-22041.sh       ==="
echo "=== installing extension 4 concealers ==="
echo ""
apt-get -y install gnome-shell-extension-prefs fonts-noto
cd /tmp
git clone https://github.com/p-e-w/argos.git
cd argos
git switch -c gnome-44 GNOME-44
mkdir -p /etc/skel/.local/share/gnome-shell/extensions
cp -r argos* /etc/skel/.local/share/gnome-shell/extensions/
cd ..
rm -rf argos
cd /opt
mkdir conceal-toolbox
cd conceal-toolbox
git clone https://github.com/Acktarius/extension4Concealers.git
cd extension4Concealers
chmod 755 assistant.1r.1m+.sh serviceFlicker.sh
mkdir -p /etc/skel/.config/argos
cp assistant.1r.1m+.sh /etc/skel/.config/argos/assistant.1r.1m+.sh