#!/usr/bin/env sh

wego -d 1 -f markdown | glow

sleep 86400
sh $0
