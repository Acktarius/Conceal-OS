The files included in those iso are subject to Licence and Copyrights, here is a non exhaustive list :
© UBUNTU Term and Policies.  
© 2017-2025 Conceal Community,  
© 2017-2018 The Circle Foundation & Conceal Devs  
© 2018-2025 Conceal Network & Conceal Devs  
© 2011-2017 The Cryptonote developers  
© 2014-2016 XDN developers  
© 2016-2017 Karbowanec developers  
© fireice-uk & psychocrypt     
© doktor83  
© cryptunit.com  
© 2022-2025, Acktarius  

License is a combination of : MIT, GNU v3 and BSD clause 3
#
## Disclaimer
those iso files and the files they contain are delivered “as is” and I deny any and all liability for any damages arising out of using this "cocktail" of softwares.

## Transparency
The miners flight sheets and the node collecting fee are setup to point to the Conceal Network donation address, you can change that using Conceal-assistant, thank you in advance for supporting Conceal Network.

#
## Credits
[Conceal Labs](https://conceal.network/labs/)
**special thanks** to conceal community  and in particular kryptOx, Taegus, Lollipop, Cédric CRISPIN, Vega-SerpentX, and also Ki-ll and Ancolies.

#
*Install like regular Ubuntu : select language, keyboard, create a user…*
(the slideshow during installation only support English, Français, Español)

⚠️ All Conceal apps and tools are located in the /opt folder which requires sudo permissions

#
## **Conceal Colors** 
A script to change to Conceal theme of colours and font on desktop and in terminal. 
Some Conceal backgrounds are also available.
![CCX profile](/docs/_resources/ccxprofile.png)


#
## **Node with Guardian** 
will run automatically as a service at first boot. 
⚠️ *the node will need to be momentarily deactivated during first setup of Conceal Desktop. Use Conceal-Assistant to deactivate it*

**Note:** for your smartnode to be seen on the explorer, you'll have to open port 16000 of your router. (in your router settings it should be located in the port-forawarding section)

#
## **Miners**
SRBMiner_Multi v2.2.4 and Xmr-Stak are pre-installed,
- 1st case : you are using the CCX-BOX iso file with a CCX-BOX (gpu RX6400) : 
	- Mining Service will launched automatically by default using Xmr-Stak
- 2nd case : you are using the Desktop iso file:
	- The mining service won't launch automatically to prevent to apply inapropriate overclock to your GPU. A script with an icon **mining service** will help you to create the service: choose working directory and executable.
	 ⚠️  But first you will have to figure out your overclock  using one of the following options :
		* automatic if RX 6400 aero (one fan)
		* manually with bash comands
		*  [Corectrl](https://gitlab.com/corectrl/corectrl) 
and  also mining intensity in your flight sheets.

Then create the mining service.  
![Mining Service](/docs/_resources/miningservice.png)  
If GPU RX 6400 aero is detected, the fan icon will allow you to adjust fan speed :  
![fan](/docs/_resources/fanspeed.png)

### XMR-STAK *fork by Ack*
	comes with a gui created in case you prefer to mine more sproradically,
	to install it:
```
cd /opt/xmrstak
sudo ./ubuntu_shortcut_creator.sh
```
you can change some of your config there.


![Xmr-Stak-gui-ccx](/docs/_resources/xmrstakguiccx.png)

**!!!** Don't forget you 'll probably need to apply overclocks with **oc-amd**
#
## **Ping_CCX_pool**
this tool allow you to evaluate the average response time of most known mining pool or custom.
comes in two version: C++ (default) and Bash-Script(for legacy)

![Ping CCX Pool](/docs/_resources/pingccxpool.png)

#
## **OC-AMD**
2 options:
* Run as a script(default), which is installed and run automatically paired with the Mining Service,
this way your overclocks are applied when mining and reset to default when mining service is deactivated.
* In case you don't want to mine with a service but more sporadically, you can apply the overclocks on the fly using the icon in the applications menu, but need to be installed first:
```
cd /opt/conceal-toolbox/oc-amd
sudo ./shortcut_creator.sh
```


![oc-amd](/docs/_resources/amdgpuoc.png)

#
## **CCX-BOX_APP Updater**
allows you to update:
* Conceal Assistant
* Conceal Guardian
* EZ_Privacy
* oc-amd
* mem-alloc
* Ping_CCX_Pool (script version)
* CCX-BOX_APP Updtaer *(update itself)*  
![CCX-BOX_Apps Updater](/docs/_resources/ccxboxappupdater.png)


#
## **Conceal Assistant v1.2.3** 
runs as a service at first boot
there is a Chameleon icon to open it in firefox :  
![Conceal Assistant](/docs/_resources/ccxassistant.png)  

choose *default* option to launch, or if you need to use the node update feature, or for debug purpose, launch with terminal option.

you can also access the Assistant via an other device (phone or computer) on the same local network using the URL:
`http://local_ip_address_of_the_ccx-box:3500`

#
## **Conceal Desktop v6.7.3** 
![Conceal Desktop](/docs/_resources/ccxdesktop.png)  
is installed and needs to be setup, for that : 
* deactivate the node service (with assistant), 
* launch Desktop, 
	* in the parameters modify to “custom node” and enter `your_local_ip_address:16000`,  
	![CCX Desktop setup](/docs/_resources/a2f0ecbd2e8f419d24346613a00bed61.png)  
	* save,  
	* quit (wait as needed).
* Restart node service, 
* launch desktop (now hooked to your node)
#
## **Alias**
some alias  (shortcut) have been set for use in terminal:
 * uu="sudo apt update && sudo apt upgrade"
 * ins="sudo apt-get install"
 * rem="sudo apt remove"
 * ..="cd .."

#
## **SSH**
access your CCX-BOX via SSH, in a terminal from an other computer on the same local network with the command :
`ssh your_user_name@the_ip_address_of_your_ccx_box`  

![zmotd](/docs/_resources/zmotd.jpeg)  

#
## Security
* fail2ban is installed with a minimalist jail.local file, to be appended to your liking.
* ufw is installed and need to be enabled

#
## Notes :
* further update and upgrade of Ubuntu may jeopardize the stability of the Conceal universe of applications included in those iso, please consider wisely when doing so.

