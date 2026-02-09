# ~/.config/qtile/widgets/power.py
from libqtile import widget, qtile

power_icon = widget.TextBox(
    text="⏻",
    fontsize=18,
    padding=10,
    foreground="#ff5555",
)

power_icon.add_callbacks(
    {
        "Button1": lambda: qtile.cmd_spawn(
            "sh -c \"chosen=$(echo -e 'Logout\nSleep\nReboot\nShutdown' | rofi -dmenu -p 'Power'); "
            "case $chosen in "
            "Logout) pkill -KILL -u $USER ;; "
            "Sleep) systemctl suspend ;; "
            "Reboot) systemctl reboot ;; "
            "Shutdown) systemctl poweroff ;; "
            'esac"'
        )
    }
)
