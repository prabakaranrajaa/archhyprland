# ~/.config/qtile/widgets/net.py

from libqtile import widget

# Define your Net widget
net = widget.Net(
    foreground="#ffffff",  # or use colors[3] if you import your color scheme
    format="{down:.0f}{down_suffix}↓ ↑{up:.0f}{up_suffix}",
    interface="wlan0",  # Change to your actual network interface (check with `ip link`)
    update_interval=1,  # Update every second
    use_bits=False,  # Show speeds in bytes/sec (KB/s, MB/s)
    prefix=None,  # Automatic SI units
    cumulative_prefix=None,  # Automatic SI units for cumulative totals
)
