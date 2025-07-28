#!/bin/sh
OUTPUT_FILE="/etc/pkglist.txt"
PACKAGE_LIST=$(pacman -Qqet)
echo "$PACKAGE_LIST" > "$OUTPUT_FILE"
