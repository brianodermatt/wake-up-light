# Raspberry Pi Setup
## Conventions
Here, items prefixed with `$` can be replaced with the respective tokens:
```
$USER: brian
```

## Install Raspberri Pi OS
Use Raspberry Pi Imager to install Raspbian (used: Raspberry Pi Imager v1.6.2).
- Select OS: Raspberry Pi OS (other) -> Raspberry Pi OS Lite (32-bit).
- Press `CTRL+SHIFT+x` to open advanced options.
- Set hostname: `wakeup`.local
- Enable SSH, set a password and write it down.
- Configure WiFi with SSID, password, country.

## Startup
- Insert SD card into Raspberry Pi, connect Ethernet, connect power.
- Wait for a few minutes, especially during first startup.

## SSH Connection
- Use the previously configured hostname: `wakeup.local`.
- Instead, you can also use the IP. You can find the IP address of the Raspberry Pi using your router's web interface for example. In my case it is `192.168.0.25`.
- Connect to the Raspbery Pi using SSH
    - On Ubuntu: `ssh pi@wakeup.local` (or `ssh pi@192.168.0.25`).
    - On Windows you may need to use Putty.

## System Configuration
- Connected to the Raspberry via ssh, run `sudo raspi-config` to open the configuration tool.
- Set the correct locale: `5 Localisation Options` > `L1 Locale` (in my case `de_CH.UTF-8` with the default system locale `en_GB.UTF-8`).
- Set the correct timezone: `5 Localisation Options` > `L2 Timezone` (in my case `Europe` > `Zurich`).
- Expand filesystem: `6 Advanced Options` > `A1 Expand Filesystem`
- Reduce memory for GPU (as we are running headless): `4 Performance` > `P2 GPU Memory`. Set minimum (in my case `16 MB`).
- Quit the config tool. When asked to reboot, allow.

## Installation
- Install git: `sudo apt install git -y`
- Clone this repo on the Raspberry: `git clone https://github.com/brianodermatt/wake-up-light -b main`
- Install the needed software. This upgrades the system, installs python, some python packages, as well as [pigpio](https://github.com/joan2937/pigpio) for LED PWM. It will furthermore set the needed permissions and register the server for starting upon boot. The execution of this script may take several minutes.
  ```bash
  chmod +x wake-up-light/src/install/install-deps.sh
  ./wake-up-light/src/install/install-deps.sh
  ```
- Reboot: `sudo reboot`

## Disable system LEDs
<!--(TODO)-->
DISCLAIMER: not yet tested 

Add the following lines to `/boot/config.txt`:
```txt
# Disable the ACT LED on the Pi Zero.
dtparam=act_led_trigger=none
dtparam=act_led_activelow=on
```
