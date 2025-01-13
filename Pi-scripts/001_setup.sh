#!/bin/bash

# Suspend needrestart for packer not to hang
export NEEDRESTART_SUSPEND=true
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

echo "apt Packages and add-ons"
#add-apt-repository main universe restricted multiverse
apt-get update
apt-get install -y git curl dbus-x11 jq zenity openssh-server gnome-tweaks

cd /opt
git clone https://github.com/Acktarius/Conceal-OS.git
cd