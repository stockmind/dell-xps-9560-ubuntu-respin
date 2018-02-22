#!/bin/bash

ISOFILE=$1
KERNEL=$2
KERNELVERSION=$3

KERNELARGS=" -u "

if [[ $KERNEL == "-k" ]] ; then
    echo "Setting kernel version..."
    KERNELARGS=" --kernel $KERNELVERSION "
fi

# If missing, download latest version of the script that will respin the ISO
if [ ! -f isorespin.sh ]; then
	echo "Isorespin script not found. Downloading it..."
	wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

installpackages=""
# Packages that will be installed:
# Thermal management stuff and packages
installpackages+="thermald "
installpackages+="tlp "
installpackages+="tlp-rdw  "
installpackages+="powertop "
# Nvidia
installpackages+="nvidia-390 "
installpackages+="nvidia-prime "
# Streaming and codecs for correct video encoding/play
installpackages+="va-driver-all "
installpackages+="vainfo "
installpackages+="libva1 "
installpackages+="gstreamer1.0-libav "
installpackages+="gstreamer1.0-vaapi "
# Useful music/video player with large set of codecs
installpackages+="vlc "

# Packages that will be removed:
#removepackages=""

chmod +x isorespin.sh

./isorespin.sh -i $ISOFILE \
	$KERNELARGS \
	-r "ppa:graphics-drivers/ppa" \
	-p "$installpackages" \
	-f wrapper-network.sh \
	-f wrapper-nvidia.sh \
	-c wrapper-network.sh \
	-c wrapper-nvidia.sh \
	-g "" \
	-g "quiet splash acpi_rev_override=1"