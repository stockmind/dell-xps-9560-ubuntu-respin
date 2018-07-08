#!/bin/bash

cd /usr/local/bin

sudo mv powertop.service /lib/systemd/system/powertop.service
sudo systemctl enable powertop

sudo rm -f /usr/local/bin/wrapper-powertop.sh