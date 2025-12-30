#!/usr/bin/env bash
# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar with a specific configuration file
POLYBAR_CONFIG="$HOME/.config/polybar/config.ini"
polybar --config="$POLYBAR_CONFIG" main &
polybar --config="$POLYBAR_CONFIG" secondary &
