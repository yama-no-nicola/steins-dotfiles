#!/usr/bin/bash

#extra options menu

show_menu(){
        echo "Extra Options"
}

show_actions(){
        echo "Music"
}

confirm_action(){
        local message=$1
}

execute_action(){
        case $1 in
            "Music")
                /home/$USER/.config/waybar/scripts/music.sh
                ;;
        esac
}

run_menu(){
        selected=$(show_actions | wofi --dmenu --prompt "Extra Options" --width 250 --height 220)
        if [ -n "$selected" ]; then
            execute_action "$selected"
        fi
}

if [ "$1" = "action" ]; then
        execute_action "$2"
elif [ "$1" = "menu" ]; then
    show_menu
else
    pkill wofi || run_menu
fi
        
