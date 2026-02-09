#!/bin/bash

MPCHOST="localhost"
MPCPORT="6601"

last_state=""
notify_song() {
    status=$(mpc -h $MPCHOST -p $MPCPORT status)
    song=$(mpc -h $MPCHOST -p $MPCPORT current)

    if echo "$status" | grep -q "

\[playing\]

"; then
        state="playing"
    elif echo "$status" | grep -q "

\[paused\]

"; then
        state="paused"
    else
        state="stopped"
    fi

    if [ "$state" != "$last_state" ]; then
        case $state in
            playing) dunstify -a "MPD" -r 1234 "▶️ Now Playing" "$song" -i media-playback-start ;;
            paused)  dunstify -a "MPD" -r 1234 "⏸️ Paused" "$song" -i media-playback-pause ;;
            stopped) dunstify -a "MPD" -r 1234 "⏹️ Stopped" "No track playing" -i media-playback-stop ;;
        esac
        last_state="$state"
    fi
}


