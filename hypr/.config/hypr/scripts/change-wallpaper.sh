#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURATION ===
WP_DIR="${HOME}/Pictures/Wallpapers"
CURRENT_LINK="${WP_DIR}/current_wallpaper"
LOG_FILE="${HOME}/.cache/wallpaper.log"

# === FUNCTIONS ===
usage() {
  echo "Usage: $0 [--next | --random]"
  exit 1
}

pick_next() {
  local current chosen idx next
  current=""
  if [ -L "$CURRENT_LINK" ] && [ -e "$CURRENT_LINK" ]; then
    current="$(readlink -f "$CURRENT_LINK" || true)"
  fi

  if [ -z "$current" ]; then
    chosen="${files[0]}"
  else
    abs_files=()
    for f in "${files[@]}"; do
      abs_files+=("$(readlink -f "$f")")
    done

    idx=-1
    for i in "${!abs_files[@]}"; do
      if [ "${abs_files[$i]}" = "$current" ]; then
        idx=$i
        break
      fi
    done

    if [ "$idx" -ge 0 ]; then
      next=$(((idx + 1) % ${#abs_files[@]}))
      chosen="${abs_files[$next]}"
    else
      chosen="${abs_files[0]}"
    fi
  fi
  echo "$chosen"
}

pick_random() {
  local rand_idx=$((RANDOM % ${#files[@]}))
  echo "${files[$rand_idx]}"
}

apply_wallpaper() {
  local chosen="$1"

  if ln -Tsf -- "$chosen" "$CURRENT_LINK"; then
    echo "Current wallpaper -> $(readlink -f "$CURRENT_LINK")"
  else
    echo "Symlink failed; copying instead."
    cp -f -- "$chosen" "$CURRENT_LINK"
  fi

  echo "$(date '+%F %T') -> $chosen" >> "$LOG_FILE"

  if command -v matugen >/dev/null 2>&1; then
    matugen image "$CURRENT_LINK"
  else
    echo "matugen not found; skipping theme generation."
  fi

  # GNOME
  if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.background picture-uri "file://$CURRENT_LINK"
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-tmp
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
  fi

  # KDE Plasma
  if command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
    plasma-apply-wallpaperimage "$CURRENT_LINK"
  fi

  # Hyprland
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl hyprpaper preload "$CURRENT_LINK"
    hyprctl hyprpaper wallpaper "DP-1,$CURRENT_LINK"
  fi
}

# === MAIN ===
if [ ! -d "$WP_DIR" ]; then
  echo "Wallpaper directory not found: $WP_DIR" >&2
  exit 1
fi

mapfile -t files < <(
  find "$WP_DIR" -maxdepth 1 -type f \
    \( -iregex '.*\.\(jpg\|jpeg\|png\|webp\|bmp\|gif\|avif\|tiff\)' \) -print0 |
    xargs -0 -r printf '%s\n' |
    sort -V
)

if [ "${#files[@]}" -eq 0 ]; then
  echo "No wallpapers found in $WP_DIR" >&2
  exit 1
fi

mode="${1:-"--next"}"
case "$mode" in
  --next)   chosen=$(pick_next) ;;
  --random) chosen=$(pick_random) ;;
  *)        usage ;;
esac

apply_wallpaper "$chosen"
exit 0
