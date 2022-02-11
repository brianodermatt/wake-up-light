#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Upgrade all packages of the system
sudo apt update
sudo apt upgrade -y

# Install git
sudo apt install git -y

# Install Python and some Python packages
sudo apt install python3-setuptools -y
sudo apt install python3-flask python3-crontab python3-rpi.gpio python3-numpy python3-scipy python3-pigpio -y

# Install pigpio for LED PWM and enable the daemon. https://github.com/joan2937/pigpio
sudo apt-get update -y
sudo apt-get install pigpio -y
wget https://raw.githubusercontent.com/joan2937/pigpio/master/util/pigpiod.service -O $DIR/../../../pigpiod.service
sudo cp $DIR/../../../pigpiod.service /etc/systemd/system
sudo systemctl enable pigpiod.service
sudo systemctl start pigpiod.service

# Make script executable
sudo chmod +x $DIR/../server/main.py $DIR/../server/lights.py

# Register autostart
sudo bash -c "cat >/etc/systemd/system/app.service" <<'EOF'
[Unit]
Description=Flask app
After=network.target

[Service]
ExecStart=/home/pi/wake-up-light/src/server/main.py
WorkingDirectory=/home/pi/wake-up-light/src/server
Restart=on-failure
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo bash -c "cat >/etc/systemd/system/pigpio.service" <<'EOF'
[Unit]
Description=Pigpio daemon

[Service]
ExecStart=/usr/local/bin/pigpiod
WorkingDirectory=/home/pi/wake-up-light/src/server
Restart=on-failure
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable app pigpio
