# wake-up-light
A wake-up light simulating the sunrise with RGB LEDs based on a Raspberry Pi.

## Hardware

### List of components
- [List of used hardware](theory/MATERIAL.md)

### Schematics
Schematics are drawn on [KiCad](https://www.kicad.org/download/ubuntu/) which can be installed using:
```bash
sudo add-apt-repository --yes ppa:kicad/kicad-6.0-releases
sudo apt update
sudo apt install --install-recommends kicad -y
```

### LED driver
#### Calculations
Single BJT NPN with grounded emitter, base connected to GPIO via 10k resistance, collector connected to 5V (`V_DD`) via LED and resistor `R_L`.
From `I_LED = (V_DD - V_f - V_CE,sat) / R_L` follows `R_L = (V_DD - V_f - V_CE,sat) / I_LED`

#### Test setup ([schematic files](schematics/test-setup))
- LEDs: Cheap LEDs to be driven with `i = 20mA`
  - Red: `V_f = 1.8V`
  - Green, Blue: `V_f = 3.2V`
- Transistor: BJT NPN S9018 ([datasheet](datasheets/BJT_NPN_S9018.pdf))
  - `V_CE,sat = 0.1V @20mA`
- Red: `R_L > 155 Ohm`; Green, Blue: `R_L > 85 Ohm`.

## User's guide
1. [Setup Raspberry Pi](theory/SETUP-RASPBERRY-PI.md)

## Troubleshooting
[Troubleshooting](theory/TROUBLESHOOTING.md)
