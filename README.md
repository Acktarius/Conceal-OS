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
- Cubic (Custom Ubuntu ISO Creator)
  - Developed by PJ Singh
  - Repository: [https://github.com/PJ-Singh-001/Cubic](https://github.com/PJ-Singh-001/Cubic)
  - We strongly recommend using this tool for building the Conceal OS ISO

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


