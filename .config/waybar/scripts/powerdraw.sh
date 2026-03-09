#!/bin/bash

# Lee el consumo eléctrico actual desde el sistema
POWER_PATH="/sys/class/power_supply/BAT1"

if [ ! -d "$POWER_PATH" ]; then
    # Intentar con BAT0
    POWER_PATH="/sys/class/power_supply/BAT0"
fi

if [ ! -d "$POWER_PATH" ]; then
    echo '{"text": "󱐋 N/A", "tooltip": "Batería no encontrada"}'
    exit 0
fi

# Leer voltaje y corriente (en µV y µA)
if [ -f "$POWER_PATH/power_now" ]; then
    # Algunos sistemas exponen directamente power_now en µW
    POWER_UW=$(cat "$POWER_PATH/power_now")
    POWER_W=$(awk "BEGIN {printf \"%.1f\", $POWER_UW / 1000000}")
else
    VOLTAGE_UV=$(cat "$POWER_PATH/voltage_now" 2>/dev/null || echo 0)
    CURRENT_UA=$(cat "$POWER_PATH/current_now" 2>/dev/null || echo 0)
    POWER_W=$(awk "BEGIN {printf \"%.1f\", ($VOLTAGE_UV * $CURRENT_UA) / 1000000000000}")
fi

STATUS=$(cat "$POWER_PATH/status" 2>/dev/null)

if [ "$STATUS" = "Charging" ]; then
    ICON="󰂄"
    CLASS="charging"
elif [ "$STATUS" = "Full" ]; then
    ICON="󰚥"
    CLASS="full"
else
    ICON="󱐋"
    CLASS="discharging"
fi

TEXT="${ICON} ${POWER_W}W"
TOOLTIP="Consumo actual: ${POWER_W}W\nEstado: ${STATUS}"

echo "{\"text\": \"${TEXT}\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"${CLASS}\"}"