# Conceal-OS
procedure step by step to build Conceal OS iso
## Overview
The detailed build procedure for Conceal OS can be found in the [recipe.md](recipe.md) file. All required components and files are located in the `ingredients` folder.

## Legal Notice
Please note that Conceal OS incorporates various third-party components and software. Users must comply with all licenses and copyright notices associated with these components, including but not limited to:
- Ubuntu and its associated packages
- AMD drivers and software
- Cubic and its dependencies
- Any additional components in the `ingredients` folder

It is the user's responsibility to review and comply with all applicable licenses, terms of use, and copyright notices before building and using Conceal OS.

## Build Requirements

### Base System
- Ubuntu 20.04.1 LTS
  - Download link: [Ubuntu 22.04.1 LTS ISO](https://releases.ubuntu.com/22.04/ubuntu-22.04.1-desktop-amd64.iso)

### Required Tools
#### Cubic (Custom Ubuntu ISO Creator)
  - Developed by PJ Singh
  - Repository: [https://github.com/PJ-Singh-001/Cubic](https://github.com/PJ-Singh-001/Cubic)
  - We strongly recommend using this tool for building the Conceal OS ISO

*or*  
#### Packer 1.10.0 (for automated builds)
  - Download and install Packer:
    ```bash
    export PACKER_VERSION="1.10.0"
    cd /tmp
    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
    unzip packer_${PACKER_VERSION}_linux_amd64.zip
    sudo mv packer /usr/local/bin/
    packer --version
    ```
  - Initialize Packer plugins (required for QEMU builder):
    ```bash
    cd /path/to/Conceal-OS
    packer init plugins.pkr.hcl
    ```
  - This will download the required QEMU plugin to `~/.packer.d/plugins/`
  - Install QEMU (required for Packer QEMU builder):
    ```bash
    sudo apt update
    sudo apt install -y qemu-system-x86 qemu-utils
    ```
    **Note**: Without QEMU installed, you will encounter the error: `exec: "qemu-system-x86_64": executable file not found in $PATH`

  - Quick Start (Packer Method)
    1. **Build**: Run `./customize-build.sh` - Select build type (Miner/xfce/Pi), enter credentials, builds QCOW2 image
    2. **Test** (optional): Run `./boot-vm.sh` - Boot image in QEMU for testing
    3. **Deploy**: Run `sudo ./create-disk.sh` - Write image to physical disk (USB/SSD/HDD)

### Additional Components
- AMD Drivers
  - Download link: [AMD Drivers](...)

## Getting Started
1. Download the required Ubuntu 20.04.3 LTS ISO
2. Install Cubic following instructions from the repository
3. Follow the detailed build procedure in [recipe.md](recipe.md)
4. Use the components from the `ingredients` folder as specified in the recipe

## Version Control Notice
Please note that specific versions of components are carefully chosen in this build recipe for important reasons:

### AMD Driver Version
We specifically use AMDGPU driver version 5.4.50403 instead of newer versions because:
- It maintains critical power management functionality that has been removed in newer versions
- It allows for better control over power consumption during mining operations
- This results in:
  - Lower electricity costs
  - Reduced environmental impact
  - Better thermal management
  - Potentially extended GPU lifespan

### Kernel Version
The recipe specifies kernel 5.15.0-43-generic which, combined with the AMDGPU driver version and specific GRUB parameters, creates a known-good configuration for optimal mining operations.

Updating these components to newer versions, while tempting, may result in loss of important functionality. Please maintain these version requirements unless you have specific reasons to change them.

### References:
* [Howtoforge.com](https://www.howtoforge.com/how-to-block-package-and-kernel-updates-in-debian-ubuntu/)

### Considering to Donate ?
* Donation to Conceal Network CCX address:
```
ccx7V4LeUXy2eZ9waDXgsLS7Uc11e2CpNSCWVdxEqSRFAm6P6NQhSb7XMG1D6VAZKmJeaJP37WYQg84zbNrPduTX2whZ5pacfj
```
* Donation to Acktarius CCX address:
```
ccx7Zbm7PjafXKvb3naqpGXzhLtAXesKiR5UXUbfwD9MCf77XdvXf1TX64KdDjcTDb3E7dS6MGE2GKT3w4DuCb8H9dwvWWGuof
```