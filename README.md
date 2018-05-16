[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YYGKKE6FDX2KY) [![Donate Bitcoin](https://img.shields.io/badge/Donate-Bitcoin-green.svg)](https://stockmind.github.io/donate-bitcoin/) [![Docker Build Statu](https://img.shields.io/docker/build/stockmind/dell-xps-9560-ubuntu-respin.svg)]() [![Docker Automated buil](https://img.shields.io/docker/automated/stockmind/dell-xps-9560-ubuntu-respin.svg)]()

![DELL XPS 9560](https://github.com/stockmind/dell-xps-9560-ubuntu-respin/raw/master/screenshot.png)

# DELL XPS 15 9560 Ubuntu Respin

# Overview

Collection of scripts and tweaks to adapt Ubuntu and Linux Mint ISO images to let them run smooth on Dell XPS 15 9560.
This might work on other Dell XPS too.

All informations, tips and tricks was gathered from:

- [tomwwright gist for DELL XPS 15 9560](https://gist.github.com/tomwwright/f88e2ddb344cf99f299935e1312da880)
- [Atheros wifi card fix](https://ubuntuforums.org/showthread.php?t=2323812&page=2)
- [Respin script and info](http://linuxiumcomau.blogspot.com/)

Kudos and all the credits for things not related to my work go to developers and users on those pages!

### What Works Out-of-the-Box

 - ✔ Wifi (Atheros models too)
 - ✔ Audio
 - ✔ Audio on HDMI
 - ✔ HDMI ( even on lid closed )
 - ✔ Nvidia/Intel graphic cards switch
 - ✔ Touchpad gestures
 - ✔ Keyboard backlight
 - ✔ Display brightness
 - ✔ Sleep/wake
 - ✔ No random freeze or kernel panics

### What Doesn't Work at the Moment

 - Not known for the moment
 
## Ubuntu 18.04 issues

There is still a major issue on 18.04:

 - Prime-select intel is not powering off the nvidia card, so even if you use the intel card your battery will drain a lot faster (20w instead of 10w). The service suggested in issue #8 may help. 
 
**Ubuntu 17.10 is stable and is not affected by those issues.** 
If you need a reliable system stick to Ubuntu 17.10 until those issues gets fixed. 
 
### Download an Already Respun ISO

- Download ISO from [Release page](https://github.com/stockmind/dell-xps-9560-ubuntu-respin/releases/tag/v1.0)
- Mirror: https://downloads.cre.ovh/ (Experimental ISOs will be uploaded here)

And follow guide from [Step 4: Install and Update](#step-4-install-and-update)

### Overview for Building and Respinning an ISO

1. [Clone the repo and install necessary tools](#step-1-cloning-the-repo-and-installing-tools)
1. [Download your ISO of choice](#step-2-download-your-iso-of-choice)
1. [Respin the ISO (it many take a about 30 minutes or even longer)](#step-3-build-your-respun-iso)
1. [Install OS and run post-install commands](#step-4-install-and-run-post-install)

## Respin iso with Docker

![Docker](https://github.com/stockmind/dell-xps-9560-ubuntu-respin/raw/master/Docker.png)

[Click here for the Docker building section](#build-with-docker)

## Build and respin without Docker
## Step 1: Cloning the Repo and Installing Tools

To respin an existing Ubuntu ISO, you will need to use a Linux machine with some packages like `squashfs-tools` and `xorriso` installed (e.g. `sudo apt install -y squashfs-tools xorriso`) and a working internet connection. Script require at least 10GB of free storage space.

The first step is to clone this repo: 
```
git clone https://github.com/stockmind/dell-xps-9560-ubuntu-respin.git
cd dell-xps-9560-ubuntu-respin/
```
### Debian-based systems:

Install all the required packages:
```
sudo apt install -y git wget genisoimage bc squashfs-tools xorriso
```
### Arch-Based Systems:

Install all the required packages:
``` 
sudo pacman -S git wget cdrkit bc libisoburn squashfs-tools dosfstools
```

## Step 2: Download your ISO of Choice

Download your favourite distribution ISO and copy it in this repository cloned folder.

## Step 3: Build Your Respun ISO

Run `./build.sh` script as specified for your desired distro.

### Build on Debian-based systems:

* Build ISO running this:
```
./build.sh <iso filename>
```

Or:

```
./build.sh <iso filename> -k <kernelversion>
```

If you don't set a -k flag, the latest mainline kernel will be installed during respin.

Value for -k flag can be any of the Ubuntu Kernel Team kernel builds located at http://kernel.ubuntu.com/~kernel-ppa/mainline and is passed as the directory or folder name without the trailing

### Build Ubuntu 18.04 ISO or 2018+ newest distro

Launch build.sh script with `-c` compatibility parameter set to `bionicbeaver`:

```
./build.sh <iso filename> -k <kernelversion> -c bionicbeaver
```

### Build on Arch-based systems:

* Build ISO running this:
```
PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filename>
```  

Or:

```
PATH=/usr/sbin:/sbin:/bin:$PATH ./build.sh <iso filename> -k <kernelversion>
```

If you don't set a -k flag, the latest mainline kernel will be installed during respin.

Value for -k flag can be any of the Ubuntu Kernel Team kernel builds located at http://kernel.ubuntu.com/~kernel-ppa/mainline and is passed as the directory or folder name without the trailing
## Step 4: Install and Update

### Boot ISO from USB device

I sugget [Etcher](https://etcher.io/) to write ISO on usb flash drives.
It's fast, reliable and multi-platform.

Boot system using one time boot menu.
Disable Secure boot in bios to boot from the ISO.

### Post-install

These commands should be run after the first boot.
```
sudo tlp start
sudo powertop --auto-tune
```

#### Switch from one graphic card to the other
Intel:
```
sudo prime-select intel
```
Nvidia:
```
sudo prime-select nvidia
```

**Note: A logout and login could be required when switching graphic cards.**

# Build with Docker

![Docker](https://github.com/stockmind/dell-xps-9560-ubuntu-respin/raw/master/Docker.png)

You can respin iso and build kernels on a Docker environment easily. This build system will likely work on any x86 Docker supported platform. Tested and working on Linux and MacOS, builds on Windows not tested yet.

You just need to build the Docker image, or download it from Docker Hub, and follow the steps below.

## 1a. Download image from Docker Hub

```
docker pull stockmind/dell-xps-9560-ubuntu-respin
```

## 1b. Or build the Docker image locally

Clone repository and run the following script to build the docker image

```
./docker-build-image.sh
```

Once the image is ready you can choose from the following steps:

## 2a. Respin ISO

To respin an ISO you need to place desired ISO in ```origin/``` folder of this repository then run:
  
```
./docker-respin.sh <iso-file-name>
```

```
./docker-respin.sh <iso-file-name> -k <kernelversion>
```

Example:
```
./docker-respin.sh origin/ubuntu-17.10.1-desktop-amd64.iso
```
Or:
```
./docker-respin.sh origin/xubuntu-17.10.1-desktop-amd64.iso -k v4.15.4
```

If you don't set a -k flag, the latest mainline kernel will be used.

Value for -k flag can be any of the Ubuntu Kernel Team kernel builds located at http://kernel.ubuntu.com/~kernel-ppa/mainline and is passed as the directory or folder name without the trailing

Let it run, it will take from 10 to 30 minutes based on your internet connection and system speed.
Once done you will find output ISO in ```destination/``` folder of this repository.

**If you are using the Docker Hub image remember to always pull latest version before running any of those scripts!**
```
docker pull stockmind/dell-xps-9560-ubuntu-respin
```

# Donate

If my work helped you consider a little donation to buy me a coffe... or an energy drink! :smile:

**Paypal**

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YYGKKE6FDX2KY)

**Bitcoin**

[![Donate Bitcoin](https://stockmind.github.io/donate-bitcoin/bitcoin-button.png)](https://stockmind.github.io/donate-bitcoin/)
