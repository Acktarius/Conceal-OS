#!/bin/bash
echo "installing backgrounds"
cp /opt/Conceal-OS/ingredients/usr/share/backgrounds/ccxBackground* /usr/share/backgrounds/
cd /usr/share/backgrounds
rm ubuntu-default-greyscale-wallpaper.png
# Create a new symlink to your custom background
ln -s ccxBackground5.jpg ubuntu-default-greyscale-wallpaper.png
cd ../gnome-background-properties/
cp /opt/Conceal-OS/ingredients/usr/share/gnome-background-properties/jammy-wallpapers.xml ./
cd ../glib-2.0/schemas/
cp /opt/Conceal-OS/ingredients/usr/share/glib-2.0/schemas/90_custom.gschema.override ./
cd
glib-compile-schemas /usr/share/glib-2.0/schemas
cp /opt/Conceal-OS/ingredients/usr/share/plymouth/ubuntu-logo.png /usr/share/plymouth/