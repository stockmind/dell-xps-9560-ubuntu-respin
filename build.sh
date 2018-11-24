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

# Streaming and codecs for correct video encoding/play
echo "Do you wish to install video codecs for encoding and playing videos?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) installpackages+="va-driver-all vainfo libva2 gstreamer1.0-libav gstreamer1.0-vaapi "; break;;
        No ) exit;;
    esac
done

# Others
installpackages+="intel-microcode"

GRUBOPTIONS="quiet acpi_rev_override=1 acpi_osi=Linux nouveau.modeset=0 pcie_aspm=force drm.vblankoffdelay=1 scsi_mod.use_blk_mq=1 nouveau.runpm=0 mem_sleep_default=deep "
echo "Do you wish to disable SPECTRE/Meltdown patches for performance?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) GRUBOPTIONS+="pti=off spectre_v2=off l1tf=off nospec_store_bypass_disable no_stf_barrier"; break;;
        No ) exit;;
    esac
done


chmod +x isorespin.sh

./isorespin.sh -i $ISOFILE \
-r "ppa:graphics-drivers/ppa" \
-r "ppa:linrunner/tlp" \
-p "$installpackages" \
-f wrapper-network.sh \
-f wrapper-nvidia.sh \
-f update-packages.sh \
-c wrapper-network.sh \
-c wrapper-nvidia.sh \
-c update-packages.sh \
-g "$GRUBOPTIONS"
