#!/bin/bash

# Read battery percentage from sysfs
PERCENT=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Choose icon based on status
if [ "$STATUS" = "Charging" ]; then
    ICON="🔌"
elif [ "$STATUS" = "Discharging" ]; then
    ICON="🔋"
elif [ "$STATUS" = "Full" ]; then
    ICON="✅"
else
    ICON="⚡"
fi

# Path to flag file
FLAG="/tmp/battery_low_alerted"

# Low battery alert (only once until recovered)
if [ "$PERCENT" -lt 15 ]; then
    if [ ! -f "$FLAG" ]; then
        paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga &
        touch "$FLAG"
    fi
else
    # Reset flag when battery recovers
    [ -f "$FLAG" ] && rm "$FLAG"
fi

# Output for bar (icon + percentage)
echo "${ICON}${PERCENT}%"

