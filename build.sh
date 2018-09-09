#!/bin/bash

ISOFILE=$1

# If missing, download latest version of the script that will respin the ISO
if [ ! -f isorespin.sh ]; then
    echo "Isorespin script not found. Downloading it..."
    wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

installpackages=""
# Packages that will be installed:
# Thermal management stuff and packages
installpackages+="thermald tlp tlp-rdw powertop "
# Nvidia
installpackages+="nvidia-driver-396 nvidia-prime bbswitch-dkms pciutils "
# Streaming and codecs for correct video encoding/play
installpackages+="va-driver-all vainfo libva2 gstreamer1.0-libav gstreamer1.0-vaapi "
# Others
installpackages+="intel-microcode"

GRUBOPTIONS="quiet acpi_rev_override=1 acpi_osi=Linux scsi_mod.use_blk_mq=1 nouveau.modeset=0 nouveau.runpm=0 mem_sleep_default=deep"

chmod +x isorespin.sh

./isorespin.sh -i $ISOFILE \
-r "ppa:graphics-drivers/ppa" \
-r "ppa:linrunner/tlp" \
-p "$installpackages" \
-f wrapper-network.sh \
-f wrapper-nvidia.sh \
-f update-packages.sh \
-f services/gpuoff.service \
-c wrapper-network.sh \
-c wrapper-nvidia.sh \
-c update-packages.sh \
-g "$GRUBOPTIONS"
