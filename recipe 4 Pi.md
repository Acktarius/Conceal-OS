# RECIPE
here is a detailed step by step procedure to create your Conceal like OS on a Raspberry Pi.

## Prerequisite
1. You will need the Raspberry Pi imager, you can download from here:
   - [https://www.raspberrypi.com/software/](https://www.raspberrypi.com/software/)
   - you will also find some guidance from Ubuntu website: [https://ubuntu.com/tutorials/how-to-install-ubuntu-desktop-on-raspberry-pi-4#1-overview](https://ubuntu.com/tutorials/how-to-install-ubuntu-desktop-on-raspberry-pi-4#1-overview)

## First step with Raspberry Pi Imager:
 - Have the external SSD you are planing to use plug to your computer:  
![external SSD](docs/external_ssd.jpg)
 - Launch Raspberry Pi imager and click on choose OS  
 ![Choose OS](docs/Raspberry-Pi-imager-001.png)  
  - Select other general-purpose OS  
 ![Other general-purpose OS](docs/Raspberry-Pi-imager-002.png) 
  - Select Ubuntu  
 ![Select Ubuntu](docs/Raspberry-Pi-imager-003.png)  
  - Choose the Ubuntu Desktop version Compatible with your Raspberry Pi  
![Ubuntu Desktop](docs/Raspberry-Pi-imager-004.png)
  - Choose Storage, be carefull to select wisely  
![Storage](docs/Raspberry-Pi-imager-005.png)
  - Advanced Option: pressing **Ctrl** + **Shift** + **X**  
  and set the parameters hostname, enable SSH and wifi config.  
![Advanced hostname and SSH](docs/Raspberry-Pi-imager-006.png)
![Advanced username and passwd](docs/Raspberry-Pi-imager-007.png)
![Advanced wifi](docs/Raspberry-Pi-imager-008.png)
![Advanced Time Zone](docs/Raspberry-Pi-imager-009.png)
  - Write  
![Write](docs/Raspberry-Pi-imager-010.png)  
  - Confirm  
![Write](docs/Raspberry-Pi-imager-011.png)
![Write](docs/Raspberry-Pi-imager-012.png)    

### Pre-set 
it can happen you get an error because of issue writting fat32 part, this means our latter pre-set won't be taken into account, two options from here:  
![error](docs/Raspberry-Pi-imager-013.png) 
    a. Use an other version of Raspberry Pi imager or on an other OS, or  
![windows](docs/Raspberry-Pi-imager-a1.png) 
    b. Drop the preset idea, and you'll setup at first boot.  
  - get your ip address  
  - get your ip address (192.168.1.118 in this example)  
 ![Write](docs/Raspberry-Pi-imager-b6.jpg
 ) 


## First Boot
 * Plug your external drive
 * Plug a mouse and keyboard
 * Plug a screen
 * Power up (plugging the adaptator)
here is what you should see:  
![First Screen](docs/Raspberry-Pi-setup-000.jpg)
 * Go through the initial setup if that didnot work initially, language, keyboard  
 (hit enter to validate)
![Keyboard](docs/Raspberry-Pi-setup-001.jpg)
 * Time Zone
![Where are you](docs/Raspberry-Pi-setup-002.jpg)
 * Credentials
![Who are you](docs/Raspberry-Pi-setup-003.jpg)
 * Screen Orientation, you may have display orientation issue,
 click on the top right corner, Settings -> Screen Display -> Orientation  
 and choose what suits you.  
![screen](docs/Raspberry-Pi-setup-004.jpg)
 * go through the final welcome step  
Also, decline the update at the moment and consider doing those later.  
![screen](docs/Raspberry-Pi-setup-005.jpg)
 * open a terminal **Ctrl** + **Alt** + **T**, and get your local ip address indicated in the eth0 section by inet  
```
ip a
```
![ip a](docs/Raspberry-Pi-setup-006.jpg)
 (192.168.1.118 in this example)  
![ip a](docs/Raspberry-Pi-setup-007.jpg)
 * install openssh
```
sudo apt install -y openssh-server
```
![ip a](docs/Raspberry-Pi-setup-008.jpg)

*you could continue the setup on the pi, but in our case we will continue via SSH connection so we have a bigger screen to work with.*

## Connect to the rasberry pi with SSH
 * open a terminal **Ctrl** + **Alt** + **T**,
`ssh <your-pi-user-name>@<your-pi-IP-address-from-previous-step>`
![ssh](docs/Raspberry-Pi-setup-010.jpg)
![ssh](docs/Raspberry-Pi-setup-011.png)
![ssh](docs/Raspberry-Pi-setup-012.png)

## Turn Ubuntu like Conceal OS

- [ ] **update apt repository**
    ```
    sudo add-apt-repository main universe restricted multiverse
    ```
- [ ] Update
    ```
    sudo apt update
    ```
    
- [ ] **tiny software**
    ```
    sudo apt install -y git clinfo lm-sensors curl dbus-x11 jq zenity
    ```
- [ ] Conceal OS
    ```
    cd /opt
    sudo git clone https://github.com/Acktarius/Conceal-OS.git
    ```

- [ ] **Conceald** :coffee:
    ```
    sudo apt-get install -y build-essential python3-dev gcc g++ git cmake libboost-all-dev
    cd /opt
    sudo git clone https://github.com/ConcealNetwork/conceal-core
    cd conceal-core
    sudo mkdir build && cd build
    sudo cmake ..
    sudo make
    cd
    ```
    
- [ ] **nodejs & npm** :coffee:
    ```
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
    sudo apt install -y npm
    sudo npm install -g npm@latest
    ```

- [ ] **Conceal guardian**
    ```
    cd /opt
    sudo git clone https://github.com/ConcealNetwork/conceal-guardian.git
    cd conceal-guardian
    sudo npm install
    sudo cp /opt/Conceal-OS/ingredients/opt/conceal-guardian/config.json ./
    # To run has a service:  
    sudo cp /opt/Conceal-OS/ingredients/etc/systemd/system/ccx-guardian.service /etc/systemd/system/
    # To enable the service:
    sudo systemctl enable ccx-guardian.service
    cd
    ```
- [ ] **Conceal-assistant**
    ```
    sudo npm i -g nodemon
    sudo npm i -g livereload
    cd /opt
    sudo git clone https://github.com/Acktarius/conceal-assistant.git
    cd conceal-assistant
    sudo npm install
    sudo cp /opt/Conceal-OS/ingredients/etc/systemd/system/ccx-assistant.service /etc/systemd/system/
    sudo systemctl enable ccx-assistant.service
    ```
- [ ] **.icons**
    ```
    cd
    mkdir .icons 
    sudo cp /opt/Conceal-OS/ingredients/etc/skel/.icons/cham.png ~/.icons/
    ```

- [ ] **extension4Concealers**
    ```
    sudo apt-get -y install gnome-shell-extension-prefs fonts-noto
    git clone https://github.com/p-e-w/argos.git
    cd argos
    git switch -c gnome-44 GNOME-44
    sudo mkdir -p ~/.local/share/gnome-shell/extensions
    sudo cp -r argos* ~/.local/share/gnome-shell/extensions/
    cd ..
    rm -rf argos
    cd /opt
    sudo mkdir conceal-toolbox
    cd conceal-toolbox
    sudo git clone https://github.com/Acktarius/extension4Concealers.git
    cd extension4Concealers
    sudo chmod 755 assistant.1r.1m+.sh
    sudo mkdir -p ~/.config/argos
    sudo cp assistant.1r.1m+.sh ~/.config/argos/assistant.1r.1m+.sh
    ```

    * **CCX-BOX_Apps**  
    ```
    cd /opt/conceal-toolbox
    sudo git clone https://github.com/Acktarius/CCX-BOX_Apps.git
    cd CCX-BOX_Apps
    chmod 755 updater.sh
    sudo cp /opt/Conceal-OS/ingredients/etc/skel/.local/share/applications/CCX-BOX_Apps_updater.desktop ~/.local/share/applications/
    ```
    
    - **CCX Assistant firefox shortcut**
    ```
    cd /opt/conceal-toolbox
    sudo cp /opt/Conceal-OS/ingredients/opt/conceal-toolbox/ccx-assistant_firefox.sh ./
    sudo chmod 755 ccx-assistant_firefox.sh
    sudo cp /opt/Conceal-OS/ingredients/etc/skel/.local/share/applications/ccx-assistant_firefox.desktop ~/.local/share/applications
    cd
    ```
    


- [ ] **zmotd**  
    ```
    sudo cp /opt/Conceal-OS/ingredients/etc/profile.d/zmotd-Pi.sh /etc/profile.d
    ```

	
- [ ] **Background**  
    ```
    sudo cp /opt/Conceal-OS/ingredients/usr/share/backgrounds/ccxBackground* /usr/share/backgrounds/
    cd /usr/share/backgrounds
    sudo rm ubuntu-default-greyscale-wallpaper.png
    # Create a new symlink to your custom background
    sudo ln -s ccxBackground5.jpg ubuntu-default-greyscale-wallpaper.png
    cd ../gnome-background-properties/
    sudo cp /opt/Conceal-OS/ingredients/usr/share/gnome-background-properties/jammy-wallpapers.xml ./
    cd ../glib-2.0/schemas/
    sudo cp /opt/Conceal-OS/ingredients/usr/share/glib-2.0/schemas/90_custom.gschema.override ./
    cd
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas
    ```

- [ ] **Terminal profile**
    ```
    cd /opt/conceal-toolbox
    sudo cp -r /opt/Conceal-OS/ingredients/opt/conceal-toolbox/custom_setup/ ./
    cd custom_setup
    sudo chmod 755 setup_script.sh
    sudo cp ss.png ~/.icons/
    sudo cp setup_script.desktop ~/.local/share/applications/
    ```

- [ ] **.face**
    ```
    sudo cp /opt/Conceal-OS/ingredients/etc/skel/.face ~/
    ```
- [ ] **bashrc and bash_aliases**
    ```
    sudo cp /opt/Conceal-OS/ingredients/etc/skel/.bash* ~/
    ```

- [ ] **Tweaks**
    ```
    sudo apt install gnome-tweaks
    ```
- [ ] Flatpak
    ```
    sudo add-apt-repository ppa:flatpak/stable
    sudo apt install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ```
- [ ] **fail2ban**  
    ```
    sudo apt install -y fail2ban
    cd /etc/fail2ban
    sudo cp jail.conf jail.local
    ```
    Edit jail.local to set basic configuration:
    ```
    # In [DEFAULT] section:
    bantime = 1d
    findtime = 1d
    maxretry = 3

    # Enable SSH protection in [sshd] section:
    [sshd]
    enabled = true
    port = ssh
    filter = sshd
    logpath = %(sshd_log)s
    maxretry = 3
    findtime = 600
    bantime = 600
    ```
    Enable and start the service:
    ```
    sudo systemctl enable fail2ban
    ```
- [ ] **Security**  
    ```
    # Install and configure UFW
    sudo apt install -y ufw
    sudo ufw allow ssh
    sudo ufw allow from 192.168.1.0/24 to any port 8080
    sudo ufw allow 15000  # Conceal port    
    sudo ufw allow 16000  # Conceal port
    sudo ufw allow 3500  # Conceal assistant port
    sudo ufw --force enable
    ```
    edit ssh_config
    ```
    cd /etc/ssh
    sudo nano ssh_config
    ```
    append with `PermitRootLogin no` and save.

- [ ] **Plymouth**
    ```
    sudo cp /opt/Conceal-OS/ingredients/usr/share/plymouth/ubuntu-logo.png /usr/share/plymouth/
    ```

## End result
* activate argos extension
![argos](docs/Raspberry-Pi-result-002.jpg)    
* End Result
![result](docs/Raspberry-Pi-result-001.jpg)    

## Helpfull command
* if the node is not reporting location
```
sudo systemctl stop ccx-guardian.service
cd /opt/conceal-guardian
sudo node index.js
```
wait synchronisation and, **Ctrl** + **C**
```
sudo systemctl start ccx-guardian.service
```

* synchronisation will be slow, to the point guardian might give up,
so just run the node to synchronisation without guardian:
```
sudo systemctl stop ccx-guardian.service
cd /opt/conceal-core/build/src
sudo ./conceald
```
wait synchronisation and, `save`, `exit`, hit enter, and restart the service:
```
sudo systemctl start ccx-guardian.service
```