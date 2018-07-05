![DELL XPS 9570](https://github.com/jackhack96/dell-xps-9570-ubuntu-respin/raw/master/screenshot.png)

# DELL XPS 15 9570 Ubuntu Respin

# Overview

Collection of scripts and tweaks to make Ubuntu 18.04 run smooth on Dell XPS 15 9570.

All informations, tips and tricks was gathered from:

- [tomwwright gist for DELL XPS 15 9560](https://gist.github.com/tomwwright/f88e2ddb344cf99f299935e1312da880)
- [Atheros wifi card fix](https://ubuntuforums.org/showthread.php?t=2323812&page=2)
- [Respin script and info](http://linuxiumcomau.blogspot.com/)
- Myself xD

Kudos and all the credits for things not related to my work go to developers and users on those pages!

### What Works Out-of-the-Box

 - ✅ Atheros Wifi
 - ✅ Audio
 - ✅ Audio on HDMI
 - ✅ HDMI ( even on lid closed )
 - ✅ Nvidia/Intel graphic cards switch
 - ✅ Keyboard backlight
 - ✅ Display brightness
 - ✅ Sleep/wake

### What Doesn't Work at the Moment

 - ❌ Goodix Fingerprint sensor

### Overview for Building and Respinning an ISO

1. [Clone the repo and install necessary tools](#step-1-cloning-the-repo-and-installing-tools)
1. [Download your Ubuntu 18.04 ISO](#step-2-download-your-ubuntu-1804-iso)
1. [Respin the ISO (it many take a about 30 minutes or even longer)](#step-3-build-your-respun-iso)
1. [Install OS and run post-install commands](#step-4-install-and-update)

## Step 1: Cloning the Repo and Installing Tools

To respin an existing Ubuntu ISO, you will need to use a Linux machine with some packages like `squashfs-tools` and `xorriso` installed (e.g. `sudo apt install -y squashfs-tools xorriso`) and a working internet connection. Script require at least 10GB of free storage space.

The first step is to clone this repo: 
```
git clone https://github.com/jackhack96/dell-xps-9570-ubuntu-respin.git
cd dell-xps-9570-ubuntu-respin/
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

## Step 2: Download your Ubuntu 18.04 ISO

Download Ubuntu 18.04 ISO and copy it in this repository cloned folder.

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

### Post-install and troubleshooting

If you want touchpad gestures, check https://github.com/bulletmark/libinput-gestures.

If you hear some annoying hissing sounds when using headphones (it's due to power saving), run the following command:
```shell
amixer set 'Headphone Mic' 1db
```
If it doesn't work, you could try disabling audio power saving simply by editing (as root) `/etc/default/tlp` and changing this line:
```shell
SOUND_POWER_SAVE_ON_BAT=1
```
to
```shell
SOUND_POWER_SAVE_ON_BAT=0
```

If you notice some graphic stuttering and it really bothers you, try first disabling panel self refresh. To do that edit as root 
`/etc/modprobe.d/i915.conf`, and delete `enable_psr=2`. The line should be something like:
```shell
options i915 enable_fbc=1 enable_guc=-1 disable_power_well=0 fastboot=1
```
After editing the file, update the kernel boot image by using `sudo update-initramfs -u`.
If the stuttering is still present, disable also the framebuffer compression option, by deleting `enable_fbc=1`.
If neither this fixes the stuttering, simply delete the file (`sudo rm /etc/modprobe.d/i915.conf && sudo update-initramfs -u`).

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
