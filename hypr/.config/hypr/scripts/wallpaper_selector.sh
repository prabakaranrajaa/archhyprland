#!/bin/bash
#
# Wallpaper Selector Script
# Uses Rofi + ImageMagick + Matugen for dynamic theming
#

# === CONFIGURATION ===
wall_dir="${HOME}/Pictures/Wallpapers"
cache_dir="${HOME}/.cache/thumbnails/wal_selector"
rofi_config_path="${HOME}/.config/rofi/rofi-wallpaper-sel.rasi"
THUMBNAIL_SIZE=512
current_link="${wall_dir}/current_wallpaper"

# === DEPENDENCY CHECKS ===
for cmd in magick rofi; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is not installed." >&2
    exit 1
  fi
done

# === PREPARE DIRECTORIES ===
mkdir -p "${cache_dir}"

# === GENERATE THUMBNAILS ===
shopt -s nullglob
for imagen in "${wall_dir}"/*.{jpg,jpeg,png,webp,JPG,JPEG,PNG,WEBP}; do
  [ -f "$imagen" ] || continue
  filename=$(basename "$imagen")
  thumb="${cache_dir}/${filename}"
  if [ ! -f "$thumb" ] || [ "$imagen" -nt "$thumb" ]; then
    magick "$imagen" -thumbnail ${THUMBNAIL_SIZE}x${THUMBNAIL_SIZE}^ \
      -gravity center -extent ${THUMBNAIL_SIZE}x${THUMBNAIL_SIZE} "$thumb"
  fi
done
shopt -u nullglob

# === ROFI SELECTION ===
wall_selection=$(find "${wall_dir}" -type f \
  \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
  -printf "%f\n" |
  while read -r filename; do
    echo -en "${filename}\x00icon\x1f${cache_dir}/${filename}\n"
  done | rofi -dmenu -show-icons -config "${rofi_config_path}" -p "Select Wallpaper")

[[ -n "${wall_selection:-}" ]] || exit 0

selected_path="${wall_dir}/${wall_selection}"

# === APPLY MATUGEN THEME ===
if command -v matugen >/dev/null 2>&1; then
  matugen image "$selected_path"
fi

# === UPDATE CURRENT WALLPAPER LINK ===
ln -Tsf -- "$selected_path" "$current_link"

# === APPLY WALLPAPER (GNOME) ===
if command -v gsettings >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.background picture-uri "file://$selected_path"
  gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-tmp
  gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
fi

# === APPLY WALLPAPER (Hyprland via hyprpaper) ===
if command -v hyprctl >/dev/null 2>&1; then
  hyprctl hyprpaper preload "$selected_path"
  hyprctl hyprpaper wallpaper "HDMI-A-1,$selected_path"
fi

exit 0
