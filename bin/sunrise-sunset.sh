#!/usr/bin/env bash

# First obtain a location code from: https://weather.codes/search/

# Insert your location. For example LOXX0001 is a location code for Bratislava, Slovakia
location="USWY0140"
tmpfile=/tmp/$location.out

# Obtain sunrise and sunset raw data from weather.com
wget -q "https://weather.com/weather/today/l/$location" -O "$tmpfile"

SUNR=$(grep SunriseSunset "$tmpfile" | grep -oE '((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))' | head -1)
SUNS=$(grep SunriseSunset "$tmpfile" | grep -oE '((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))' | tail -1)

sunrise=$(date --date="$SUNR" +%R)
sunset=$(date --date="$SUNS" +%R)

# Use $sunrise and $sunset variables to fit your needs. Example:
echo "sudo ddcutil --display 1 setvcp 10 70" | at $sunrise
echo "sudo ddcutil --display 2 setvcp 10 70" | at $sunrise
echo "sudo brightnessctl set 5000" | at $sunrise
echo "sudo ddcutil --display 1 setvcp 10 20" | at $sunset
echo "sudo ddcutil --display 2 setvcp 10 20" | at $sunset
echo "sudo brightnessctl set 1000" | at $sunrise

at 09:00 -f $DOTBIN/sunrise-sunset.sh
