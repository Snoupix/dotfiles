#!/bin/bash

. ~/.config/hypr/scripts/_utils.sh

ensure_cargo_bins

case $1 in
    "--check")
        bluetoothctl info | grep "Device " > /dev/null 2>&1
        exit $?
        ;;
    *)
        text=$(bluetoothctl info | rg "Battery Percentage" | sed "s/.*(\([0-9]*\))/\1/")
        tooltip=$(bluetoothctl info | rg "Alias: " | sed "s/.*Alias:\s*//g")
        (
            bluetoothctl info | rg 'Device ' > /dev/null 2>&1 &&
            echo "{'text': \"" $text%"\", 'tooltip': \"" $tooltip"\"}" ||
            echo '{"text": "", "tooltip": "No device connected"}'
        ) | sed "s/'/\"/g" | jq --unbuffered --compact-output .
        exit 0
        ;;
esac
