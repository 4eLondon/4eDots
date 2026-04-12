#!/usr/bin/env bash
# =============================================================================
# rename_files.sh — Rename files in a directory in sequential order
#
# MODES:
#   --numeric               → 1.ext, 2.ext, 3.ext  ...
#   --named [prefix]        → a1.ext, a2.ext, a3.ext ... (default prefix: a)
#   --strip                 → remove all extensions (saves map for restore)
#   --restore               → restore extensions from saved map
#   --check                 → dry-run: report what would change without doing it
#
# IDEMPOTENT: re-running detects out-of-order / missing / foreign files and fixes.
# EXTENSION MAP: stored in .rename_extmap in the target directory.
#
# USAGE:
#   ./rename_files.sh [OPTIONS] [DIRECTORY]
#
# OPTIONS:
#   --numeric               Use pure numeric names  (1, 2, 3 …)
#   --named [PREFIX]        Use prefix+numeric names  (a1, a2 … or myfile1 …)
#   --strip                 Strip extensions from all files
#   --restore               Restore extensions using .rename_extmap
#   --check                 Dry-run — show planned renames without executing
#   --ext EXT               Force a single extension on all output files (e.g. --ext png)
#   --start N               Start numbering at N (default: 1)
#   --no-backup             Skip creating a .rename_backup snapshot
#   -h, --help              Show this help
#
# EXAMPLES:
#   ./rename_files.sh --numeric .
#   ./rename_files.sh --named photo ./vacation
#   ./rename_files.sh --named ./pics          # prefix defaults to 'a'
#   ./rename_files.sh --strip .
#   ./rename_files.sh --restore .
#   ./rename_files.sh --check --numeric .
# =============================================================================

set -euo pipefail

# ── Defaults ─────────────────────────────────────────────────────────────────
MODE=""
PREFIX="a"
TARGET_DIR="."
DRY_RUN=false
FORCE_EXT=""
START_NUM=1
BACKUP=true
EXTMAP_FILE=".rename_extmap"

# ── Colors (only when connected to a terminal) ────────────────────────────────
if [ -t 1 ]; then
    RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[0;33m'
    BLU='\033[0;34m'; CYN='\033[0;36m'; RST='\033[0m'; BOLD='\033[1m'
else
    RED=''; GRN=''; YLW=''; BLU=''; CYN=''; RST=''; BOLD=''
fi

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { echo -e "${BLU}[INFO]${RST}  $*"; }
ok()      { echo -e "${GRN}[OK]${RST}    $*"; }
warn()    { echo -e "${YLW}[WARN]${RST}  $*"; }
err()     { echo -e "${RED}[ERROR]${RST} $*" >&2; }
changed() { echo -e "${CYN}[RENAME]${RST} $*"; }
dryrun()  { echo -e "${YLW}[DRY-RUN]${RST} $*"; }

usage() {
    sed -n '4,32p' "$0" | sed 's/^# \?//'
    exit 0
}

die() { err "$*"; exit 1; }

# ── Argument parsing ──────────────────────────────────────────────────────────
parse_args() {
    local args=("$@")
    local i=0
    while [ $i -lt ${#args[@]} ]; do
        local arg="${args[$i]}"
        case "$arg" in
            --numeric)
                MODE="numeric"
                ;;
            --named)
                MODE="named"
                # Check if next arg is a prefix (not a flag, not a directory that already exists as next non-flag)
                if [ $((i+1)) -lt ${#args[@]} ]; then
                    local nxt="${args[$((i+1))]}"
                    if [[ "$nxt" != --* ]] && [[ ! -d "$nxt" ]]; then
                        PREFIX="$nxt"
                        i=$((i+1))
                    fi
                fi
                ;;
            --strip)
                MODE="strip"
                ;;
            --restore)
                MODE="restore"
                ;;
            --check)
                DRY_RUN=true
                ;;
            --ext)
                i=$((i+1))
                FORCE_EXT="${args[$i]}"
                FORCE_EXT="${FORCE_EXT#.}"  # strip leading dot if provided
                ;;
            --start)
                i=$((i+1))
                START_NUM="${args[$i]}"
                ;;
            --no-backup)
                BACKUP=false
                ;;
            -h|--help)
                usage
                ;;
            *)
                # Treat as target directory
                TARGET_DIR="$arg"
                ;;
        esac
        i=$((i+1))
    done
}

parse_args "$@"

[ -z "$MODE" ] && die "No mode specified. Use --numeric, --named, --strip, or --restore.\nRun with --help for usage."
[ -d "$TARGET_DIR" ] || die "Directory not found: $TARGET_DIR"

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
EXTMAP_PATH="$TARGET_DIR/$EXTMAP_FILE"

# ── Extension utilities ───────────────────────────────────────────────────────

# Get the real extension of a file (last dot-segment, lower-cased)
get_ext() {
    local f="$1"
    local base="${f##*/}"           # strip path
    # If file has no dot OR dot is only at start (hidden file with no ext): empty
    if [[ "$base" == .* && "${base#.}" != *.* ]]; then
        echo ""
    elif [[ "$base" == *.* ]]; then
        echo "${base##*.}" | tr '[:upper:]' '[:lower:]'
    else
        echo ""
    fi
}

# Get basename without extension
strip_ext() {
    local f="$1"
    local base="${f##*/}"
    local ext
    ext="$(get_ext "$base")"
    if [ -n "$ext" ]; then
        echo "${base%.$ext}"
    else
        echo "$base"
    fi
}

# ── Extract numeric index from a filename (handles both "5" and "a5" and "prefix12") ──
extract_index() {
    local name="$1"          # no extension, no path
    # Strip any leading non-digit prefix, return trailing number
    local num
    num=$(echo "$name" | grep -oE '[0-9]+$' || true)
    echo "${num:-0}"
}

# ── Backup ────────────────────────────────────────────────────────────────────
create_backup() {
    if $BACKUP && ! $DRY_RUN; then
        local bak="$TARGET_DIR/.rename_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$bak"
        # Save name→extension listing only (not file copies, just a manifest)
        find "$TARGET_DIR" -maxdepth 1 -type f \
            ! -name ".rename_*" \
            -exec basename {} \; | sort > "$bak/manifest.txt"
        info "Backup manifest saved to ${bak##*/}/manifest.txt"
    fi
}

# ── Save / load extension map ──────────────────────────────────────────────────
# Format: basename_without_ext|extension
save_extmap_entry() {
    local key="$1" ext="$2"
    # key is the NEW basename (without ext) after rename
    # Remove old entry for this key if exists, then append
    if [ -f "$EXTMAP_PATH" ]; then
        grep -v "^${key}|" "$EXTMAP_PATH" > "${EXTMAP_PATH}.tmp" 2>/dev/null || true
        mv "${EXTMAP_PATH}.tmp" "$EXTMAP_PATH"
    fi
    echo "${key}|${ext}" >> "$EXTMAP_PATH"
}

load_ext_for() {
    local key="$1"
    if [ -f "$EXTMAP_PATH" ]; then
        grep "^${key}|" "$EXTMAP_PATH" | tail -1 | cut -d'|' -f2 || true
    fi
}

# ── Collect files (skip hidden/system files) ──────────────────────────────────
collect_files() {
    find "$TARGET_DIR" -maxdepth 1 -type f \
        ! -name ".rename_*" \
        ! -name ".*" \
        ! -name "*.rntmp_*" \
        | sort | while read -r f; do echo "$f"; done
}

# ── Two-pass safe rename (avoids collisions e.g. 1→2, 2→3) ───────────────────
# Takes an associative array variable name (passed as string) mapping old→new
do_renames() {
    # Receives pairs via stdin: "old_path|new_path"
    local pairs=()
    while IFS= read -r line; do
        pairs+=("$line")
    done

    [ ${#pairs[@]} -eq 0 ] && return 0

    if $DRY_RUN; then
        for pair in "${pairs[@]}"; do
            local old="${pair%%|*}"
            local new="${pair##*|}"
            [ -z "$old" ] && continue
            if [ "$old" != "$new" ]; then
                dryrun "${old##*/}  →  ${new##*/}"
            fi
        done
        return 0
    fi

    # Pass 1: rename everything to a unique tmp name to avoid collisions
    local tmp_pairs=()
    for pair in "${pairs[@]}"; do
        local old="${pair%%|*}"
        local new="${pair##*|}"
        [ -z "$old" ] && continue
        if [ "$old" != "$new" ]; then
            local tmp="${TARGET_DIR}/.rntmp_$$_${RANDOM}"
            mv -- "$old" "$tmp"
            tmp_pairs+=("${tmp}|${new}")
        fi
    done

    # Pass 2: rename tmp names to final names
    [ ${#tmp_pairs[@]} -eq 0 ] && return 0
    for pair in "${tmp_pairs[@]}"; do
        local tmp="${pair%%|*}"
        local new="${pair##*|}"
        mv -- "$tmp" "$new"
        changed "${new##*/}"
    done
}

# ═══════════════════════════════════════════════════════════════════════════════
# MODE: numeric  →  1.ext, 2.ext, 3.ext …
# ═══════════════════════════════════════════════════════════════════════════════
mode_numeric() {
    info "Mode: NUMERIC  (dir: $TARGET_DIR)"

    local files=()
    while IFS= read -r f; do files+=("$f"); done < <(collect_files)

    [ ${#files[@]} -eq 0 ] && { warn "No files found."; return; }

    create_backup

    # Sort: files that already have numeric names by their number (ascending),
    # then any non-numeric files at the end (they get the next available numbers).
    local numeric_files=()
    local other_files=()

    for f in "${files[@]}"; do
        local base
        base="$(strip_ext "${f##*/}")"
        local idx
        idx="$(extract_index "$base")"
        if [ "$idx" -gt 0 ] 2>/dev/null; then
            numeric_files+=("${idx}|${f}")
        else
            other_files+=("$f")
        fi
    done

    # Sort numeric files by their index
    local sorted_numeric=()
    while IFS= read -r line; do sorted_numeric+=("$line"); done < \
        <(printf '%s\n' "${numeric_files[@]:-}" | sort -t'|' -k1 -n)

    # Build ordered list: numeric first (by index), others appended
    local ordered=()
    for entry in "${sorted_numeric[@]:-}"; do
        ordered+=("${entry##*|}")
    done
    for f in "${other_files[@]:-}"; do
        ordered+=("$f")
    done

    # Assign sequential numbers starting at START_NUM
    local n="$START_NUM"
    local pairs=()
    for f in "${ordered[@]}"; do
        local old_base="${f##*/}"
        local ext
        ext="$(get_ext "$old_base")"
        if [ -n "$FORCE_EXT" ]; then ext="$FORCE_EXT"; fi
        local new_name
        if [ -n "$ext" ]; then
            new_name="${n}.${ext}"
        else
            new_name="${n}"
        fi
        local new_path="$TARGET_DIR/$new_name"
        pairs+=("${f}|${new_path}")

        # Update extmap so --restore can work later
        if ! $DRY_RUN; then
            local orig_ext
            orig_ext="$(get_ext "$old_base")"
            save_extmap_entry "$n" "$orig_ext"
        fi

        n=$((n+1))
    done

    # Check if anything actually needs changing
    local changes=0
    for pair in "${pairs[@]}"; do
        [ "${pair%%|*}" != "${pair##*|}" ] && changes=$((changes+1))
    done

    if [ "$changes" -eq 0 ]; then
        ok "All files already in numeric order. Nothing to do."
        return
    fi

    printf '%s\n' "${pairs[@]}" | do_renames
    $DRY_RUN || ok "Renamed $changes file(s) in numeric order."
}

# ═══════════════════════════════════════════════════════════════════════════════
# MODE: named  →  a1.ext, a2.ext … or prefix1.ext …
# ═══════════════════════════════════════════════════════════════════════════════
mode_named() {
    info "Mode: NAMED  (prefix='${PREFIX}', dir: $TARGET_DIR)"

    local files=()
    while IFS= read -r f; do files+=("$f"); done < <(collect_files)

    [ ${#files[@]} -eq 0 ] && { warn "No files found."; return; }

    create_backup

    # Sort: files matching PREFIX+number by index, then others at end
    local matching=()
    local others=()
    local pfx_len="${#PREFIX}"

    for f in "${files[@]}"; do
        local base
        base="$(strip_ext "${f##*/}")"
        # Check if base starts with PREFIX followed by digits
        if [[ "$base" == "${PREFIX}"* ]]; then
            local suffix="${base:$pfx_len}"
            if [[ "$suffix" =~ ^[0-9]+$ ]]; then
                matching+=("${suffix}|${f}")
                continue
            fi
        fi
        others+=("$f")
    done

    local sorted_matching=()
    while IFS= read -r line; do sorted_matching+=("$line"); done < \
        <(printf '%s\n' "${matching[@]:-}" | sort -t'|' -k1 -n)

    local ordered=()
    for entry in "${sorted_matching[@]:-}"; do
        ordered+=("${entry##*|}")
    done
    for f in "${others[@]:-}"; do
        ordered+=("$f")
    done

    local n="$START_NUM"
    local pairs=()
    for f in "${ordered[@]}"; do
        local old_base="${f##*/}"
        local ext
        ext="$(get_ext "$old_base")"
        if [ -n "$FORCE_EXT" ]; then ext="$FORCE_EXT"; fi
        local stem="${PREFIX}${n}"
        local new_name
        if [ -n "$ext" ]; then
            new_name="${stem}.${ext}"
        else
            new_name="${stem}"
        fi
        local new_path="$TARGET_DIR/$new_name"
        pairs+=("${f}|${new_path}")

        if ! $DRY_RUN; then
            local orig_ext
            orig_ext="$(get_ext "$old_base")"
            save_extmap_entry "${stem}" "$orig_ext"
        fi

        n=$((n+1))
    done

    local changes=0
    for pair in "${pairs[@]}"; do
        [ "${pair%%|*}" != "${pair##*|}" ] && changes=$((changes+1))
    done

    if [ "$changes" -eq 0 ]; then
        ok "All files already in named order (${PREFIX}N). Nothing to do."
        return
    fi

    printf '%s\n' "${pairs[@]}" | do_renames
    $DRY_RUN || ok "Renamed $changes file(s) with prefix '${PREFIX}'."
}

# ═══════════════════════════════════════════════════════════════════════════════
# MODE: strip  →  remove all extensions (saves map for restore)
# ═══════════════════════════════════════════════════════════════════════════════
mode_strip() {
    info "Mode: STRIP extensions  (dir: $TARGET_DIR)"

    local files=()
    while IFS= read -r f; do files+=("$f"); done < <(collect_files)

    [ ${#files[@]} -eq 0 ] && { warn "No files found."; return; }

    create_backup

    local pairs=()
    for f in "${files[@]}"; do
        local base="${f##*/}"
        local ext
        ext="$(get_ext "$base")"
        if [ -z "$ext" ]; then
            # Already no extension
            continue
        fi
        local stem
        stem="$(strip_ext "$base")"
        local new_path="$TARGET_DIR/$stem"
        pairs+=("${f}|${new_path}")

        if ! $DRY_RUN; then
            save_extmap_entry "$stem" "$ext"
        fi
    done

    [ ${#pairs[@]} -eq 0 ] && { ok "No files with extensions found. Nothing to strip."; return; }

    printf '%s\n' "${pairs[@]}" | do_renames
    $DRY_RUN || ok "Stripped extensions from ${#pairs[@]} file(s). Map saved to $EXTMAP_FILE"
}

# ═══════════════════════════════════════════════════════════════════════════════
# MODE: restore  →  re-add extensions from the saved map
# ═══════════════════════════════════════════════════════════════════════════════
mode_restore() {
    info "Mode: RESTORE extensions  (dir: $TARGET_DIR)"

    [ -f "$EXTMAP_PATH" ] || die "No extension map found at $EXTMAP_PATH. Run --strip first."

    local files=()
    while IFS= read -r f; do files+=("$f"); done < <(collect_files)

    [ ${#files[@]} -eq 0 ] && { warn "No files found."; return; }

    create_backup

    local pairs=()
    local missing=0
    for f in "${files[@]}"; do
        local base="${f##*/}"
        local current_ext
        current_ext="$(get_ext "$base")"
        local stem
        stem="$(strip_ext "$base")"
        local saved_ext
        saved_ext="$(load_ext_for "$stem")"

        if [ -z "$saved_ext" ]; then
            warn "No saved extension for '$base' — skipping."
            missing=$((missing+1))
            continue
        fi

        if [ "$current_ext" = "$saved_ext" ]; then
            # Already has the correct extension
            continue
        fi

        local new_name="${stem}.${saved_ext}"
        local new_path="$TARGET_DIR/$new_name"
        pairs+=("${f}|${new_path}")
    done

    [ ${#pairs[@]} -eq 0 ] && [ "$missing" -eq 0 ] && { ok "All files already have their saved extensions."; return; }
    [ ${#pairs[@]} -eq 0 ] && { warn "No restorable files found ($missing skipped)."; return; }

    printf '%s\n' "${pairs[@]}" | do_renames
    $DRY_RUN || ok "Restored extensions on ${#pairs[@]} file(s)."
    [ "$missing" -gt 0 ] && warn "$missing file(s) had no saved extension and were skipped."
}

# ═══════════════════════════════════════════════════════════════════════════════
# Dispatch
# ═══════════════════════════════════════════════════════════════════════════════
echo -e "${BOLD}rename_files.sh${RST}  →  target: $TARGET_DIR"
$DRY_RUN && warn "DRY-RUN mode — no files will be changed."
echo ""

case "$MODE" in
    numeric) mode_numeric ;;
    named)   mode_named   ;;
    strip)   mode_strip   ;;
    restore) mode_restore ;;
    *)       die "Unknown mode: $MODE" ;;
esac
