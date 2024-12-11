# RECIPE
here is a detailed step by step procedure to create your own Conceal OS iso file.

## Prerequisite
1. Download Ubuntu Iso [Ubuntu 22.04 LTS ISO](https://ubuntu.com/download/alternative-downloads)  

## First step on Cubic
:warning: make sure the system your using match the same kernel as the downloaded iso, otherwise you may encounter some issues.
![Cubic Step 1](docs/cubic_step1.png)

## Second step on Cubic
![Cubic Step 2](docs/cubic_step2.png)
use the command line tool to customize.

## Cubic step by step CCX iso

- [ ] **update apt repository**
    ```
    add-apt-repository main universe restricted multiverse
    ```

- [ ] ~~Update~~
    ```
    apt update
    ```
    
- [ ] **tiny software**
    ```
    apt install mousepad git clinfo lm-sensors curl dbus-x11 jq zenity
    apt-get install openssh-server -y
    apt remove -y libreoffice-draw
    apt remove -y xubuntu-artwork xubuntu-community-wallpapers
    ```

- [ ] **Conceald**
    ```
    apt-get install -y build-essential python3-dev gcc g++ git cmake libboost-all-dev
    cd /opt
    git clone https://github.com/ConcealNetwork/conceal-core
    cd conceal-core
    mkdir build && cd build
    cmake ..
    make
    cd
    ```
    
- [ ] **nodejs & npm**
    ```
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    apt install -y nodejs
    ```
    >In case of *error*, one solution is:    
        ```
        sudo dpkg -i --force-overwrite /var/cache/apt/archives/nodejs18
        ```
    ```
    apt install -y npm
    npm install -g npm@latest
    ```

- [ ] **Conceal guardian**
    ```
    cd /opt
    git clone https://github.com/ConcealNetwork/conceal-guardian.git
    cd conceal-guardian
    npm install
    ```
    you can copy in this folder (drag and drop) the file [config.json](./ingredients/opt/conceal-guardian/config.json), pre-set with fee to Conceal donation address.  
    you can personnalize it running:  
    ```
    node index.js --setup
    ```
    >*answer questions.*  

    To run has a service:  
    ```
    cd /etc/systemd/system    
    ```
    and copy the file [ccx-guardian.service](./ingredients/etc/systemd/system/ccx-guardian.service)  
    To enable the service:
    ```
    systemctl enable ccx-guardian.service
    cd
    ```

- [ ] **Conceal Desktop**
    ```
    apt install git gcc make cmake libboost-all-dev qtbase5-dev libqt5charts5-dev
    cd /opt
    git clone https://github.com/ConcealNetwork/conceal-desktop
    cd conceal-desktop
    rm -rf cryptonote
    git clone https://github.com/ConcealNetwork/conceal-core cryptonote
    make build-release
    mkdir bin && mv build/release/conceal-desktop bin/
    make clean
    ```
    icon and desktop shortcut:  
    ```
    cd /etc/skel
    mkdir .icons
    mkdir -p .local/share/applications

    ```
    copy [conceal.png](./ingredients/etc/skel/.icons/conceal.png) in **.icons**:
    ```
    cd .icons
    ```
    copy [conceal-desktop.desktop] in **applications**
    ```
    cd ..
    cd .local/share/applications/
    cd
    ```

- [ ] **Conceal-assistant**
    ```
    npm i -g nodemon
    npm i -g livereload
    cd /opt
    git clone https://github.com/Acktarius/conceal-assistant.git
    cd conceal-assistant
    npm install
    cd
    ```

- [ ] **amdgpu**
    ```
    cd /tmp
    wget https://repo.radeon.com/amdgpu-install/22.40.3/ubuntu/jammy/amdgpu-install_5.4.50403-1_all.deb
    apt-get install ./amdgpu-install_5.4.50403-1_all.deb
    rm amdgpu-install_5.4.50403-1_all.deb
    cd
    amdgpu-install -y --accept-eula --no-dkms --usecase=opencl --opencl=rocr
    ```

- [ ] **SRB** (not open source ...otional)
    ```
    cd /opt
    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.2.4/SRBMiner-Multi-2-2-4-Linux.tar.xz
    tar -xvf SRBMiner-Multi-2-2-4-Linux.tar.xz
    rm SRBMiner-Multi-2-2-4-Linux.tar.xz
    cd SRBMiner-Multi-2-2-4/
    ```
    copy [start-mining-conceal.sh](./ingredients/opt/SRBMIner-Multi-2-2-4/start-mining-conceal.sh)
    ```
    cd
    ```

- [ ] xmr-stak version for Concealers (with AMD GPU)
    ```
    apt install ocl-icd-opencl-dev libmicrohttpd-dev libssl-dev cmake build-essential \
    libhwloc-dev pkg-config libjsoncpp-dev libwxgtk3.0-gtk3-dev
    cd /opt
    wget https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.16.tar.gz
    tar -xvf libmicrohttpd-0.9.16.tar.gz
    cd libmicrohttpd-0.9.16
    ./configure
    make
    make install
    cd ..
    wget https://download.open-mpi.org/release/hwloc/v2.8/hwloc-2.8.0.tar.gz
    tar -xvf hwloc-2.8.0.tar.gz
    cd hwloc-2.8.0
    ./configure
    make
    make install
    cd ..
    rm *.gz
    git clone https://github.com/Acktarius/xmr-stak.git
    cd xmr-stak/
    ```
    if you wish to change donation: `cd xmrstak` and change value in 
`donate-level.hpp`  
    ```
    mkdir build
    cd build
    cmake .. -DCUDA_ENABLE=OFF
    make install
    ```

copy mining service or rely on the mining-service installation script 

-\[ \] Conceal Toolbox
copy folder in /opt

- ./mem\_alloc\_fail-solver.sh

- [ ] **zmotd**
    copy zmotd.sh in /etc/profile.d

-  [ ] **mining service**
    copy mining_service in `/opt/conceal-toolbox/mining-service`
	ms.png in ~/.icons
`sudo cp /opt/conceal-toolbox/mining_service/ms.png /etc/skel/.icons/ms.png`

m-s_script.desktop in ~/.local/share/applications
`sudo cp /opt/conceal-toolbox/mining_service/m-s_script.desktop /etc/skel/.local/share/applications/m-s_script.desktop`

	
- [ ] **Background**
    

- copy in /usr/share/backgrounds/
    and modify jammy*.xml in /usr/share/gnome-background-properties/
- to force a background :
    `touch /usr/share/glib-2.0/schemas/90_custom.gshema.override`

### \- \- \- \- \-

\[org.gnome.desktop.background\]
picture-uri='[file:////usr/share/backgrounds/ccxBackground4.jpg'](file:////usr/share/backgrounds/ccxBackground4.jpg%27 "file:////usr/share/backgrounds/ccxBackground4.jpg'")
\[org.gnome.desktop.screensaver\]
picture-uri='[file:////usr/share/backgrounds/ccxBackground5.jpg'](file:////usr/share/backgrounds/ccxBackground5.jpg%27 "file:////usr/share/backgrounds/ccxBackground5.jpg'")

### \- \- \- \- \-

*and run*
`glib-compile-schemas /usr/share/glib-2.0/schemas`

- [ ] **Terminal profile**

- save the file : dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf

create importing script **setup_script.sh**:
`if [[ $USER = ubuntu ]]; then exit 0 else read -p "Import CCX colors for terminal (no to revert) (Yes/no) ?" answer case "$answer" in Y|Yes|y|yes) echo "importing CCX color for the terminal" dconf load /org/gnome/terminal/legacy/profiles:/ < /opt/custom_setup/gnome-terminal-profiles.dconf ;; N|No|n|no) dconf load /org/gnome/terminal/legacy/profiles:/ < /opt/custom_setup/original.dconf ;; *) echo "nothing will be done, bye" esac fi exit 0`

Place the script in the /opt/custum_setup/ directory while you are using Cubic. with the dconf file
/opt/custom\_setup/setup\_script.sh

*Place a launcher in all new user's home directory :*
/etc/.skel/.local/share/applications/setup_script.desktop

### \- \- \- \- \- \- \- \-

\[Desktop Entry\]
Type=Application
Name=CCX colors
Exec=/opt/conceal-toolbox/custom\_setup/setup\_script.sh
Icon=ss.png
Hidden=false
NoDisplay=false
Terminal=false
Comment=import terminal CCX profile
X-GNOME-Autostart-enabled=true

### \- \- \- \- \- \- \- \-

chmod 755 setup_script.sh

copy ss.png in ~/icons

- [ ] **.face**
    `cd /etc/skel/`
    copy .face
    
- [ ] **bashrc**
    `cd /etc/skel`
    `rm .bashrc`
    *and copy our* .bashrc + .bash_aliases
    
- [ ] **Fonts**
    in /etc/skel/.local/fonts
    

mkdir .config && cd .config
mkdir autostart && cd autostart
copy ccx-firefox.sh.desktop into

- [ ] **Aliases**
    touch .bash_aliases
    nano .bash_aliases
    alias uu="sudo apt update && sudo apt upgrade"
    alias ins="sudo apt-get install"
    alias rem="sudo apt remove"
    alias ..="cd .."
    source .bashrc
    
- [ ] **Slideshow**
    apt-get install oem-config-slideshow-ubuntu
    Then modify the files under /usr/share/ubiquity-slideshow/slides/l10n/
    

remove oem .deb after install ?

-\[ \] Theme
`sudo apt install gnome-tweaks`

- [ ] `Terminal colors`
    ***if no setup script***
    export PS1="\\e\[0;33m\[\\u@\\h \\W\]$ \\e\[m "

`export PS1="\[$(tput setaf 178)\]\u@\h\[$(tput sgr0)\]:\[$(tput setaf 27)\]\w $\[$(tput sgr0)\]"`

icon in /etc/skel/.icons
.desktop file in /etc/skel/.local/share/applications 

- [ ] **grub**
    nano /etc/default/grub
    *append with :* amdgpu.ppfeaturemask=0xffffffff
    `cp /etc/default/grub /usr/share/grub/default/grub`

- [ ] **ping_ccx_pool**
in toolbox
pp.png in `etc/skel/.icons`
ping_pool.desktop in `etc/skel/.local/share/applications/`


 - [ ] **CCX Assistant firefox shortcut**
 
icon in /etc/skel/.icons/cham.png
.desktop file in /etc/skel/.local/share/applications 

### \- \- \- \- \- \- \- \-

\[Desktop Entry\]
Type=Application
Name=CCX Assistant
Exec=/opt/conceal-toolbox/ccx-firefox.sh
Icon=cham.png
Hidden=false
NoDisplay=false
Terminal=false
Comment=Launch Firefox on CCX Assistant page
X-GNOME-Autostart-enabled=true

### \- \- \- \- \- \- \- \-

chmod 755 ccx-firefox.sh

## Privacy
 - [ ] Tor
  download in /opt
`wget -c https://www.torproject.org/dist/torbrowser/12.5.2/tor-browser-linux64-12.5.2_ALL.tar.xz -O - | sudo tor -x -J -C /opt/`

place the modify .desktop in /etc/skel/.local/share/applications/

 - [ ] Authentificator
 `sudo apt install flatpak -y`
 `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`
`flatpak install flathub com.belmoussaoui.Authenticator`

 - [ ] Obfuscate
`flatpak install flathub com.belmoussaoui.Obfuscate`

- [ ] File Shredder
`flatpak install flathub com.githubADBeveridge.Raider`

- [ ] Kleopatra
`flatpak install flathub org.kde.kleopatra`

- [ ] Librewolf
refer [https://librewolf.net/debian-migration/](https://librewolf.net/debian-migration/
)


sudo gpg --export 991BC93C EFE21092 C0B21F32 A1F4A52C > ubuntu-archive-keyring.gpg