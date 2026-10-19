#!/bin/bash

# Dunst passes: appname summary body icon urgency
APPNAME="$1"
SUMMARY="$2"
BODY="$3"
ICON="$4"
URGENCY="$5"

SOUND_DIR="$HOME/.config/dunst/sounds"
LOG_FILE="/tmp/dunst_sound.log"

echo "$(date): Urgency level: $URGENCY" >> "$LOG_FILE"

case "$URGENCY" in
    LOW)
        play -q "$SOUND_DIR/chime.ogg" 2>> "$LOG_FILE" &
        ;;
    NORMAL)
        play -q "$SOUND_DIR/soft_ping.ogg" 2>> "$LOG_FILE" &
        ;;
    CRITICAL)
        play -q "$SOUND_DIR/low.ogg" 2>> "$LOG_FILE" &
        ;;
    *)
        echo "Unknown urgency: $URGENCY" >> "$LOG_FILE"
        ;;
esac
