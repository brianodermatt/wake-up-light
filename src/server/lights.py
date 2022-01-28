#!/usr/bin/env python3

# Imports
import time
import sys
import pigpio
import numpy as np
from scipy import interpolate

# Constants
RANGE = 255 # pigpio has 255 steps of brightness: pi.set_PWM_dutycycle(pin, 255) corresponds to full brightness
STEPS = 100 # The number of steps to make during sunrise
PINS = {  # The GPIO number of the pin for each color
  "red": 23,
  "green": 24,
  "blue": 25
}
START = { # Starting point of each color in [0, 1]
  "red": 0,
  "green": 1/3,
  "blue": 2/3,
}
END = { # Ending point of each color in [0, 1]
  "red": 1,
  "green": 1,
  "blue": 1,
}
# The growing function for the light [0,1] |-> [0,1]
GROWTH_FUNC = interpolate.interp1d(
  [0.0, 0.2, 0.4, 0.6, 0.8, 1.0], # x of the interpolation
  [0.0, 0.1, 0.3, 0.6, 0.8, 1.0], # y of the interpolation
  fill_value="extrapolate"
)


# Initialization
pi = pigpio.pi()
for pin in PINS.values():
  pi.set_PWM_frequency(pin, 400)


# Sunrise: Duration is specified in minutes
def sunrise(duration_min):
  interval_length_s = 60 * duration_min / STEPS

  for step in range(STEPS + 1):
    progress = step / STEPS ## progress in [0, 1]

    print(f'{progress*100:3.0f}%: ', end='')
    for color in ["red", "green", "blue"]:
      color_progress = bound(0, 1, scaleFctToInt(START[color], END[color], GROWTH_FUNC, progress))
      cmd = RANGE * color_progress
      pi.set_PWM_dutycycle(PINS[color], cmd)
      print(f'{color[0].capitalize()}:{color_progress * 100:3.0f}% ({cmd:3.0f}) ', end='')
    print('')

    # Sleep to reach the overall duration
    time.sleep(interval_length_s)

  # Remain at full light for 15 min
  # time.sleep(15 * 60) # TODO: Uncomment

# Bound the value between low and high
def bound(low, high, value):
  return max(low, min(high, value))


# Scale function to interval
def scaleFctToInt(start, end, func, value):
  return 1 * (func((value - start)  / (end - start)))


# Cleanup (reset all channels)
def cleanup():
  for pin in PINS.values():
    pi.set_PWM_dutycycle(pin, 0)
  pi.stop()

# Call desired function if called via terminal
if __name__ == "__main__":
  func = sys.argv[1]
  duration = float(sys.argv[2])
  try:
    if func == "sunrise":
      sunrise(duration)
  except KeyboardInterrupt:
    pass
  finally:
    cleanup()
