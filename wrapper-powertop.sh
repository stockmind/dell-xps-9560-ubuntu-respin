#!/bin/bash

cd /usr/local/bin

cp powertop.service /lib/systemd/system/powertop.service
sudo systemctl enable powertop
rm -f wrapper-powertop.sh
