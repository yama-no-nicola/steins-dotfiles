#!/bin/bash

# Check if wofi is running
if pgrep -x wofi > /dev/null; then
    pkill wofi
else
    # Get the active window title
    window=$(hyprctl activewindow -j | jq -r '.title')
    
    # Only launch wofi if no windows are open
    if [ -z "$window" ] || [ "$window" = "null" ]; then
        wofi --show drun
    else
        mpv /home/gustave/shitassAudio/nando_demo.mp3

    fi
fi
