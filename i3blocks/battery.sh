#!/bin/bash

# Get battery status and percentage
BATTERY_PATH=$(upower -e | grep -m1 battery)
BATTERY_PERCENTAGE=$(upower -i $BATTERY_PATH | awk '/percentage/ {print $2}' | tr -d '%')
BATTERY_STATE=$(upower -i $BATTERY_PATH | awk '/state/ {print $2}')

# Threshold for warning (20%)
WARNING_LEVEL=20

# Check if battery is discharging and below threshold
if [ "$BATTERY_STATE" = "discharging" ] && [ "$BATTERY_PERCENTAGE" -le $WARNING_LEVEL ]; then
  notify-send -u critical "🔋 Low Battery!" "Battery at $BATTERY_PERCENTAGE% - Connect charger!"
fi

# Return the battery percentage for i3blocks display
echo "$BATTERY_PERCENTAGE%"
