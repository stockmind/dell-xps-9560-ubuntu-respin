#!/bin/bash

cd /usr/local/bin

sudo prime-select intel 2> /dev/null

cp gpuoff.service /lib/systemd/system/gpuoff.service
sudo systemctl enable gpuoff

rm -f wrapper-nvidia.sh
