#!/bin/bash

# Universal battery notification script for Arch Linux
# Notifies on: low battery, critical battery, plugged in, unplugged

# Configuration
LOW_BATTERY=20
CRITICAL_BATTERY=10
STATE_FILE="/tmp/battery_state"

# Get battery info
BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n 1)
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n 1)

# Exit if battery info not available
if [ -z "$BATTERY_LEVEL" ]; then
    exit 0
fi

# Read previous state
if [ -f "$STATE_FILE" ]; then
    PREV_STATUS=$(cat "$STATE_FILE")
else
    PREV_STATUS=""
fi

# Save current state
echo "$BATTERY_STATUS" > "$STATE_FILE"

# Check for status changes (plugged/unplugged)
if [ "$PREV_STATUS" != "" ] && [ "$PREV_STATUS" != "$BATTERY_STATUS" ]; then
    if [ "$BATTERY_STATUS" = "Charging" ] || [ "$BATTERY_STATUS" = "Full" ]; then
        dunstify -u low "Power Connected" "Battery is now charging (${BATTERY_LEVEL}%)" -i battery-ac-adapter
    elif [ "$BATTERY_STATUS" = "Discharging" ]; then
        dunstify -u normal "Power Disconnected" "Running on battery (${BATTERY_LEVEL}%)" -i battery-good
    fi
fi

# Check battery level when discharging
if [ "$BATTERY_STATUS" = "Discharging" ]; then
    if [ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY" ]; then
        dunstify -u critical "Battery Critical" "Battery level is ${BATTERY_LEVEL}%\nPlug in charger immediately!" -i battery-caution
    elif [ "$BATTERY_LEVEL" -le "$LOW_BATTERY" ]; then
        dunstify -u normal "Battery Low" "Battery level is ${BATTERY_LEVEL}%\nConsider plugging in charger" -i battery-low
    fi
fi

# Notify when fully charged
if [ "$BATTERY_STATUS" = "Full" ] && [ "$PREV_STATUS" = "Charging" ]; then
    dunstify -u low "Battery Full" "Battery is fully charged (100%)" -i battery-full-charged
fi
