#!/bin/bash

ISOFILE=$1
KERNEL=$2
KERNELVERSION=$3

INPUTFOLDER=""
KERNELARGS=" -u "
GRUBOPTIONS="quiet splash acpi_rev_override=1"

# Parse ARGS
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -k|--kernel)
    echo "Setting kernel version..."
    KERNELVERSION="$2"
    KERNELARGS=" --kernel $KERNELVERSION "
    shift # past argument
    shift # past value
    ;;
    -c|--compatibility)
    echo "Setting compatibility..."
    COMPATIBILITY="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--docker)
    echo "Called from docker..."
    INPUTFOLDER="/docker-input/"
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
# End args parsing

# If missing, download latest version of the script that will respin the ISO
if [ ! -f isorespin.sh ]; then
	echo "Isorespin script not found. Downloading it..."
	wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

installpackages=""

# Packages that differs based on ubuntu version
if [ -n "$COMPATIBILITY" ]; then
	if [ "$COMPATIBILITY" == "bionicbeaver" ]; then
		installpackages+="libva2 "
		installpackages+="bbswitch-dkms "
		installpackages+="pciutils "
		installpackages+="lsb-release "
		# Nvidia
		installpackages+="nvidia-driver-396 "
		installpackages+="nvidia-prime "

		GRUBOPTIONS="quiet splash acpi_rev_override=1 nouveau.modeset=0"
	else
		installpackages+="libva1 "
		# Nvidia
		installpackages+="nvidia-390 "
		installpackages+="nvidia-prime "
	fi
else
	installpackages+="libva1 "
	# Nvidia
	installpackages+="nvidia-390 "
	installpackages+="nvidia-prime "
fi

# Packages that will be installed:
# Thermal management stuff and packages
installpackages+="thermald "
installpackages+="tlp "
installpackages+="tlp-rdw  "
installpackages+="powertop "
# Streaming and codecs for correct video encoding/play
installpackages+="va-driver-all "
installpackages+="vainfo "
installpackages+="gstreamer1.0-libav "
installpackages+="gstreamer1.0-vaapi "
# Useful music/video player with large set of codecs
installpackages+="vlc "

# Packages that will be removed:
#removepackages=""

chmod +x isorespin.sh

sync;

if [ "$COMPATIBILITY" == "xenialxerus" ]; then
	echo "isorespin.sh -i $INPUTFOLDER$ISOFILE"
	wget -O libssl.deb http://mirrors.kernel.org/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
	# Xenialxerus require an upgraded libssl to use/install new kernels
	./isorespin.sh -i "$INPUTFOLDER""$ISOFILE" --upgrade -l libssl.deb
	mv linuxium-* $ISOFILE
	INPUTFOLDER=""
fi

echo "isorespin.sh -i $INPUTFOLDER$ISOFILE"

./isorespin.sh -i "$INPUTFOLDER""$ISOFILE" \
	$KERNELARGS \
	-r "ppa:graphics-drivers/ppa" \
	-p "$installpackages" \
	-f wrapper-network.sh \
	-f wrapper-nvidia.sh \
	-f services/gpuoff.service \
	-c wrapper-network.sh \
	-c wrapper-nvidia.sh \
	-g "" \
	-g "$GRUBOPTIONS"
