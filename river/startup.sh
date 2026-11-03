#!/bin/sh

pkill -x wl-clip-persist 2>/dev/null
pkill yambar &
sleep 0.01

wl-clip-persist --clipboard both &
yambar &

if wlr-randr | sed -n '/^DP-1 /,/^$/p' | grep -q 'Enabled: yes'; then
    wlr-randr --output DP-1 --mode 3440x1440 --pos 0,0 --scale 1 \
              --output eDP-1 --pos 3440,0
    yambar -c ~/.config/yambar/ssbmonitor.yml &
fi

if wlr-randr | sed -n '/^HDMI-A-1 /,/^$/p' | grep -q 'Enabled: yes'; then
    wlr-randr --output HDMI-A-1 --mode 1920x1080@60Hz --pos 0,0 --scale 1 \
              --output eDP-1 --pos 0,1080
    yambar -c ~/.config/yambar/monitor.yml &
fi
