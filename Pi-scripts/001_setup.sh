#!/bin/bash

# Suspend needrestart for packer not to hang
export NEEDRESTART_SUSPEND=true
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

echo "apt Packages and add-ons"
#add-apt-repository main universe restricted multiverse
apt-get update

# Then do a complete cleanup
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/apt/*
rm -rf /var/cache/apt/archives/*
apt-get clean

# Update again with clean slate
apt-get update

# Install essential packages first
apt-get install -y --no-install-recommends \
    dh-autoreconf \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    gettext \
    libz-dev \
    libssl-dev \
    install-info \
    ca-certificates \
    curl \
    wget \
    apt-transport-https \
    gnupg
apt-get install -y git --fix-missing -o Debug::pkgProblemResolver=yes
apt-get install -y curl dbus-x11 jq zenity openssh-server gnome-tweaks

cd /opt
git clone https://github.com/Acktarius/Conceal-OS.git
cd