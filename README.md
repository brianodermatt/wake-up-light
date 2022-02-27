# wake-up-light
A wake-up light simulating the sunrise with RGB LEDs based on a Raspberry Pi.

## Hardware

### List of components
- [List of used hardware](theory/MAyyTERIAL.md)

### Schematics
Schematics are drawn on [KiCad](https://www.kicad.org/download/ubuntu/) which can be installed using:
```bash
sudo add-apt-repository --yes ppa:kicad/kicad-6.0-releases
sudo apt update
sudo apt install --install-recommends kicad -y
```

### Useful documents
- [Raspberry Pi R1/R2 GPIO pinout](datasheets/raspberrypi_R1_R2_gpio_pinout.png)
- [Raspberry Pi Zero 2W GPIO pinout](datasheets/RaspberryPi_zero_2_w_gpio_pinout.webp)
- [Resistor color code](datasheets/resistor_color_code.png)

### LED driver
#### Calculations
Single BJT NPN with grounded emitter, base connected to GPIO via 10k resistance, collector connected to 5V (`V_DD`) via LED and resistor `R_L`.
From `I_LED = (V_DD - V_f - V_CE,sat) / R_L` follows `R_L = (V_DD - V_f - V_CE,sat) / I_LED`.

The base resistor `R_B` is scaled to protect the GPIO port and limit the max current: `U_GPIO = R_B * I_B + V_BE`, from which follows `I_B = (U_GPIO - V_BE) / R_B < I_GPIO = 16mA`. Thus, `R_B > (U_GPIO - V_BE) / I_GPIO > U_GPIO / I_GPIO = 3.3V / 16mA = 206 Ohm`. `R_B = 220 Ohm` is selected.

#### Test setup ([schematic files](schematics/test-setup))
- LEDs: Cheap LEDs to be driven with `i = 20mA`
  - Red: `V_f = 1.8V`
  - Green, Blue: `V_f = 3.2V`
- Transistor: BJT NPN S9018 ([datasheet](datasheets/BJT_NPN_S9018.pdf))
  - `V_CE,sat = 0.1V @20mA`
- Red: `R_L > 155 Ohm`; Green, Blue: `R_L > 85 Ohm`.

#### Real setup ([schematic files](schematics/power-setup))
- LEDs: [Adafruit 3W-9W RGB LED2524](datasheets/LED_RGB_Adafruit_2524.pdf) to be driven with `[350, 700]mA`. Here: `i=500mA`.
  - Red: `V_f = 3.2V`
  - Green, Blue: `V_f = 4.1V`
- Transistor: BJT NPN S9013 ([datasheet](datasheets/BJT_NPM_S9013.pdf))
  - `V_CE,sat = 0.6V @500mA`
- Red: `R_L > 2.4 Ohm`; Green, Blue: `R_L > 0.6 Ohm`.
- Red: `2.4 Ohm`; Green, Blue: `2.4 || 2.4 || 2.4 || 2.4 = 0.6 Ohm`;

## User's guide
1. [Setup Raspberry Pi](theory/SETUP-RASPBERRY-PI.md)

## Troubleshooting
[Troubleshooting](theory/TROUBLESHOOTING.md)
