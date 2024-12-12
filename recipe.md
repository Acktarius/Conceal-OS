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

- [ ] **Clean up and set correct kernel**
    ```
    # Remove newer kernel and HWE
    apt remove -y linux-image-6* linux-headers-6*
    apt remove -y linux-modules-6*
    apt remove linux-generic-hwe-22.04
    apt autoremove
    
    # Install specific 5.19 kernel
    apt install linux-image-5.19.0-50-generic linux-headers-5.19.0-50-generic
    
    # Hold everything in place
    apt-mark hold linux-image-5.19.0-50-generic linux-headers-5.19.0-50-generic
    apt-mark hold linux-image-generic linux-headers-generic
    apt-mark hold linux-generic
    apt-mark hold linux-generic-hwe-22.04
    
    # Double-check HWE is disabled
    apt-mark hold linux-generic-hwe-22.04
    
    # Verify installation
    dpkg --list | grep linux-image

    #if needed:
    dpkg --purge linux-image-6.8.0-40-generic
    ```
- [ ] **Remove unnecessary language packs** *(optional)*  
    ```
    apt remove language-pack-pt language-pack-pt-base 
    ```

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
    apt install mousepad git clinfo lm-sensors curl dbus-x11 jq zenity mesa-utils
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
    copy [conceal-desktop.desktop] in applications
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
    cd /etc/systemd/system
    ```
    copy [ccx-assistant.service](./ingredients/etc/systemd/system/ccx-assistant.service)
    ```
    systemctl enable ccx-assistant.service
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

- [ ] **SRBMiner** (not open source ...otional)
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

- [ ] **xmr-stak** version for Concealers (with AMD GPU)
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
    or
    ```
    ./ubuntu_AMD_builder.sh
    ```
*Notes:*
    * final user will have to run `./xmr-stak` for initial setup
    * run `sudo ./ubuntu_shortcut_creator.sh` to install day to day icon and shortcut
    * run mining service installation script to generate a service.

- [ ] Conceal Toolbox  
    ```
    cd /opt
    mkdir conceal-toolbox
    ```
    * **mem alloc fail solver**
        ```
        git clone https://github.com/Acktarius/mem-alloc-fail_solver.git
        cd mem-alloc-fail_solver
        chmod +x mem_alloc_fail-solver.sh
        ```
    * **mining service**  
        ```
        git clone https://github.com/Acktarius/ccx-mining_service.git
        mv ccx-mining_service mining_service/
        cd ccx-mining_service
        chmod 755 mining_s.sh
        ```
        - icon:  
        ```
        cd /etc/skel/.icons
        ```
        copy [ms.png](./ingredients/etc/skel/.icons/ms.png)   
         - shortcut:  
        ```
        cd /opt/conceal-toolbox/ccx-mining_service
        cp m-s_script.desktop /etc/skel/.local/share/applications/m-s_script.desktop
        ```
    * **ping ccx pool**  
    ```
    apt install build-essential cmake libwxgtk3.0-gtk3-dev git nlohmann-json3-dev nmap
    git clone https://github.com/Acktarius/ping_ccx_pool_cpp.git
    cd ping_ccx_pool_cpp.git
    mkdir build && cd build
    cmake -DINSTALL_POLKIT_POLICY=ON ..
    cmake --build .
    cmake --install .
    ```
    *make sure the policy file org.acktarius.nping.policy in /usr/share/polkit-1/actions/*  

    * **oc-amd**  
    ```
    cd /opt/conceal-toolbox
    git clone https://github.com/Acktarius/oc-amd.git
    cd oc-amd
    chmod 755 *.sh
    ```

    * **EZ Privacy**
    ```
    cd /opt/
    git clone https://github.com/Acktarius/EZ_Privacy.git
    cd EZ_Privacy
    chmod 755 ez_privacy.sh
    cp ez_privacy_logo3_128.png /etc/skel/.icons/
    cp ez_privacy.desktop /etc/skel/.local/share/applications/
    ```

    * **extension4Concealers**
    ```
    apt-get -y install gnome-shell-extension-prefs fonts-noto
    git clone https://github.com/p-e-w/argos.git
    cd argos
    git switch -c gnome-44 GNOME-44
    mkdir -p /etc/skel/.local/share/gnome-shell/extensions
    cp -r argos@pew-worldwidemann.com /etc/skel/.local/share/gnome-shell/extensions/
    cd ..
    rm -rf argos
    cd /opt/conceal-toolbox
    git clone https://github.com/Acktarius/extension4Concealers.git
    cd extension4Concealers
    chmod 755 gpu.2r.5m+.sh
    chmod 755 assistant.1r.1m+.sh
    mkdir -p /etc/skel/.config/argos
    cp gpu.2r.5m+.sh /etc/skel/.config/argos/gpu.2r.5m+.sh
    cp assistant.1r.1m+.sh /etc/skel/.config/argos/assistant.1r.1m+.sh
    ```

    * **CCX-BOX_Apps**  
    ```
    cd /opt/conceal-toolbox
    git clone https://github.com/Acktarius/CCX-BOX_Apps.git
    cd CCX-BOX_Apps
    chmod 755 updater.sh
    cd /etc/skel/.local/share/applications/
    ```
    copy [CCX-BOX_Apps_updater.desktop](./ingredients/etc/skel/.local/share/applications/CCX-BOX_Apps_updater.desktop)
    

- [ ] **zmotd**  
    ```
    cd /etc/profile.d
    ```
    copy [zmotd.sh](./ingredients/etc/profile.d/zmotd.sh)

	
- [ ] **Background**  
    ```
    cd /usr/share/backgrounds/
    ```    
    copy all background files like [ccxBackground.jpg](./ingredients/usr/share/backgrounds/ccxBackground.jpg)
    ```
    cd ../gnome-background-properties/
    ```
    copy [jammy-wallpaper.xml](./ingredients/usr/share/gnome-background-properties/jammy-wallpapers.xml)

    ```
    cd ../glib-2.0/schemas/
    ```
    copy [90_custom.schema.override](./ingredients/usr/share/glib-2.0/schemas/90_custom.schema.override)

    ```
    cd
    glib-compile-schemas /usr/share/glib-2.0/schemas
    ```

- [ ] **Terminal profile**
    ```
    cd /opt/conceal-toolbox
    ```
    copy the folder [custom_setup](./ingredients/opt/conceal-toolbox/)
    ```
    cd custom_setup
    chmod 755 setup_script.sh
    cp ss.png /etc/skel/.icons/
    cp setup_script.desktop /etc/skel/.local/share/applications/
    ```

- [ ] **.face**
    `cd /etc/skel/`
    copy [.face](./ingredients/etc/skel/.face)
    
- [ ] **bashrc and bash_aliases**
    ```
    cd /etc/skel
    rm .bashrc
    ```
    copy our [.bashrc](./ingredients/etc/skel/.bashrc) and [.bash_aliases](./ingredients/etc/skel/.bashrc_aliases)


- [ ] **Fonts**
    ```
    cd .local/share
    mkdir fonts
    ```
    as you wish copy the ttf file from [Poppins](./ingredients/etc/skel/.local/fonts/Poppins/)

- [ ] **Tweaks**
    ```
    apt install gnome-tweaks
    ```

- [ ] **Slideshow**  

    copy the file in their respective folder from [slides](./ingredients/usr/share/ubiquity-slideshow/slides/)  
    if you wish to have a slideshow for oem install:  
    ```    
    apt-get install oem-config-slideshow-ubuntu
    ```
    Then also copy the files under `/usr/share/oem-config-slideshow/slides/l10n/
    

 - [ ] **CCX Assistant firefox shortcut**
    ```
    cd /opt/conceal-toolbox
    ```
    copy [ccx-assistant_firefox.sh](./ingredients/opt/conceal-toolbox/ccx-assistant_firefox.sh)
    ```
    chmod 755 ccx-assistant_firefox.sh
    ```
    - icon
    ```
    cd /etc/skel/.icons/
    ```
    copy [cham.png]  
    - shortcut
    ```
    cd /etc/skel/.local/share/applications
    ```
    copy [ccx-assistant_firefox.desktop](./ingredients/etc/skel/.local/share/applications/ccx-assistant_firefox.desktop)
 

- [ ] Flatpak
    ```
    add-apt-repository ppa:flatpak/stable
    apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ```

- [ ] **grub**
    ```
    nano /etc/default/grub
    ```
    *append GRUB_CMDLINE_LINUX_DEFAULT with :* `amdgpu.ppfeaturemask=0xffffffff`  
    
    ```
    cp /etc/default/grub /usr/share/grub/default/grub
    ```

## Third step on Cubic
![Cubic Step 3](docs/cubic_step3.png)
Select package you want to remove (i.e. save some space removing some languages)

## Fourth step on Cubic
![Cubic Step 4](docs/cubic_step4.png)

Modify presseed to take grub modification into account:  
> (a) Generate /boot/grub/grub.cfg using the customized version of /etc/default/>grub.  
>(b) Revert the customized version of /etc/default/grub after it has been >overwritten.  

```
ubiquity ubiquity/success_command string \
    in-target bash -c 'update-grub'; \
    in-target bash -c 'cp /usr/share/grub/default/grub /etc/default/grub';
```
