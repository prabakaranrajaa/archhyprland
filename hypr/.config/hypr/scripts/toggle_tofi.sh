#!/usr/bin/env bash
if pgrep -x tofi-drun >/dev/null; then
    pkill -x tofi-drun
else
    tofi-drun -c $HOME/.config/tofi/config --drun-launch=true &
fi

