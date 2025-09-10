#!/bin/bash

# Get battery status and percentage
BATTERY_PATH=$(upower -e | grep -m1 battery)
BATTERY_PERCENTAGE=$(upower -i $BATTERY_PATH | awk '/percentage/ {print $2}' | tr -d '%')
BATTERY_STATE=$(cat /sys/class/power_supply/BAT1/status)

# Threshold for warning (20%)
WARNING_LEVEL=20

# Check if battery is discharging and below threshold
if [ "$BATTERY_STATE" = "Discharging" ] && [ "$BATTERY_PERCENTAGE" -le $WARNING_LEVEL ]; then
  notify-send -u critical "🔋 Low Battery!" "Battery at $BATTERY_PERCENTAGE% - Connect charger!"
fi

# Return the battery percentage for i3blocks display
if [ "$BATTERY_PERCENTAGE" -le $WARNING_LEVEL ]; then
  echo "<span color='#FF0000'>$BATTERY_PERCENTAGE%</span>"
elif [ "$BATTERY_STATE" = "Charging" ] ; then
  echo "<span color='#006800'>$BATTERY_PERCENTAGE%</span>"
else 
  echo "$BATTERY_PERCENTAGE%"
fi
