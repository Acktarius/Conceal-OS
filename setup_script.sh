#!/bin/bash
################################################################################
# this file is subject to Licence
# Copyright (c) 2023-2024, Acktarius
################################################################################
#chech user
if [[ $USER = ubuntu ]]; then
exit 0
fi

#main
if [ ! -f /opt/conceal-toolbox/custom_setup/.bashrc_original ]; then
cat ~/.bashrc > /opt/conceal-toolbox/custom_setup/.bashrc_original
fi
answer=$(zenity --title="CCX colors for the Terminal or full theme?" --width=400 --height=220 --list --radiolist --column Selection --column answer FALSE Terminal FALSE CCX_Theme FALSE Standard) 
#read -p  "Import CCX colors for terminal (Yes/No/Standard) ?" answer
case "$answer" in
	Y|Yes|y|yes|Terminal)
echo "importing CCX color for the terminal"
dconf load /org/gnome/terminal/legacy/profiles:/ < /opt/conceal-toolbox/custom_setup/gnome-terminal-profiles.dconf
cat /opt/conceal-toolbox/custom_setup/.bashrc_colored > ~/.bashrc
cd ~
source .bashrc
	;;
	CCX_Theme)
dconf load / < /opt/conceal-toolbox/custom_setup/ccx_settings.dconf
dconf load /org/gnome/terminal/legacy/profiles:/ < /opt/conceal-toolbox/custom_setup/gnome-terminal-profiles.dconf
cat /opt/conceal-toolbox/custom_setup/.bashrc_colored > ~/.bashrc
source ~/.bashrc
	;;
	S|s|Standard|standard)
dconf reset -f /
dconf load /org/gnome/terminal/legacy/profiles:/ < /opt/conceal-toolbox/custom_setup/original.dconf
cat /opt/conceal-toolbox/custom_setup/.bashrc_original > ~/.bashrc
source ~/.bashrc
cd ~
	;;
	*)
echo "nothing will be done, bye"
	;;
esac

notoFolder=$(find /usr/share/fonts/ -type d -name "noto" | wc -l)
if [[ $notoFolder -eq 0 ]]; then
if zenity --question --title="fonts-noto are NOT installed" --text="Do you wish to proceed with install ?" --timeout=8
then
sudo apt-get update
sudo apt-get install -y fonts-noto
fi
fi
