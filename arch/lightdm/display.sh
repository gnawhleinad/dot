#!/usr/bin/env bash

display=$(xrandr -q | grep ' connected' | sed 's, connected.*,,')
xrandr --output ${display} --mode 1920x1080 --rate 60 || true
