# build your own image for Raspberry Pi:
*(Tested on Pi4)*

## Prerequisite
```
#Download ubuntu arm release (optional)
cd ~/Download
wget https://cdimage.ubuntu.com/releases/22.04.5/release/ubuntu-22.04.5-preinstalled-desktop-arm64+raspi.img.xz
```
and modify `Conceal-Pi-OS.json` with:  
`"iso_url": "file:///home/<your-username>/Download/ubuntu-22.04.5-preinstalled-desktop-arm64+raspi.img.xz"`

## Dependencies
```
sudo apt update
sudo apt install git wget zip unzip build-essential kpartx qemu binfmt-support qemu-user-static e2fsprogs dosfstools
```

## install Packer version 1.6.6
```
export PACKER_RELEASE="1.6.6"
cd /tmp/
wget https://releases.hashicorp.com/packer/${PACKER_RELEASE}/packer_${PACKER_RELEASE}_linux_amd64.zip
unzip packer_${PACKER_RELEASE}_linux_amd64.zip
sudo mv packer /usr/local/bin
packer --version
```

## install arm Packer builder plugin:
```
export PACKER_ARM_BUILDER_VERSION="0.1.6"
cd /tmp/
wget https://github.com/solo-io/packer-builder-arm-image/releases/download/v${PACKER_ARM_BUILDER_VERSION}/packer-builder-arm-image
sudo mkdir -p ~/.packer.d/plugins
sudo chmod +x packer-builder-arm-image
sudo mv packer-builder-arm-image ~/.packer.d/plugins
```

## Build
```
git clone https://github.com/Acktarius/Conceal-OS.git
cd Conceal-OS
sudo packer build Conceal-Pi-OS.json
```
output will be raspberry-conceal-pi-os.img
### Compress
```
zip -r rpi-arm-ccx-image.zip raspberry-conceal-pi-os.img
```

### Generate SHA256
```
sha256sum rpi-arm-ccx-image.zip > rpi-arm-ccx-image.zip.sha256
```


### Verify integrity
```
sha256sum -c raspberry-conceal-pi-os.zip.sha256
```


### Unzip
```
unzip rpi-arm-ccx-image.zip
```

## Create bootable SSD
in raspberry pi imager, select **Use Custom**
![Custom](docs/Raspberry-Pi-custom-001.png)