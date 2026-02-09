# #!/bin/bash
# # ~/.config/hypr/scripts/open-apps.sh
# # Script to open multiple applications in specific workspaces

# is_running() {
#     pgrep -f "$1" > /dev/null
# }

# move_window_to_workspace() {
#     local app_class="$1"
#     local workspace="$2"
#     local max_attempts=10
#     local attempt=0
    
#     while [ $attempt -lt $max_attempts ]; do
#         if hyprctl clients | grep -q "class: $app_class"; then
#             hyprctl dispatch movetoworkspacesilent "$workspace,class:$app_class"
#             break
#         fi
#         sleep 0.5
#         ((attempt++))
#     done
# }

# echo "Opening applications in workspaces..."

# # Kitty → workspace 1
# if ! is_running "kitty"; then
#     echo "starting kitty..."
#     kitty &
#     move_window_to_workspace "kitty" 1 &
# else
#     echo "kitty already running, moving to workspace 1..."
#     hyprctl dispatch movetoworkspacesilent "1,class:kitty"
# fi
# sleep 0.3

# # Brave → workspace 2
# if ! is_running "brave"; then
#     echo "starting brave..."
#     brave &
#     move_window_to_workspace "brave-browser" 2 &
# else
#     echo "brave already running, moving to workspace 2..."
#     hyprctl dispatch movetoworkspacesilent "2,class:brave-browser"
# fi
# sleep 0.3

# # Thunar → workspace 3
# if ! is_running "thunar"; then
#     echo "starting thunar..."
#     thunar &
#     move_window_to_workspace "thunar" 3 &
# else
#     echo "thunar already running, moving to workspace 3..."
#     hyprctl dispatch movetoworkspacesilent "3,class:thunar"
# fi
# sleep 0.3

# # VS Code OSS → workspace 4
# if ! is_running "code"; then
#     echo "starting vs code..."
#     code &
#     move_window_to_workspace "code-oss" 4 &
# else
#     echo "vs code already running, moving to workspace 4..."
#     hyprctl dispatch movetoworkspacesilent "4,class:code-oss"
# fi
# sleep 0.3

# echo "applications launched and moved to workspaces!"
# echo "- kitty: workspace 1"
# echo "- brave: workspace 2"
# echo "- thunar: workspace 3"
# echo "- vs code: workspace 4"

#!/bin/bash
# ~/.config/hypr/scripts/open-apps.sh
# Script to open multiple applications in specific workspaces

is_running() {
    pgrep -f "$1" > /dev/null
}

move_window_to_workspace() {
    local app_class="$1"
    local workspace="$2"
    local max_attempts=10
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if hyprctl clients | grep -q "class: $app_class"; then
            hyprctl dispatch movetoworkspacesilent "$workspace,class:$app_class"
            break
        fi
        sleep 0.5
        ((attempt++))
    done
}

notify() {
    notify-send "Hyprland Apps" "$1"
}

notify "Opening applications in workspaces..."

# Kitty → workspace 1
if ! is_running "kitty"; then
    notify "Starting Kitty..."
    kitty &
    move_window_to_workspace "kitty" 1 &
else
    notify "Kitty already running, moving to workspace 1..."
    hyprctl dispatch movetoworkspacesilent "1,class:kitty"
fi
sleep 0.3

# # Brave → workspace 2
# if ! is_running "brave"; then
#     notify "Starting Brave..."
#     brave &
#     move_window_to_workspace "brave-browser" 2 &
# else
#     notify "Brave already running, moving to workspace 2..."
#     hyprctl dispatch movetoworkspacesilent "2,class:brave-browser"
# fi
# sleep 0.3
# Brave → workspace 2
if ! is_running "zen"; then
    notify "Starting Brave..."
    zen &
    move_window_to_workspace "zen" 2 &
else
    notify "Brave already running, moving to workspace 2..."
    hyprctl dispatch movetoworkspacesilent "2,class:zen"
fi
sleep 0.3

# Thunar → workspace 3
if ! is_running "thunar"; then
    notify "Starting Thunar..."
    thunar &
    move_window_to_workspace "thunar" 3 &
else
    notify "Thunar already running, moving to workspace 3..."
    hyprctl dispatch movetoworkspacesilent "3,class:thunar"
fi
sleep 0.3

# VS Code OSS → workspace 4
if ! is_running "code"; then
    notify "Starting VS Code..."
    code &
    move_window_to_workspace "code" 4 &
else
    notify "VS Code already running, moving to workspace 4..."
    hyprctl dispatch movetoworkspacesilent "4,class:code"
fi
sleep 0.3

notify "Applications launched and moved to workspaces!
- kitty: workspace 1
- brave: workspace 2
- thunar: workspace 3
- vs code: workspace 4"
