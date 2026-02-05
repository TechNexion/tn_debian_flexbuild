#!/bin/bash

CONFIG_FILE="/home/debian/.config/monitors.xml"

# ==========================================
# 1. detect Connector
# ==========================================
# Only excute auto-rotation when display output is MIPI-DSI
DRM_PATH=$(grep -l "connected" /sys/class/drm/card*-DSI-*/status | head -n 1)

if [ -z "$DRM_PATH" ]; then
    echo "No connected display found in /sys/class/drm."
    exit 1
fi

DEV_DIR=$(dirname "$DRM_PATH")
RAW_NAME=$(basename "$DEV_DIR")
CONNECTOR_NAME=$(echo "$RAW_NAME" | cut -d'-' -f2-)

# ==========================================
# 2. detect display resolution
# ==========================================
# first read fb0
if [ -f "/sys/class/graphics/fb0/virtual_size" ]; then
    RES_STRING=$(cat /sys/class/graphics/fb0/virtual_size)
    WIDTH=$(echo "$RES_STRING" | cut -d',' -f1)
    HEIGHT=$(echo "$RES_STRING" | cut -d',' -f2)
else
    # backup：read DRM modes
    MODE_DATA=$(head -n 1 "$DEV_DIR/modes")
    WIDTH=$(echo "$MODE_DATA" | cut -d'x' -f1)
    HEIGHT=$(echo "$MODE_DATA" | cut -d'x' -f2)
fi

# calculate flash rate: (Clock_kHz * 1000) / (H_Total * V_Total)
MODETEST_LINE=$(modetest -M imx-drm -p | grep -m 1 "type: preferred")
H_TOTAL=$(echo "$MODETEST_LINE" | awk '{print $7}')
V_TOTAL=$(echo "$MODETEST_LINE" | awk '{print $11}')
CLOCK_KHZ=$(echo "$MODETEST_LINE" | awk '{print $12}')
RATE=$(awk -v c="$CLOCK_KHZ" -v h="$H_TOTAL" -v v="$V_TOTAL" 'BEGIN { printf "%.3f", (c * 1000) / (h * v) }')
if [ -z "$RATE" ] || [ "$RATE" == "0.000" ]; then
    RATE="60.000"
fi

echo "Detected Monitor: $CONNECTOR_NAME"
echo "Resolution: ${WIDTH}x${HEIGHT}@${RATE}"

if [ ! -e ${CONFIG_FILE} ]; then
    # generate init xml, scale=1
    echo "Generating ${CONFIG_FILE}, disable scalling"
    cat <<EOF > "$CONFIG_FILE"
<monitors version="2">
  <configuration>
    <layoutmode>logical</layoutmode>
    <logicalmonitor>
      <x>0</x>
      <y>0</y>
      <scale>1</scale>
      <primary>yes</primary>
      <monitor>
        <monitorspec>
          <connector>${CONNECTOR_NAME}</connector>
          <vendor>unknown</vendor>
          <product>unknown</product>
          <serial>unknown</serial>
        </monitorspec>
        <mode>
          <width>${WIDTH}</width>
          <height>${HEIGHT}</height>
          <rate>${RATE}</rate>
        </mode>
      </monitor>
    </logicalmonitor>
  </configuration>
</monitors>
EOF
fi

# ==========================================
# 3. when Width < Height, rotate
# ==========================================
if [ "$WIDTH" -lt "$HEIGHT" ]; then
    echo "Portrait mode detected. Update rotated in $CONFIG_FILE..."
    if (grep -q rotation ${CONFIG_FILE}); then
        sed -i 's|<rotation>no</rotation>|<rotation>right</rotation>|g' ${CONFIG_FILE}
    else
        sed -i '/<primary>yes<\/primary>/a \      <transform>\n        <rotation>right</rotation>\n        <flipped>no</flipped>\n      </transform>' ${CONFIG_FILE}
    fi
fi

chown debian:debian "$CONFIG_FILE"
