#!/usr/bin/env bash

# Check if the script is running under Ubuntu 18.04 Bionic Beaver
if [ $(lsb_release -c -s) != "bionic" ]; then
    echo "This script is made for Ubuntu 18.04!"
    exit 1
fi

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run xps-tweaks as root!"
    exit 1
fi

# Install all the power management tools
add-apt-repository ppa:linrunner/tlp -y
apt -y update
apt install thermald tlp tlp-rdw powertop -y

# Install the latest nVidia driver and codecs
add-apt-repository ppa:graphics-drivers/ppa -y
apt -y update
apt install nvidia-driver-396 nvidia-prime bbswitch-dkms va-driver-all vainfo libva2 gstreamer1.0-libav gstreamer1.0-vaapi -y

# Create gpuoff.service for working around nouveau power management bug
echo "
[Unit]
Description=Power-off gpu

[Service]
Type=oneshot
ExecStart=/bin/bash -c \"if [[ `prime-select query` == 'intel' ]]; then echo auto > /sys/bus/pci/devices/0000\:01\:00.0/power/control; fi\"

[Install]
WantedBy=default.target
" > /lib/systemd/system/gpuoff.service

# Create powertop.service for power management
echo "
[Unit]
Description=Powertop tunings

[Service]
ExecStart=/usr/sbin/powertop --auto-tune
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
" > /lib/systemd/system/powertop.service

# Load and enable systemd units
systemctl daemon-reload
systemctl enable gpuoff.service
systemctl enable powertop.service
systemctl disable nvidia-fallback

# Enable power saving tweaks for Intel chip
echo "options i915 enable_fbc=1 enable_psr=2 enable_guc=-1 disable_power_well=0 fastboot=1" > /etc/modprobe.d/i915.conf
update-initramfs -u

# Switch to Intel card
prime-select intel 2> /dev/null

echo "FINISHED! Please reboot the machine!"
