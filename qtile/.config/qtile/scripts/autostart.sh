#!/bin/bash
dunst &
#xrandr --output eDP-1 --same-as HDMI-1 &
#xrandr --output HDMI-1 --primary &
#xrandr --output HDMI-1 --same-as eDP-1 &
xrandr --output eDP-1 --off --output HDMI-1 --primary --auto
xinput set-button-map 15 3 2 1 &
xinput set-button-map 12 3 2 1 &
picom --config ~/.config/picom/picom.conf &
#feh --bg-scale ~/Pictures/Wallpapers/kill.jpeg &

