#!/bin/bash

ISOFILE=''
# if -v flag is set true then install video codecs for encoding and playing videos
video_flag=''
# if -s flag is set true then SPECTRE/Meltdown patches will be used
spectre_flag=''

# If missing, download latest version of the script that will respin the ISO
if [ ! -f isorespin.sh ]; then
    echo "Isorespin script not found. Downloading it..."
    wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

print_help() {
  echo '-h    Print this help message'
  echo '-v [true|false]   When set to true video codecs for encoding and playing videos will be installed'
  echo '-s [true|false]   When set to true SPECTRE/Meltdown patches will be disabled for additional performance'
  exit 0
}

# Checks if flags are set to valid true or false, also lets the user know what was selected
validate_flags() {
  if [ $video_flag == 'true'  ]; then
    echo 'video codecs will be installed'
  elif [ $video_flag == 'false' ]; then
    echo 'video codecs will not be installed'
  else
    echo '-v must be true or false'
    exit 1
  fi

  if [ $spectre_flag == 'true'  ]; then
    echo 'SPECTRE/Meltdown patches will be disabled'
  elif [ $spectre_flag == 'false' ]; then
    echo 'SPECTRE/Meltdown patches will be used'
  else
    echo '-s must be true or false'
    exit 1
  fi
}

# Parse flags
while getopts 'hi:v:s:' flag; do
  case "${flag}" in
    h) print_help ;;
    i) ISOFILE=$OPTARG ;;
    v) video_flag=$OPTARG ;;
    s) spectre_flag=$OPTARG ;
   esac
done

# If user didn't set video codecs flag then ask them now
if [ -z $video_flag ]; then
  # Streaming and codecs for correct video encoding/play
  echo "Do you wish to install video codecs for encoding and playing videos?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) video_flag='true'; break;;
      No ) video_flag='false'; break;;
    esac
  done
fi

# if user didnt set flag for spectre then ask them now
if [ -z $spectre_flag ]; then
  echo "Do you wish to disable SPECTRE/Meltdown patches for additional performance?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) spectre_flag='true'; break;;
      No ) spectre_flag='false'; break;;
    esac
  done
fi

installpackages=""
# Packages that will be installed:
# Thermal management stuff and packages
installpackages+="thermald tlp tlp-rdw powertop "
# Stability and security updates to the processor
installpackages+="intel-microcode "

GRUBOPTIONS="quiet acpi_rev_override=1 acpi_osi=Linux nouveau.modeset=0 pcie_aspm=force drm.vblankoffdelay=1 scsi_mod.use_blk_mq=1 nouveau.runpm=0 mem_sleep_default=deep "

validate_flags

if [ $video_flag = 'true' ]; then
  installpackages+="va-driver-all vainfo libva2 gstreamer1.0-libav gstreamer1.0-vaapi "
fi
if [ $spectre_flag = 'true' ]; then
  GRUBOPTIONS+="pti=off spectre_v2=off l1tf=off nospec_store_bypass_disable no_stf_barrier "
fi

chmod +x isorespin.sh

./isorespin.sh -i $ISOFILE \
-k v4.19.8 \
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
