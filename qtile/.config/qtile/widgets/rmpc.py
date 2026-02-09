import subprocess
import threading
from libqtile import widget

# --- Play / Pause / Stop icon ---
play_icon = widget.TextBox(
    fontsize=18,
    foreground="#00ff00",
    text="▶️",  # start with Play
)


def rmpc_notify_with_icon(cmd, icon_widget):
    try:
        # Run the command
        subprocess.run(["mpc", "-h", "localhost", "-p", "6601", cmd], check=True)

        # Get status and song
        status = subprocess.run(
            ["mpc", "-h", "localhost", "-p", "6601", "status"],
            capture_output=True,
            text=True,
            check=True,
        ).stdout
        song = subprocess.run(
            ["mpc", "-h", "localhost", "-p", "6601", "current"],
            capture_output=True,
            text=True,
            check=True,
        ).stdout.strip()

        # Update icon based on state
        if "[playing]" in status:
            icon_widget.update("▶️")  # Play icon
            subprocess.run(
                [
                    "dunstify",
                    "-a",
                    "MPD",
                    "-r",
                    "1234",
                    "▶️ Now Playing",
                    song,
                    "-i",
                    "media-playback-start",
                ]
            )
        elif "[paused]" in status:
            icon_widget.update("⏸️")  # Pause icon
            subprocess.run(
                [
                    "dunstify",
                    "-a",
                    "MPD",
                    "-r",
                    "1234",
                    "⏸️ Paused",
                    song,
                    "-i",
                    "media-playback-pause",
                ]
            )
        else:
            icon_widget.update("⏹️")  # Stop icon
            subprocess.run(
                [
                    "dunstify",
                    "-a",
                    "MPD",
                    "-r",
                    "1234",
                    "⏹️ Stopped",
                    "No track playing",
                    "-i",
                    "media-playback-stop",
                ]
            )
    except subprocess.CalledProcessError:
        icon_widget.update("⚠️")
        subprocess.run(
            ["dunstify", "-a", "MPD", "-r", "1234", "⚠️ Error", "MPD command failed"]
        )


import threading


def rmpc_volume(change, icon_widget):
    try:
        # Change volume
        subprocess.run(
            ["mpc", "-h", "localhost", "-p", "6601", "volume", change], check=True
        )

        # Get current volume
        status = subprocess.run(
            ["mpc", "-h", "localhost", "-p", "6601", "volume"],
            capture_output=True,
            text=True,
            check=True,
        ).stdout.strip()

        # Update icon temporarily
        if change.startswith("+"):
            icon_widget.update("🔊")
            subprocess.run(
                [
                    "dunstify",
                    "-a",
                    "MPD",
                    "-r",
                    "1234",
                    f"🔊 Volume Up",
                    status,
                    "-i",
                    "audio-volume-high",
                ]
            )
        else:
            icon_widget.update("🔉")
            subprocess.run(
                [
                    "dunstify",
                    "-a",
                    "MPD",
                    "-r",
                    "1234",
                    f"🔉 Volume Down",
                    status,
                    "-i",
                    "audio-volume-low",
                ]
            )

        # After 3 seconds, revert back to play/pause/stop icon
        def revert_icon():
            rmpc_notify_with_icon("status", icon_widget)

        threading.Timer(3, revert_icon).start()

    except subprocess.CalledProcessError:
        icon_widget.update("⚠️")
        subprocess.run(
            ["dunstify", "-a", "MPD", "-r", "1234", "⚠️ Error", "Volume command failed"]
        )


play_icon.add_callbacks(
    {
        "Button1": lambda: rmpc_notify_with_icon(
            "play", play_icon
        ),  # Left click → Play
        "Button2": lambda: rmpc_notify_with_icon(
            "stop", play_icon
        ),  # Middle click → Stop
        "Button3": lambda: rmpc_notify_with_icon(
            "pause", play_icon
        ),  # Right click → Pause
        "Button4": lambda: rmpc_volume(
            "+5", play_icon
        ),  # Scroll up → Volume up + notify
        "Button5": lambda: rmpc_volume(
            "-5", play_icon
        ),  # Scroll down → Volume down + notify
    }
)


# --- Skip icon: Previous / Next ---
skip_icon = widget.TextBox(
    fontsize=18,
    foreground="#ff00ff",
    text="⏭️",  # default icon
)


def rmpc_skip(cmd, icon_widget):
    try:
        subprocess.run(["mpc", "-h", "localhost", "-p", "6601", cmd], check=True)

        song = subprocess.run(
            ["mpc", "-h", "localhost", "-p", "6601", "current"],
            capture_output=True,
            text=True,
            check=True,
        ).stdout.strip()

        if cmd == "next":
            icon_widget.update("⏭️")  # Next icon
            subprocess.run(
                [
                    "dunstify",
                    "-a",
                    "MPD",
                    "-r",
                    "1234",
                    "⏭️ Next Song",
                    song,
                    "-i",
                    "media-skip-forward",
                ]
            )
        elif cmd == "prev":
            icon_widget.update("⏮️")  # Previous icon
            subprocess.run(
                [
                    "dunstify",
                    "-a",
                    "MPD",
                    "-r",
                    "1234",
                    "⏮️ Previous Song",
                    song,
                    "-i",
                    "media-skip-backward",
                ]
            )
    except subprocess.CalledProcessError:
        icon_widget.update("⚠️")
        subprocess.run(
            ["dunstify", "-a", "MPD", "-r", "1234", "⚠️ Error", "Skip command failed"]
        )


def rmpc_seek(offset, icon_widget):
    try:
        subprocess.run(
            ["mpc", "-h", "localhost", "-p", "6601", "seek", offset], check=True
        )
        song = subprocess.run(
            ["mpc", "-h", "localhost", "-p", "6601", "current"],
            capture_output=True,
            text=True,
            check=True,
        ).stdout.strip()

        if offset.startswith("+"):
            icon_widget.update("⏩")
            subprocess.run(
                [
                    "dunstify",
                    "-a",
                    "MPD",
                    "-r",
                    "1234",
                    f"⏩ Forward {offset}",
                    song,
                    "-i",
                    "media-seek-forward",
                ]
            )
        else:
            icon_widget.update("⏪")
            subprocess.run(
                [
                    "dunstify",
                    "-a",
                    "MPD",
                    "-r",
                    "1234",
                    f"⏪ Backward {offset}",
                    song,
                    "-i",
                    "media-seek-backward",
                ]
            )
    except subprocess.CalledProcessError:
        icon_widget.update("⚠️")
        subprocess.run(
            ["dunstify", "-a", "MPD", "-r", "1234", "⚠️ Error", "Seek command failed"]
        )


# Attach callbacks with scroll for seek
skip_icon.add_callbacks(
    {
        "Button1": lambda: rmpc_skip("next", skip_icon),  # Left click → Next
        "Button3": lambda: rmpc_skip("prev", skip_icon),  # Right click → Previous
        "Button4": lambda: rmpc_seek("+5", skip_icon),  # Scroll up → Forward 5s
        "Button5": lambda: rmpc_seek("-5", skip_icon),  # Scroll down → Backward 5s
    }
)
