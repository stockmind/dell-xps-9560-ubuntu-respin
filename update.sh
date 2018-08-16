#!/usr/bin/env bash

# This script require root privileges
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# Parse ARGS
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--compatibility)
    echo "Setting compatibility..."
    COMPATIBILITY="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
# End args parsing

GRUBOPTIONS="quiet splash acpi_rev_override=1"

# Add graphics drivers PPA
sudo add-apt-repository ppa:graphics-drivers/ppa

# Fix Atheros cards
sudo rm /lib/firmware/ath10k/QCA6174/hw3.0/*
sudo wget -O /lib/firmware/ath10k/QCA6174/hw3.0/board.bin https://github.com/kvalo/ath10k-firmware/blob/master/QCA6174/hw3.0/board.bin?raw=true
sudo wget -O /lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin https://github.com/kvalo/ath10k-firmware/blob/master/QCA6174/hw3.0/board-2.bin?raw=true
sudo wget -O /lib/firmware/ath10k/QCA6174/hw3.0/firmware-4.bin https://github.com/kvalo/ath10k-firmware/blob/master/QCA6174/hw3.0/firmware-4.bin_WLAN.RM.2.0-00180-QCARMSWPZ-1?raw=true

# Select only required packages
installpackages=""
# Packages that will be installed:
# Thermal management stuff and packages
installpackages+="thermald "
installpackages+="tlp "
installpackages+="tlp-rdw  "
installpackages+="powertop "
# Streaming and codecs for correct video encoding/play
installpackages+="va-driver-all "
installpackages+="vainfo "
if [ -n "$COMPATIBILITY" ]; then
	if [ "$COMPATIBILITY" == "bionicbeaver" ]; then
		installpackages+="libva2 "
		installpackages+="bbswitch-dkms "
		installpackages+="pciutils "
		installpackages+="lsb-release "
		# Nvidia
		installpackages+="nvidia-driver-396 "
		installpackages+="nvidia-prime "

		GRUBOPTIONS="quiet splash acpi_rev_override=1 nouveau.modeset=0"
	else
		installpackages+="libva1 "
		# Nvidia
		installpackages+="nvidia-390 "
		installpackages+="nvidia-prime "
	fi
else
	installpackages+="libva1 "
	# Nvidia
	installpackages+="nvidia-390 "
	installpackages+="nvidia-prime "
fi
installpackages+="gstreamer1.0-libav "
installpackages+="gstreamer1.0-vaapi "
# Useful music/video player with large set of codecs
installpackages+="vlc "

# refresh packages list
apt update

# install required packages
echo "Install required packages..."
for i in $installpackages; do
  sudo apt-get install -y $i
done

# set intel GPU
sudo prime-select intel 2> /dev/null

# install GPU service
cp gpuoff.service /lib/systemd/system/gpuoff.service
sudo systemctl enable gpuoff

# update grub
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"$GRUBOPTIONS\"/" /etc/default/grub
sudo sed -i "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"$GRUBOPTIONS\"/" /etc/default/grub

sudo update-grub
