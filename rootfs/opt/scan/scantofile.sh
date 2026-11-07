#!/bin/bash
# Called by brscan-skey: $1 = SANE device (e.g. brother4:net1;dev0)
set -uo pipefail
exec >>/proc/1/fd/1 2>&1   # send output to the container log

DEV="${1:?missing SANE device}"
log() { echo "[scan $(date '+%F %T')] $*"; }

# Page size → scan area (mm). Brother max width is 211.9 mm.
case "${SCAN_PAGE_SIZE,,}" in
    a4)     W=210;   H=297   ;;
    legal)  W=211.9; H=355.6 ;;
    letter|*) W=211.9; H=279.4 ;;
esac
W="${SCAN_WIDTH_MM:-$W}"; H="${SCAN_HEIGHT_MM:-$H}"

# One scan at a time
exec 9>/tmp/scan.lock
flock 9

WORK=$(mktemp -d /tmp/scan.XXXXXX)
trap 'rm -rf "$WORK"' EXIT

COMMON=(--device-name "$DEV" --resolution "$SCAN_RESOLUTION" --mode "$SCAN_MODE"
        -l 0 -t 0 -x "$W" -y "$H" --format=tiff)

sleep 1
log "start: ${SCAN_RESOLUTION} dpi, $SCAN_MODE, ${W}x${H} mm"
# ADF first; on most models an empty feeder makes the device scan the glass instead
scanimage "${COMMON[@]}" --source "Automatic Document Feeder(left aligned)" \
          --batch="$WORK/p%03d.tif" 2>&1 | grep -v "rounded value" | sed 's/^/  /'

shopt -s nullglob
for p in "$WORK"/p*.tif; do [ -s "$p" ] || rm -f "$p"; done
pages=("$WORK"/p*.tif)

if [ ${#pages[@]} -eq 0 ]; then
    log "no page from the feeder, trying the flatbed"
    scanimage "${COMMON[@]}" --source "FlatBed" > "$WORK/p001.tif" 2> >(grep -v "rounded value" | sed 's/^/  /')
    [ -s "$WORK/p001.tif" ] || rm -f "$WORK/p001.tif"
    pages=("$WORK"/p*.tif)
fi

if [ ${#pages[@]} -eq 0 ]; then
    log "FAILED: no page scanned"
    exit 1
fi

NAME="${FILENAME_PREFIX}_$(date +%Y-%m-%d_%H%M%S).pdf"
python3 -I /opt/scan/topdf.py "$WORK/out.pdf" "${pages[@]}" || { log "FAILED: PDF conversion"; exit 1; }

# Atomic drop: write to a hidden subfolder, then rename into OUTPUT_DIR
STAGE="$OUTPUT_DIR/.brscan-tmp/$NAME"
if install -o "$PUID" -g "$PGID" -m 0664 "$WORK/out.pdf" "$STAGE" && mv -f "$STAGE" "$OUTPUT_DIR/$NAME"; then
    log "OK: ${#pages[@]} page(s) → $NAME ($(du -h "$OUTPUT_DIR/$NAME" | cut -f1))"
else
    log "FAILED: cannot write to $OUTPUT_DIR"
    exit 1
fi
