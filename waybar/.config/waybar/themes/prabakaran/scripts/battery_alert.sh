#!/bin/bash

BAT_PATH="/sys/class/power_supply/BAT0"
capacity=$(cat "$BAT_PATH/capacity" | xargs)
status=$(cat "$BAT_PATH/status" | xargs)

# Alert when battery is 15% or lower and discharging
if [ "$capacity" -le 15 ] && [ "$status" = "Discharging" ]; then
    notify-send -u critical "Battery Low" "Battery at ${capacity}%"
    pw-play /usr/share/sounds/freedesktop/stereo/suspend-error.oga &
    #ICON=""   # low battery icon
#else
    #ICON="🔋"   # normal battery icon
fi

# Always output something for Waybar
#echo "${ICON} ${capacity}%"
echo "${capacity}%"
