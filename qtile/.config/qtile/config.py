import os

import subprocess
import libqtile.resources
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import colors
import random
from widgets.rmpc import play_icon, skip_icon
from widgets.battery import battery
from widgets.net import net
from widgets.launchbar import launchbar
from widgets.power import power_icon


# import your helper function
from mymodules.netusage import get_total_usage

# assuming you save it in ~/.config/qtile/mymodules/netusage.py

# Path to your wallpapers folder
wallpaper_dir = os.path.expanduser("~/Pictures/Wallpapers")

# Pick a random file from the folder
wallpaper = random.choice(os.listdir(wallpaper_dir))
wallpaper_path = os.path.join(wallpaper_dir, wallpaper)

# Your list of options
any_list = [
    "DoomOne",
    "Dracula",
    "GruvboxDark",
    "MonokaiPro",
    "Nord",
    "OceanicNext",
    "Palenight",
    "SolarizedDark",
    "SolarizedLight",
    "TomorrowNight",
    "TokyoNight",
]

# Pick one randomly
chosen = random.choice(any_list)

colors = getattr(colors, chosen)
# colors = colors.Dracula

net_usage_widget = widget.GenPollText(
    func=lambda: get_total_usage("wlan0"),
    update_interval=60,
    foreground=colors[8],
)

mod = "mod4"
# terminal = guess_terminal()
mod = "mod4"  # Sets mod key to SUPER/WINDOWS
myTerm = "kitty"  # My terminal of choice
myBrowser = "qutebrowser"  # My browser of choice
myFile = "thunar"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.spawn("rofi -show drun -show-icons"), desc="Run Launcher"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(myTerm), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.spawn(myBrowser), desc="Web browser"),
    Key([mod], "e", lazy.spawn(myFile), desc="Web browser"),
    Key(
        [mod],
        "b",
        lazy.hide_show_bar(position="all"),
        desc="Toggles the bar to show/hide",
    ),
    # Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod, "control", "shift"],
        "q",
        lazy.spawn("qtile cmd-obj -o cmd -f shutdown"),
        desc="Logout menu",
    ),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control", "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [mod, "control", "mod1"],
        "up",
        lazy.spawn("xrandr -o 0"),
        desc="Window drection up",
    ),
    Key(
        [mod, "control", "mod1"],
        "left",
        lazy.spawn("xrandr -o 1"),
        desc="Window drection left",
    ),
    Key(
        [mod, "control", "mod1"],
        "down",
        lazy.spawn("xrandr -o 2"),
        desc="Window drection down",
    ),
    Key(
        [mod, "control", "mod1"],
        "right",
        lazy.spawn("xrandr -o 3"),
        desc="Window drection right",
    ),
    KeyChord(
        [mod],
        "o",
        [
            Key([], "b", lazy.spawn("brave")),
            Key([], "f", lazy.spawn("thunar")),
        ],
        name="launch",
    ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

# Uncomment only one of the following lines
group_labels = ["", "", "👁", "", "", "", "✀", "꩜", "", "⎙"]
# group_labels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
# group_labels = ["DEV", "WWW", "SYS", "DOC", "VBOX", "CHAT", "MUS", "VID", "GFX", "MISC"]

group_layouts = ["monadtall"] * 10

group_matches = [
    # [Match(wm_class=["kitty"])],
    [],  # Group 1
    [],  # Group 2
    [],  # Group 3
    [],  # Group 4
    [],  # Group 5
    [],  # Group 6
    [],  # Group 7
    [],  # Group 8
    [],  # Group 9
    [],  # Group 0
]

groups = [
    Group(name=n, label=l, layout=lay, matches=m)
    for n, l, lay, m in zip(group_names, group_labels, group_layouts, group_matches)
]

keys.extend(
    [
        Key(
            [mod],
            g.name,
            lazy.group[g.name].toscreen(),
            desc=f"Switch to group {g.name}",
        )
        for g in groups
    ]
    + [
        Key(
            [mod, "shift"],
            g.name,
            lazy.window.togroup(g.name),
            desc=f"Move window to group {g.name}",
        )
        for g in groups
    ]
)

layout_theme = {
    "border_width": 3,
    "margin": 3,
    "border_focus": "ff00ff",
    "border_normal": colors[0],
}

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    layout.Stack(num_stacks=2),
    layout.Bsp(**{"border_width": 2, "margin": 3}),
    layout.Matrix(**{"border_width": 2, "margin": 3}),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**{"border_width": 2, "margin": 3}),
    layout.RatioTile(**{"border_width": 2, "margin": 3}),
    layout.Tile(**{"border_width": 2, "margin": 3}),
    layout.TreeTab(**{"border_width": 2, "margin": 3}),
    layout.VerticalTile(**{"border_width": 2, "margin": 3}),
    layout.Zoomy(**{"border_width": 2, "margin": 3}),
]

# Define default groups for first instance
default_groups = {
    "kitty": "1",  # terminal → group 1
    "qutebrowser": "2",  # browser → group 2
    "brave": "2",  # browser → group 2
    "pcmanfm": "4",  # file manager → group 4
    "thunar": "4",  # file manager → group 4
}


@hook.subscribe.client_new
def move_first_instance(client):
    wm_class = client.window.get_wm_class()
    if not wm_class:
        return

    for cls in wm_class:
        if cls in default_groups:
            target_group = default_groups[cls]
            group = client.qtile.groups_map[target_group]

            # If this group already has one of this class → leave new window where it spawns
            if any(
                w.window.get_wm_class() and cls in w.window.get_wm_class()
                for w in group.windows
            ):
                return

            # Otherwise → move the first instance to its default group
            client.togroup(target_group)
            return


widget_defaults = dict(
    font="JetBrains Mono NF",
    fontsize=16,
    padding=3,
)
extension_defaults = widget_defaults.copy()

# logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(
                    filename=os.path.expanduser("~/.config/qtile/icons/p.png"),
                    scale="False",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            "rofi -show drun -show-icons"
                        )
                    },
                ),
                widget.Prompt(),
                widget.GroupBox(
                    fontsize=16,
                    # padding_x = 6,
                    padding_y=6,
                    active=colors[4],
                    # inactive = colors[9],
                    rounded=True,
                    highlight_color=colors[3],
                    highlight_method="line",
                ),
                widget.TextBox(
                    text="|",
                    font="JetBrains Mono NF",
                    foreground=colors[9],
                    padding=2,
                    fontsize=20,
                ),
                launchbar,
                widget.CurrentLayout(mode="icon"),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # widget.TextBox("default config", name="default"),
                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),
                net,
                net_usage_widget,
                widget.CPU(
                    foreground=colors[4],
                    # padding = 8,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(myTerm + " -e htop")
                    },
                    format="{load_percent}%",
                ),
                widget.Memory(
                    foreground=colors[8],
                    # padding = 8,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(myTerm + " -e htop")
                    },
                    format="{MemUsed:.0f}{mm}",
                    fmt="🖥{}",
                ),
                widget.DF(
                    update_interval=60,
                    foreground=colors[5],
                    # padding = 8,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            "/home/karan/.config/qtile/scripts/notify-disk"
                        )
                    },
                    partition="/",
                    # format = '[{p}] {uf}{m} ({r:.0f}%)',
                    format="{uf}{m}",
                    fmt="🖴{}",
                    visible_on_warn=False,
                ),
                play_icon,
                skip_icon,
                widget.Volume(
                    foreground=colors[7],
                    # padding = 8,
                    fmt="🕫{}",
                ),
                # battery,   # <--- use the variable here
                widget.GenPollText(
                    func=lambda: subprocess.getoutput(
                        "~/.config/qtile/scripts/battery_alert.sh"
                    ),
                    update_interval=30,
                    foreground="#ffffff",
                ),
                # widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.Clock(foreground=colors[8], format="%I:%M"),
                # widget.QuickExit(),
                power_icon,  # add it here
            ],
            26,
            # border_width=[1, 0, 1, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        background="#000000",
        wallpaper=wallpaper_path,
        wallpaper_mode="fill",  # center",
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/scripts/autostart.sh"])
    # subprocess.Popen([home + '/.config/qtile/scripts/mpd-notify.sh'], shell=True)

    subprocess.Popen(["nm-applet"])
    subprocess.Popen(["copyq"])


# 	subprocess.Popen(["xrandr", "--output", "eDP-1", "--same-as", "HDMI-1"])
# 	subprocess.Popen(["xinput", "set-button-map", "15", "3", "2", "1"])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
