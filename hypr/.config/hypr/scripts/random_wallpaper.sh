#!/bin/bash
set -euo pipefail

# Folder containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Ensure directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Wallpaper directory not found: $WALLPAPER_DIR" >&2
  exit 1
fi

# Ensure swww is running
if ! pgrep -x swww-daemon >/dev/null; then
  swww init
fi

# Pick a random wallpaper (only images)
RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

# Randomize transition type (optional)
TRANSITIONS=("outer" "wipe" "grow" "center" "fade")
RANDOM_TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}

# Apply wallpaper with transition
swww img "$RANDOM_WALL" \
  --transition-fps 255 \
  --transition-type "$RANDOM_TRANSITION" \
  --transition-duration 0.8
