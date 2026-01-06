#!/bin/bash
# Script to list and select a conceal-os* image file (without extension)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"

# Find files matching conceal-os* with no extension
mapfile -t images < <(find "$OUTPUT_DIR" -name "conceal-os*" -type f ! -name "*.*" 2>/dev/null | sort)
n=${#images[@]}

if [ $n -eq 0 ]; then
    echo "Error: No conceal-os* files (without extension) found" >&2
    exit 1
fi

echo "Available Conceal OS images:" >&2
for i in $(seq 0 $((n-1))); do
    echo "$((i+1))) $(basename "${images[$i]}")" >&2
done
echo "" >&2

read -p "Select image [1-$n]: " choice </dev/tty

if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt $n ]; then
    echo "Error: Invalid selection" >&2
    exit 1
fi

echo "${images[$((choice-1))]}"

