
#!/bin/sh

pkill -x wl-clip-persist 2>/dev/null
pkill yambar 2>/dev/null

sleep 0.1

wl-clip-persist --clipboard both &

# Проверяем подключенные мониторы
DP=$(wlr-randr | sed -n '/^DP-1 /,/^$/p' | grep -q 'Enabled: yes' && echo 1)
HDMI=$(wlr-randr | sed -n '/^HDMI-A-1 /,/^$/p' | grep -q 'Enabled: yes' && echo 1)
EDP=$(wlr-randr | sed -n '/^eDP-1 /,/^$/p' | grep -q 'Enabled: yes' && echo 1)

if [ "$DP" = "1" ] && [ "$HDMI" = "1" ] && [ "$EDP" = "1" ]; then

    # Все три монитора
    # HDMI слева, DP по центру, eDP справа
    wlr-randr \
        --output HDMI-A-1 --mode 1920x1080@60Hz --transform 90 --pos 0,0 --scale 1 \
        --output DP-1 --mode 3440x1440@59.973Hz --transform normal --pos 1080,240 --scale 1 \
        --output eDP-1 --mode 1920x1200@60Hz --transform normal --pos 4520,120 --scale 1

    yambar -c ~/.config/yambar/vertmonitor.yml &
    yambar -c ~/.config/yambar/ssbmonitor.yml &
    yambar -c ~/.config/yambar/config.yml &

elif [ "$DP" = "1" ] && [ "$EDP" = "1" ]; then

    # DP + экран ноутбука
    wlr-randr \
        --output DP-1 --mode 3440x1440 --pos 0,0 --scale 1 \
        --output eDP-1 --pos 3440,0 --scale 1

    yambar -c ~/.config/yambar/ssbmonitor.yml &

elif [ "$HDMI" = "1" ] && [ "$EDP" = "1" ]; then

    # HDMI + экран ноутбука
    wlr-randr \
        --output HDMI-A-1 --mode 1920x1080@60Hz --pos 0,0 --scale 1 \
        --output eDP-1 --pos 0,1080 --scale 1

    yambar -c ~/.config/yambar/monitor.yml &
    yambar -c ~/.config/yambar/config.yml &

else
    # Только стандартная панель
    yambar &
fi
