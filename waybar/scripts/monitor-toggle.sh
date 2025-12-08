#!/usr/bin/bash

#-----------------------------------------------
#Monitor toggle module for waybar
#get monitor list and state with awk
#store state file inside a json module
#use wofi to generate interactive UI
#deactivate if active and vice versa
#-----------------------------------------------

STATE_FILE="$HOME/.config/hypr/monitor_states.json"

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "{}" > "$STATE_FILE"
fi

# Get all monitors (active and inactive)
all_monitors=$(hyprctl monitors all -j | jq -r '.[] | .name')

# Create menu with status indicators
menu_items=""
while IFS= read -r monitor; do
    # Check if monitor is in active monitors list
    is_active=$(hyprctl monitors -j | jq -r "any(.name == \"$monitor\")")

    if [ "$is_active" = "true" ]; then
        menu_items+="󰍹 $monitor (enabled)\n"
    else
        menu_items+="󰹑 $monitor (disabled)\n"
    fi
done <<< "$all_monitors"

# Show menu and get selection
selected=$(echo -e "$menu_items" | wofi --dmenu --prompt "Toggle monitor")

if [ -n "$selected" ]; then
    # Extract monitor name from selection
    monitor_name=$(echo "$selected" | awk '{print $2}')

    # Check current status
    is_active=$(hyprctl monitors -j | jq -r "any(.name == \"$monitor_name\")")

    if [ "$is_active" = "false" ]; then
        # Monitor is disabled, enable it
        saved_config=$(jq -r ".[\"$monitor_name\"] // \"preferred,auto,1\"" "$STATE_FILE")
        hyprctl keyword monitor "$monitor_name,$saved_config"
    else
        # Monitor is enabled, save config and disable it
        config=$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$monitor_name\") | \"preferred,auto,\(.scale)\"")
        jq --arg name "$monitor_name" --arg config "$config" '.[$name] = $config' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
        hyprctl keyword monitor "$monitor_name,disable"
    fi
fi
