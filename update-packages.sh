#!/bin/bash

sudo add-apt-repository universe
echo 'deb http://archive.ubuntu.com/ubuntu/ bionic-proposed restricted main multiverse universe' > /etc/apt/sources.list
sudo apt update
sudo apt full-upgrade -y

sudo rm -f /usr/local/bin/update-packages.sh
