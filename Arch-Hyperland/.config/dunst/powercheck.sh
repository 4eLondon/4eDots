#!/bin/bash
# ~/.config/dunst/battery_watch.sh

THRESHOLD_LOW=20
THRESHOLD_CRITICAL=10

while true; do
    BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$STATUS" != "Charging" ]; then
        if [ "$BATTERY" -le "$THRESHOLD_CRITICAL" ]; then
            notify-send -u critical "Battery Critical" "${BATTERY}% remaining — plug in now!"
        elif [ "$BATTERY" -le "$THRESHOLD_LOW" ]; then
            notify-send -u normal "Battery Low" "${BATTERY}% remaining"
        fi
    fi

    sleep 60
  done
