#!/bin/bash

# Requiere: wl-color-picker (~/.local/bin/wl-color-picker)

PICKER=""

if command -v wl-color-picker &>/dev/null; then
    PICKER="wl-color-picker"
elif [ -x "$HOME/.local/bin/wl-color-picker" ]; then
    PICKER="$HOME/.local/bin/wl-color-picker"
fi

if [ -z "$PICKER" ]; then
    if [ "$1" = "-j" ]; then
        echo '{"text": "󰈊", "tooltip": "Instalar wl-color-picker", "class": ""}'
    fi
    exit 0
fi

if [ "$1" = "-j" ]; then
    echo '{"text": "󰈊", "tooltip": "Color picker", "class": ""}'
    exit 0
fi

COLOR=$($PICKER -a 2>/dev/null)

if [ -n "$COLOR" ]; then
    echo -n "$COLOR" | wl-copy
    notify-send "Color copiado" "$COLOR" --icon=color-picker 2>/dev/null
    pkill -SIGRTMIN+1 waybar
fi