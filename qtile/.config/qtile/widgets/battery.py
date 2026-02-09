from libqtile import widget

battery = widget.Battery(
    format="{char}{percent:2.0%} ",
    charge_char="🔌",
    discharge_char="🔋",
    empty_char="⚡",
    full_char="✅",
    update_interval=30,
    low_percentage=20,
    notify_below=20,
    show_short_text=False,
    foreground="#ffffff",
    low_foreground="#ff5555",
    full_foreground="#50fa7b",
    notification_timeout=5,
    notification_script="paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga",
)
