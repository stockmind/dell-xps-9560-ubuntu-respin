#!/bin/bash

sudo add-apt-repository universe
sudo apt update
sudo apt full-upgrade -y

sudo rm -f /usr/local/bin/update-packages.sh
