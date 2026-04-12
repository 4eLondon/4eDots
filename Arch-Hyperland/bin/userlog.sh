#!/usr/bin/env bash
# =============================================================================
# capture.sh — Run a command and tee all output to a dated logfile
#
# USAGE:
#   capture.sh <command> [args...]
#   capture.sh --shell          # drop into a logged interactive shell session
#
# EXAMPLES:
#   ./capture.sh ls -la
#   ./capture.sh python3 myscript.py
#   ./capture.sh --shell
#
# Logs are saved to: ~/bin/logs/YYYY-MM-DD_HH-MM-SS_<command>.log
# =============================================================================

set -euo pipefail

LOG_DIR="$HOME/bin/logs"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"

if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
    echo "[capture] Created log directory: $LOG_DIR"
fi

if [ $# -eq 0 ]; then
    echo "Usage: capture.sh <command> [args...]"
    echo "       capture.sh --shell"
    exit 1
fi

if [ "$1" = "--shell" ]; then
    SLUG="shell"
else
    SLUG="$(basename "$1" | tr -cs '[:alnum:]_-' '_' | sed 's/_*$//')"
fi

LOG_FILE="$LOG_DIR/${TIMESTAMP}_${SLUG}.log"

# ── Write a header into the log ───────────────────────────────────────────────
{
    echo "========================================"
    echo "  capture.sh log"
    echo "  Date   : $(date '+%A %d %B %Y %H:%M:%S')"
    echo "  Command: $*"
    echo "  User   : ${USER:-$(whoami)}"
    echo "  Host   : $(hostname)"
    echo "  Dir    : $PWD"
    echo "========================================"
    echo ""
} > "$LOG_FILE"

echo "[capture] Logging to: $LOG_FILE"
echo ""

if [ "$1" = "--shell" ]; then
    echo "[capture] Starting logged shell session. Type 'exit' to end."
    echo ""
    # script(1) captures a full pty session including interactive programs
    if command -v script &>/dev/null; then
        script -q -a "$LOG_FILE"
    else
        # Fallback: tee stdin/stdout (non-interactive programs only)
        "${SHELL:-bash}" 2>&1 | tee -a "$LOG_FILE"
    fi
else
    # Run the command; pipe both stdout and stderr through tee
    "$@" 2>&1 | tee -a "$LOG_FILE"
    EXIT_CODE="${PIPESTATUS[0]}"

    {
        echo ""
        echo "========================================"
        echo "  Finished : $(date '+%Y-%m-%d %H:%M:%S')"
        echo "  Exit code: $EXIT_CODE"
        echo "========================================"
    } | tee -a "$LOG_FILE"

    echo ""
    echo "[capture] Log saved → $LOG_FILE"
    exit "$EXIT_CODE"
fi
