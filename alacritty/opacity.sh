#!/usr/bin/env bash
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/alacritty.toml"
CURRENT=$(grep -oP '^\s+opacity = \K[\d.]+' "$CONFIG")

if [[ "$1" == "+" ]]; then
    NEW=$(awk "BEGIN {v=$CURRENT+0.05; if(v>1.0) v=1.0; printf \"%.2f\", v}")
else
    NEW=$(awk "BEGIN {v=$CURRENT-0.05; if(v<0.0) v=0.0; printf \"%.2f\", v}")
fi

sed -i "s/opacity = $CURRENT/opacity = $NEW/" "$CONFIG"
