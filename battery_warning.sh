#!/bin/bash

battery_stat="$(acpi --battery)"
battery_greped_status="$(echo $battery_stat | grep -Po 'remaining|until')"
battery_percentage_v="$(echo $battery_stat | grep -Po '(\d+%)' | grep -Po '\d+')"

# DEBUGS
echo "DEBUG:"
echo "battery_stat: $battery_stat"
echo "battery_greped_status: $battery_greped_status"
echo "battery_percentage_v: $battery_percentage_v"


if [ "$battery_greped_status" == "remaining" ]; then
        runtime="$(echo $battery_stat | grep -Po '[0-9]+:[0-9]+:[0-9]+')"

        if [ "$battery_percentage_v" -gt 22 ] && [ "$battery_percentage_v" -lt 26 ]; then
                dunstify -a system -i "/usr/share/icons/elementary/status/48/notification-battery-low.svg" -t 9000 -r 9990 -u normal "Battery Running Low" "${battery_percentage_v}% Remaining\nRuntime $runtime"

        elif [ "$battery_percentage_v" -gt 12 ] && [ "$battery_percentage_v" -lt 16 ]; then
                echo "> 12 && <16"
                dunstify -a system -i "/usr/share/icons/elementary/status/48/notification-power.svg" -t 9000 -r 9990 -u critical "Low Battery: ${battery_percentage_v}%" "Connect charger\nRuntime $runtime"


        elif [ "$battery_percentage_v" -gt 0 ] && [ "$battery_percentage_v" -lt 11 ]; then
                dunstify -a system -i "/usr/share/icons/elementary/status/48/notification-power.svg" -t 0 -r 9990 -u critical "Battery Critically Low" "${battery_percentage_v}% Remaining.\nRuntime: $runtime"
        fi

#elif [ "$battery_greped_status" == "until" ]; then
#        runtime="$(echo $battery_stat | grep -Po '[0-9]+:[0-9]+:[0-9]+')"
#
#        if [ "$battery_percentage_v" -gt 25 ] && [ "$battery_percentage_v" -lt 100 ]; then
#                dunstify -a system -i "/usr/share/icons/elementary/status/48/notification-power.svg" -t 0 -r 9990 -u critical "Battery Critically Low" "${battery_percentage_v}% Remaining.\nRuntime: $runtime"
#        fi
fi


