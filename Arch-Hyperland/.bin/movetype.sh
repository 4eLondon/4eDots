#!/usr/bin/env bash

usage() {
    echo "Usage: $(basename "$0") <extension> [destination]"
    echo ""
    echo "Scans the working directory for files of a given type and moves them to a destination folder."
    echo ""
    echo "Arguments:"
    echo "  extension     File extension to scan for (e.g. png, mp4, txt)"
    echo "  destination   Where to move the files (default: ./<extension>)"
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") png"
    echo "  $(basename "$0") mp4 ~/Videos"
    exit 0
}

[ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] && usage

EXT="${1#.}"
DEST="${2:-./$EXT}"

mkdir -p "$DEST"

COUNT=0
for f in *."$EXT"; do
    [ -f "$f" ] || continue
    mv -- "$f" "$DEST/"
    COUNT=$((COUNT + 1))
done

echo "Moved $COUNT .$EXT file(s) to $DEST"
