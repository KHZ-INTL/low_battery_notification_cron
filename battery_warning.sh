#!/bin/bash

battery_stat="$(acpi --battery)"
battery_greped_status="$(echo $battery_stat | grep -Pio 'remaining|charged')"
battery_percentage_v="$(echo $battery_stat | grep -Po '(\d+%)' | grep -Po '\d+')"


if [ "$battery_greped_status" == "remaining" ]; then
        runtime="$(echo $battery_stat | grep -Po '[0-9]+:[0-9]+:[0-9]+')"

        if [ "$battery_percentage_v" -gt 22 ] && [ "$battery_percentage_v" -lt 26 ]; then
                dunstify -a system -i "/usr/share/icons/elementary/status/48/notification-battery-low.svg" -t 9000 -r 9990 -u normal "Battery Running Low" "${battery_percentage_v}% Remaining\nRuntime $runtime"

        elif [ "$battery_percentage_v" -gt 12 ] && [ "$battery_percentage_v" -lt 16 ]; then
                echo "> 12 && <16"
                dunstify -a system -i "/usr/share/icons/elementary/status/48/notification-power.svg" -t 9000 -r 9990 -u critical "Low Battery: ${battery_percentage_v}%" "Connect charger\nWill Hibernate soon"


        elif [ "$battery_percentage_v" -lt 11 ]; then
                dunstify -a system -i "/usr/share/icons/elementary/status/48/notification-power.svg" -t 0 -r 9990 -u critical "Battery Critically Low" "${battery_percentage_v}% Remaining.\nRuntime: $runtime"
        fi

# Remind to disconnect charger if battery >=85%
elif [ "$battery_greped_status" == "charged" ]; then

    if [ "$battery_percentage_v" -ge 85 ]; then
        dunstify -a system -i "/usr/share/icons/elementary/status/48/battery-full-charged.svg" -t 9000 -r 9990 -u normal "Battery ${battery_percentage_v}%" "Disconnect Charger please."
    fi
fi

