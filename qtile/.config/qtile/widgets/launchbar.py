# ~/.config/qtile/widgets/launchbar.py

from libqtile import widget

# Define your LaunchBar widget
launchbar = widget.LaunchBar(
    progs=[
        ("🦁", "brave", "Brave web browser"),
        ("🚀", "kitty", "Kitty terminal"),
        ("📁", "pcmanfm", "PCManFM file manager"),
        ("🎸", "vlc", "VLC media player"),
    ],
    fontsize=20,
    padding=2,
    foreground="#ffffff",  # or use colors[3] if you import your color scheme
)
