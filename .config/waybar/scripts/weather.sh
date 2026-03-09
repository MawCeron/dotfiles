#!/bin/bash
# Clima para Waybar usando Open-Meteo + ip-api.com (sin API key)

# Obtener ubicación por IP
LOCATION=$(curl -sf --max-time 5 "http://ip-api.com/json/?fields=lat,lon,city" 2>/dev/null)

if [ -z "$LOCATION" ]; then
    LAT="21.8818"
    LON="-102.2916"
    CITY="Aguascalientes"
else
    LAT=$(echo "$LOCATION" | jq -r '.lat')
    LON=$(echo "$LOCATION" | jq -r '.lon')
    CITY=$(echo "$LOCATION" | jq -r '.city')
fi

# Obtener clima
WEATHER=$(curl -sf --max-time 5 \
    "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code&wind_speed_unit=kmh&timezone=auto" 2>/dev/null)

if [ -z "$WEATHER" ]; then
    echo '{"text": "󰼯 N/A", "tooltip": "Sin conexión", "class": "disconnected"}'
    exit 0
fi

TEMP=$(echo "$WEATHER"     | jq '.current.temperature_2m'      | xargs printf "%.0f")
FEELS=$(echo "$WEATHER"    | jq '.current.apparent_temperature' | xargs printf "%.0f")
HUMIDITY=$(echo "$WEATHER" | jq '.current.relative_humidity_2m')
WIND=$(echo "$WEATHER"     | jq '.current.wind_speed_10m'       | xargs printf "%.0f")
CODE=$(echo "$WEATHER"     | jq '.current.weather_code')

# Icono y descripción según WMO weather code
case "$CODE" in
    0)        ICON="󰖙"; DESC="Despejado" ;;
    1)        ICON="󰖙"; DESC="Principalmente despejado" ;;
    2)        ICON="󰖕"; DESC="Parcialmente nublado" ;;
    3)        ICON="󰖐"; DESC="Nublado" ;;
    45|48)    ICON="󰖑"; DESC="Neblina" ;;
    51|53|55) ICON="󰖗"; DESC="Llovizna" ;;
    61|63)    ICON="󰖗"; DESC="Lluvia ligera" ;;
    65)       ICON="󰖖"; DESC="Lluvia intensa" ;;
    71|73)    ICON="󰖒"; DESC="Nieve ligera" ;;
    75|77)    ICON="󰖒"; DESC="Nieve intensa" ;;
    80|81)    ICON="󰖗"; DESC="Chubascos ligeros" ;;
    82)       ICON="󰖖"; DESC="Chubascos intensos" ;;
    85|86)    ICON="󰖘"; DESC="Chubascos de nieve" ;;
    95)       ICON="󰖓"; DESC="Tormenta" ;;
    96|99)    ICON="󰖓"; DESC="Tormenta con granizo" ;;
    *)        ICON="󰖔"; DESC="Desconocido ($CODE)" ;;
esac

TEXT="${ICON} ${TEMP}°C"
TOOLTIP="${CITY} — ${DESC}\n 󰌌 Sensación: ${FEELS}°C\n 󰖎 Humedad: ${HUMIDITY}%\n 󰖝 Viento: ${WIND} km/h"

printf '{"text": "%s", "tooltip": "%s", "class": "weather"}\n' "$TEXT" "$TOOLTIP"