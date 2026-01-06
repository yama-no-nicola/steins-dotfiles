#!/usr/bin/bash

#FUNCTIONS FILE

#deactivates mpvpaper and starts hyprpaper, or vice versa. If it's not possible, starts hyprpaper
wallpaper-switch(){
    killall mpvpaper && hyprpaper || killall hyprpaper && mpvpaper -s -o "no-audio --loop-playlist" ALL ~/Wallpapers/starlit.mp4 || hyprpaper
}

#Persistance mode toggle
#if persistance mode is disabled, the GPU is powered off when not in use. it saves power at the cost of waiting for the GPU to start when needed
persistance-mode(){
    #grabs the status of the mode and grabs the last word
    mode=$(nvidia-smi -q | grep "Persistence Mode" | awk '{print $NF}')
    echo "$mode"
    #either enables or disables persistence mode; returns error message if not possible    
    if [[ "$mode" = "Enabled" ]]; then
        sudo nvidia-smi -pm 0
    elif [[ "$mode" = "Disabled" ]]; then
        sudo nvidia-smi -pm 1
    else 
        echo "Something went wrong: Persistance Mode status could not be found or changed" #TODO make a proper error message
    fi
}

#CPU governor switcher

