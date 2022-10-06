#!/bin/bash
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
echo "SRC_DIR:" $SRC_DIR

# Upgrade all packages of the system
echo "--> Upgrade all packages of the system"
sudo apt update
sudo apt upgrade -y

# Install pip and pipenv dependency management
echo "--> Install pip and pipenv dependency management"
sudo apt install python3-pip pipenv python3-venv -y
cd $SRC_DIR
python3 -m venv .venv
source $SRC_DIR/.venv/bin/activate
pipenv install

# Install pigpio for LED PWM and enable the daemon. https://github.com/joan2937/pigpio
echo "--> Install pigpio for LED PWM and enable the daemon. https://github.com/joan2937/pigpio"
sudo apt-get install pigpio -y
wget https://raw.githubusercontent.com/joan2937/pigpio/master/util/pigpiod.service -O $SRC_DIR/../../pigpiod.service
sudo cp $SRC_DIR/../../pigpiod.service /etc/systemd/system
sudo systemctl enable pigpiod.service
sudo systemctl start pigpiod.service

# Make script executable
echo "--> Make script executable"
sudo chmod +x $SRC_DIR/server/main.py $SRC_DIR/server/lights.py

# Register autostart
echo "--> Register autostart"
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

# Turn off system LED
sudo sed -i '$ d' /etc/rc.local
sudo bash -c "cat >/etc/rc.local" <<'EOF'
# Disable the ACT LED on the Pi Zero.
echo none | sudo tee /sys/class/leds/led0/trigger
echo 0 | sudo tee /sys/class/leds/led0/brightness

exit 0
EOF


