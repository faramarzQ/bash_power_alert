#!/bin/bash

battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
ac_adapter=$(acpi -a | cut -d' ' -f3 | cut -d- -f1)


if [ "$battery_level" -le 4 ]  && [ "$ac_adapter" = "off" ]
then
    # beep speaker
    ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.5s ; kill -9 $pid
    sleep 0.3s 
    ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.5s ; kill -9 $pid

    # blink display
    for i in 1 2 3 4
    do
        sleep 0.1s 
        echo 7500 | sudo tee /sys/class/backlight/intel_backlight/brightness
        sleep 0.1s 
        echo 400 | sudo tee /sys/class/backlight/intel_backlight/brightness
    done
fi

if [ "$battery_level" = 12 ]  && [ "$ac_adapter" = "off" ] 
then
    # beep speaker
    echo 2000 | sudo tee /sys/class/backlight/intel_backlight/brightness

    ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.3s ; kill -9 $pid
    sleep 0.3s 
    ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.3s ; kill -9 $pid
fi

