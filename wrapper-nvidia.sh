#!/bin/bash

cd /usr/local/bin

sudo prime-select intel 2> /dev/null

cp gpuoff.service /lib/systemd/system/gpuoff.service
sudo systemctl enable gpuoff

rm -f wrapper-nvidia.sh

echo "options i915 enable_fbc=1 enable_psr=2 enable_guc=-1 disable_power_well=0 fastboot=1" > /etc/modprobe.d/i915.conf
update-initramfs -u