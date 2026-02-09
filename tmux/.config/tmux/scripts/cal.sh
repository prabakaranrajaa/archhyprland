#!/bin/bash

ALERT_IF_IN_NEXT_MINUTES=10
ALERT_POPUP_BEFORE_SECONDS=10
NERD_FONT_FREE="󱁕 "
NERD_FONT_MEETING="󰤙"

get_next_meeting() {
    # Get the next meeting today that hasn't started yet
    next_meeting=$(khal list today --notstarted | head -n 1)
}

parse_result() {
    # Extract start time, end time, and title
    time=$(echo "$next_meeting" | awk '{print $1}')
    end_time=$(echo "$next_meeting" | awk '{print $2}')
    title=$(echo "$next_meeting" | cut -d' ' -f3-)
}

calculate_times() {
    epoc_meeting=$(date -d "$time" +%s)
    epoc_now=$(date +%s)
    epoc_diff=$((epoc_meeting - epoc_now))
    minutes_till_meeting=$((epoc_diff / 60))
}

display_popup() {
    tmux display-popup \
        -S "fg=#eba0ac" \
        -w50% \
        -h50% \
        -d '#{pane_current_path}' \
        -T meeting \
        "echo \"$next_meeting\""
}

print_tmux_status() {
    if [[ $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES && $minutes_till_meeting -gt -60 ]]; then
        echo "$NERD_FONT_MEETING $time $title ($minutes_till_meeting minutes)"
    else
        echo "$NERD_FONT_FREE"
    fi

    if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS && $epoc_diff -lt $((ALERT_POPUP_BEFORE_SECONDS + 10)) ]]; then
        display_popup
    fi
}

main() {
    get_next_meeting
    parse_result
    calculate_times
    print_tmux_status
}

main
