#!/bin/bash

. ~/.config/hypr/scripts/_utils.sh

ensure_cargo_bins

TOOLTIP=""

is_charging() {
    if [[ $(cat /sys/class/power_supply/AC/online) -eq 1 ]]; then
        echo 1 # charging
    else
        echo 0
    fi
}

case $1 in
    "--check") exit 0 ;;
    "--json" | *)
        for i in $(seq 0 3); do
            upower -i /org/freedesktop/UPower/devices/battery_BAT$i | rg "native-path" | rg "null" > /dev/null 2>&1
            [[ $? -eq 0 ]] && continue

            infos=$(upower -i /org/freedesktop/UPower/devices/battery_BAT$i | rg -e "\s+battery" -A 100 | awk '/^[^ ]/ || /History/ {flag=1} !/History/ && flag {next} {print}' | sed "s/.*History.*\n*//g" | rg -e "(percentage|capacity):\s*(\d*\.\d*|\d*)%" -o)
            percentage=$(echo $infos | rg -e "\s*percentage: (\d*\.\d*|\d*)%\s*" -o | sed "s/\s*percentage:\s*//g" | sed "s/\s*//g")
            capacity=$(echo $infos | rg -e "\s*capacity: (\d*\.\d*|\d*)%\s*" -o | sed "s/\s*capacity:\s*//g" | sed "s/\s*//g")

            if [[ $1 == "--json" ]]; then
                [[ $TOOLTIP != "" ]] && TOOLTIP="$TOOLTIP, "
                TOOLTIP=$(echo "$TOOLTIP\"BAT${i}_percentage\": \""$percentage\"","\
                    "\"BAT${i}_status\": \"$(cat /sys/class/power_supply/BAT$i/status)\","\
                    "\"BAT${i}_capacity\": \"$capacity\"")

                TOOLTIP=$(echo "{$TOOLTIP}" | jq --unbuffered --compact-output . | sed 's/"/\\"/g')
            else 
                [[ $TOOLTIP != "" ]] && TOOLTIP="$TOOLTIP\n\n"
                TOOLTIP=$(echo "$TOOLTIP""BAT${i} => percentage: $percentage -"\
                    "status: $(cat /sys/class/power_supply/BAT$i/status) -"\
                    "capacity: $capacity")

            fi
        done
        
        if [[ $1 == "--json" ]]; then
            echo "{\"text\": \" \", \"tooltip\": \""$TOOLTIP"\"}" | jq --unbuffered --compact-output .
        else
            echo "{\"text\": \" \", \"tooltip\": \"$TOOLTIP\"}" | jq --unbuffered --compact-output .
        fi

        exit 0
        ;;
esac
