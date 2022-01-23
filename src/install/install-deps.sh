#!/bin/bash

# Upgrade all packages of the system
sudo apt update
sudo apt upgrade -y

# Install git
sudo apt install git -y

# Install Python and some Python packages
sudo apt install python3-setuptools -y
sudo apt install python3-flask python3-crontab python3-rpi.gpio -y

# Install pigpio for LED PWM and enable the daemon. https://github.com/joan2937/pigpio
sudo apt-get update -y
sudo apt-get install pigpio -y
wget https://raw.githubusercontent.com/joan2937/pigpio/master/util/pigpiod.service
sudo cp pigpiod.service /etc/systemd/system
sudo systemctl enable pigpiod.service
sudo systemctl start pigpiod.service