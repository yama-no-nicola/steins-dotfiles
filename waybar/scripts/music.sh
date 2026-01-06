#!/usr/bin/bash

#switch to workspace 10 and open rhythmbox, if already open, kill rythmbox

process_status=0

process_status=$(pgrep rhythmbox)

if [[ $process_status -gt 0 ]]; then
    hyprctl dispatch workspace 10
else
    hyprctl dispatch workspace 10
    sleep 0.1
    rhythmbox
fi
