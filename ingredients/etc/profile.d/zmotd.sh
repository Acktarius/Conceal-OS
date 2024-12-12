#!/bin/bash
################################################################################colors
# this file is subject to Licence
#Copyright (c) 2023-2024, Acktarius
################################################################################colors
case "$TERM" in
	xterm-256color)
	WHITE=$(tput setaf 7 bold)
	ORANGE=$(tput setaf 202)
	GRIS=$(tput setaf 8)
	ROUGE=$(tput setaf 160)
	LINK=$(tput setaf 4 smul)
	TURNOFF=$(tput sgr0)
	;;
	*)
	WHITE=''
	ORANGE=''
	GRIS=''
	ROUGE=''
	LINK=''
	TURNOFF=''
 	;;
esac
############################################################################################information
CPU=$(cat /proc/cpuinfo | grep -m 1 "model name" | cut -d ":" -f 2 | cut -d " " -f 1,2,3,4)
GPU=$(glxinfo | grep -m 1 "Device" | tr -s " " | cut -d " " -f 3,4,5,6) || "???"
IPADD=$(ip a | grep -w 'inet' | grep -v 127 | cut -d "/" -f 1 | tr -d " " | cut -c 5-)
xSys=$(tail -1000 /var/log/syslog | grep -c "xmr-stak")
sSys=$(tail -1000 /var/log/syslog | grep -c "cryptonight_gpu")

if [[ $xSys > $sSys ]]; then
MINER="Xmr-Stak"
HASH=$(tail -1000 /var/log/syslog | grep  "Totals (AMD)" | tail -n 1 | tr -s " " | cut -d " " -f 8)
HASH=${HASH%%.*}
elif [[ $xSys < $sSys ]]; then
MINER="SRBMiner-Multi"
HASH=$(tail -1000 /var/log/syslog | grep  "33mTotal:" | tail -n 1 | tr -s " " | cut -d " " -f 9)
HASH=${HASH%%.*}
else
MINER="???"
HASH="???"
fi
if ! [[ $HASH =~ ^[0-9]+$ ]]; then
HASH="???"
fi

##################################################################################################Design
echo -e "${GRIS}###############################################################      .::::."
echo -e "#                                                                .:---=--=--::."
echo -e "######                     ${WHITE}Welcome to CCX-BOX   ${GRIS}                 -=:+-.  .-=:=:"
echo -e "#                                                                -=:+."
echo -e "###  			${ORANGE}node with guardian + miner ${GRIS}	         -=:+."
echo -e "#                                                                -=:+."
echo -e "#   ${ORANGE}and conceal assistant on ${LINK}http:\\$IPADD:3500 ${TURNOFF}\t${GRIS}         -=:=."
echo -e "#                                                           \t -+:-:    .::."
echo -e "#                                                           \t -+==------===-"
echo -e "###############################################################\t    :-=-==-:\n"

echo -e "${GRIS}------------------${ORANGE}=========${GRIS}--${ORANGE}===${GRIS}------${ORANGE}=#*+==${GRIS}-----------------------------------"
echo -e "${GRIS}-------${ORANGE}=++**++=${GRIS}-${ORANGE}=#*==++++*++##+======${GRIS}-${ORANGE}*%%%%#+=${GRIS}---------------------------------"
echo -e "${GRIS}------${ORANGE}=%@@@@@@%#+%##**##*#**%%*###**+=*%**####*====${GRIS}----------------------------"
echo -e "${GRIS}------${ORANGE}+@@@@@@@@%%%@##*##*##%%%#%%####*#@*******##%#+=${GRIS}--------------------------"
echo -e "${GRIS}-----${ORANGE}=#@@@@@@@@@@@@%####*#%%@%*#**###%%@#*####%%%%%#*=${GRIS}-------------------------"
echo -e "${GRIS}----${ORANGE}*@@@@%@%%@%%@@@@@%###%%@@%%%#%%%#%@@#*##%%%%%%##*+=${GRIS}------------------------"
echo -e "${GRIS}--${ORANGE}=+%@@@%%@%%@@@@%%%%%##%@@%%%###%%%@@@@%#**##%%%####**==${GRIS}----------------------"
echo -e "${GRIS}--${ORANGE}+***#%%%@%%%%%%%@@@%%@%#*######%%@@%%##%%%%%%%%%%%####+${GRIS}----------------------"
echo -e "-${ORANGE}=*******%%%%%@@@@@@@#==*#*+===+*#**%#*###%%%%%%#####**+=${GRIS}----------------------"
echo -e "-${ORANGE}#@%##*#*##%%%%%%#%@#=${GRIS}--${ORANGE}=+++++=${GRIS}--${ORANGE}=++*##############%%#+++++=${GRIS}-------------------"
echo -e "${ORANGE}=@@@@%%%%%%%###*=${GRIS}-${ORANGE}#%*==${GRIS}---${ORANGE}=+**+++==${GRIS}-${ORANGE}==++**+++++++++===${GRIS}----${ORANGE}+*${GRIS}-------------------"
echo -e "${ORANGE}+@@@%%%%%%%%#*==+#%%#%%##+==++=${GRIS}-${ORANGE}===${GRIS}------${ORANGE}=+++++++++===++++*=${GRIS}-------------------"
echo -e "${ORANGE}+*##**#%%%%*=${GRIS}-${ORANGE}=##+=${GRIS}----${ORANGE}====${GRIS}---------------------${ORANGE}=========${GRIS}----------------------"
echo -e "${ORANGE}=##%%%####*=${GRIS}--${ORANGE}==${GRIS}-----------------${ORANGE}=====${GRIS}-----------------------------------------"
echo -e "${ORANGE}+@@@@%%%%#=${GRIS}-----------------${ORANGE}=+*##%%%#**#*+=${GRIS}-- ${ROUGE}User: ${WHITE}$USER"
echo -e "${ORANGE}=@@@@@%%%*${GRIS}----------------${ORANGE}=+#%%#++*****@@%#*=${GRIS}-- ${ROUGE}CPU: ${WHITE}$CPU"
echo -e "-${ORANGE}+##*##%%+${GRIS}--------------${ORANGE}=*%%#==${GRIS}--------${ORANGE}=++#@%*=${GRIS}-- ${ROUGE}GPU: ${WHITE}$GPU"
echo -e "-${ORANGE}=**#%%%%+${GRIS}--------------${ORANGE}+##=${GRIS}--------------${ORANGE}=#%#*=${GRIS}-- ${ROUGE}Miner: ${WHITE}$MINER"
echo -e "--${ORANGE}+@@%%%%*${GRIS}--------------${ORANGE}#%*${GRIS}----------------${ORANGE}=*@%#=${GRIS}-- ${ROUGE}Hash: ${WHITE}$HASH h/s"
echo -e "--${ORANGE}=#@@@%%%=${GRIS}-------------${ORANGE}*#+${GRIS}-----------------${ORANGE}=%@%+${GRIS}------------------------------"
echo -e "---${ORANGE}=*##%%%#=${GRIS}------------${ORANGE}=%%=${GRIS}-----------------${ORANGE}*%**${GRIS}------------------------------"
echo -e "----${ORANGE}=*##%%%#=${GRIS}------------${ORANGE}=*#+=${GRIS}---------------${ORANGE}*%%#${GRIS}------------------------------"
echo -e "-----${ORANGE}=%@@%%%%+=${GRIS}-----------${ORANGE}=+#*+===+=${GRIS}--------${ORANGE}=%%%*${GRIS}------------------------------"
echo -e "------${ORANGE}=*@@%%%%#+=${GRIS}------------${ORANGE}==+++=${GRIS}--------${ORANGE}=*#%%=${GRIS}------------------------------"
echo -e "--------${ORANGE}=*###%%%%*+=${GRIS}----------------------${ORANGE}=#%##+${GRIS}-------------------------------"
echo -e "----------${ORANGE}=+#@@@@%%%#+==${GRIS}---------------${ORANGE}==*%@%#+${GRIS}--------------------------------"
echo -e "------------${ORANGE}=+*%%%%##%%%##**++++++++**#%%%#*+=${GRIS}---------------------------------"
echo -e "----------------${ORANGE}==+*%@@@@%%%##%%@%@%%@%%%#+=${GRIS}-----------------------------------"
echo -e "Copyright © 2023 @Acktarius, All Rights Reserved - Credit original design:Micah"