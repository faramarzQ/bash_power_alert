# bash_power_alert
an insanely simple bash file which alerts low battery power in a different way

### why i made it

My Debian 10 (buster) had issues with alerting on low battery, and just shot down. so i had to create a cronjob to run this script every minute and check
if battery is in critical level and do alert on gnome, but it seemed like it has problems and because of my lack of knowledge in bash, i couldn't fix it.

this was the snippet bash code:
```bash
battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`

if [ $battery_level -le 4 ]
then
    notify-send "Battery low" "Battery level is ${battery_level}%!"
fi
```

### final snippet
so i used another method, **beeping and blinking**, every minute. at 12 percent battery, the screen brightness decreases and a the speaker makes a beep sound using `speaker-test` command
(as the battery levels down, the beep sound stops).
and for battery levels under 4 percent, the beep sound period increases and the screen blinks.

this is my final code 



``` bash
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
    for i in 1 2 3 4 5
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
```

### how to use

clone the repository to your pc, run `sudo crontab -e` to edit the cron job lists, add the following line at the end of the file:

```bash 
* * * * * [path to file] 
```
this runs the bash file every minute.
and your beeping blinking OS is ready.
