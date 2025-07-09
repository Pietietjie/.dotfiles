#!/bin/sh

OUTPUT_FILE="/etc/pkglist.txt"
IGNORE_FILE_DESKTOP="/etc/pkglist_desktop.txt"
IGNORE_FILE_IGNORE="/etc/ignore.txt"

PACKAGE_LIST=$(pacman -Qqet)
TEMP_IGNORED_PACKAGES=$(mktemp)

if [ -f "$IGNORE_FILE_DESKTOP" ]; then
    cat "$IGNORE_FILE_DESKTOP" >>"$TEMP_IGNORED_PACKAGES"
fi

if [ -f "$IGNORE_FILE_IGNORE" ]; then
    cat "$IGNORE_FILE_IGNORE" >>"$TEMP_IGNORED_PACKAGES"
fi

echo "$PACKAGE_LIST" | grep -vFf "$TEMP_IGNORED_PACKAGES" >"$OUTPUT_FILE"

rm "$TEMP_IGNORED_PACKAGES"
