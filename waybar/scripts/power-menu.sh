#!/bin/bash

show_menu() {
    echo "⏻ Power"
}

show_actions() {
    echo "🔒 Lock"
    echo "🚪 Logout"
    echo "🔄 Restart"
    echo "⏻ Shutdown"
}

confirm_action() {
    local message=$1
    
    # Using wofi for confirmation
    result=$(echo -e "Yes\nNo" | wofi --dmenu --prompt "$message" --width 300 --height 150)
    echo "$result"
}

execute_action() {
    case $1 in
        "🔒 Lock")
            result=$(confirm_action "Lock the screen?")
            if [ "$result" = "Yes" ]; then
                sleep 0.2
                hyprlock
            fi
            ;;
        "🚪 Logout")
            result=$(confirm_action "Logout from the session?")
            if [ "$result" = "Yes" ]; then
                hyprctl dispatch exit
                # For i3, use: i3-msg exit
                # For Hyprland, use: hyprctl dispatch exit
            fi
            ;;
        "🔄 Restart")
            result=$(confirm_action "Restart the system?")
            if [ "$result" = "Yes" ]; then
                systemctl reboot
            fi
            ;;
        "⏻ Shutdown")
            result=$(confirm_action "Shutdown the system?")
            if [ "$result" = "Yes" ]; then
                systemctl poweroff
            fi
            ;;
    esac
}

run_menu() {
    selected=$(show_actions | wofi --dmenu --prompt "Power Options" --width 250 --height 220)
    
    if [ -n "$selected" ]; then
        execute_action "$selected"
    fi
}

# Main logic
if [ "$1" = "action" ]; then
    execute_action "$2"
elif [ "$1" = "menu" ]; then
    show_menu
else
    # Simple toggle: kill wofi if running, otherwise show menu
    pkill wofi || run_menu
fi
