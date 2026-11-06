#!/bin/sh

terminal=alacritty
browser=firefox

riverctl keyboard-layout -options "grp:caps_toggle" "us,ru"
riverctl  map -layout 0 normal Super+Alt N spawn "riverctl keyboard-layout no"

riverctl  map -layout 0 normal Super Return spawn $terminal
riverctl  map -layout 0 normal Super B spawn $browser

# Super+C to close the focused view
riverctl  map -layout 0 normal Super C close

# Super+Alt+Q to exit river
riverctl  map -layout 0 normal Super+Alt Q exit
# Super+Alt+R to update configuration
riverctl  map -layout 0 normal Super+Alt R spawn 'riverctl spawn "~/.config/river/init"'

# Super+{H,J,K,L} to move focus
riverctl  map -layout 0 normal Super H focus-view left
riverctl  map -layout 0 normal Super J focus-view down
riverctl  map -layout 0 normal Super K focus-view up
riverctl  map -layout 0 normal Super L focus-view right


# Super+{H,J,K,L} to swap windows
riverctl  map -layout 0 normal Super+Shift H swap left
riverctl  map -layout 0 normal Super+Shift J swap down
riverctl  map -layout 0 normal Super+Shift K swap up
riverctl  map -layout 0 normal Super+Shift L swap right

riverctl  map -layout 0 normal Super+Control H send-layout-cmd rivertile "main-ratio -0.05"
riverctl  map -layout 0 normal Super+Control L send-layout-cmd rivertile "main-ratio +0.05"
#
# Super+Period and E+Q to focus the next/previous output
riverctl  map -layout 0 normal Super Q focus-output next
riverctl  map -layout 0 normal Super E focus-output previous

#--------------------------ПЕРЕДЕЛАТЬ!-------------------------------------------
riverctl map -layout normal Alt 1 focus-output HDMI-A-1
riverctl map -layout normal Alt 2 focus-output DP-1
riverctl map -layout normal Alt 3 focus-output eDP-1

riverctl map -layout normal Shift+Alt 1 send-to-output HDMI-A-1
riverctl map -layout normal Shift+Alt 2 send-to-output DP-1
riverctl map -layout normal ShiftiAlt 3 send-to-output eDP-1
# ------------------------------------------------------------------------------
# Super+Shift+{E,Q} to send the focused view to the next/previous output
riverctl  map -layout 0 normal Super+Shift Q send-to-output next
riverctl  map -layout 0 normal Super+Shift E send-to-output previous

# Super+Shift+Return to bump the focused view to the top of the layout stack
riverctl  map -layout 0 normal Super+Shift Return zoom


# Super+Shift+H and Super+Shift+L to increment/decrement the main count of rivertile(1)
riverctl  map -layout 0 normal Super Period send-layout-cmd rivertile "main-count +1"
riverctl  map -layout 0 normal Super Comma send-layout-cmd rivertile "main-count -1"

# Super+Alt+{H,J,K,L} to move views
riverctl  map -layout 0 normal Super+Alt H move left 100
riverctl  map -layout 0 normal Super+Alt J move down 100
riverctl  map -layout 0 normal Super+Alt K move up 100
riverctl  map -layout 0 normal Super+Alt L move right 100

# Super+Alt+Control+{H,J,K,L} to snap views to screen edges
riverctl  map -layout 0 normal Super+Alt+Shift H snap left
riverctl  map -layout 0 normal Super+Alt+Shift J snap down
riverctl  map -layout 0 normal Super+Alt+Shift K snap up
riverctl  map -layout 0 normal Super+Alt+Shift L snap right

# Super+Alt+Shift+{H,J,K,L} to resize views
riverctl  map -layout 0 normal Super+Alt+Control H resize horizontal -100
riverctl  map -layout 0 normal Super+Alt+Control J resize vertical 100
riverctl  map -layout 0 normal Super+Alt+Control K resize vertical -100
riverctl  map -layout 0 normal Super+Alt+Control L resize horizontal 100

# Super + Left Mouse Button to move views
riverctl map-pointer normal Super BTN_LEFT move-view

# Super + Right Mouse Button to resize views
riverctl map-pointer normal Super BTN_RIGHT resize-view

# Super + Middle Mouse Button to toggle float
riverctl map-pointer normal Super BTN_MIDDLE toggle-float

for i in $(seq 1 9)
do
    tags=$((1 << ($i - 1)))

    # Super+[1-9] to focus tag [0-8]
    riverctl  map -layout 0 normal Super $i set-focused-tags $tags

    # Super+Shift+[1-9] to tag focused view with tag [0-8]
    riverctl  map -layout 0 normal Super+Shift $i set-view-tags $tags

    # Super+Control+[1-9] to toggle focus of tag [0-8]
    riverctl  map -layout 0 normal Super+Control $i toggle-focused-tags $tags

    # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
    # riverctl  map -layout 0 normal Super+Shift+Control $i toggle-view-tags $tags
done

# Super+0 to focus all tags
# Super+Shift+0 to tag focused view with all tags
all_tags=$(((1 << 9) - 1))
riverctl  map -layout 0 normal Super 0 set-focused-tags $all_tags
riverctl  map -layout 0 normal Super+Shift 0 set-view-tags $all_tags

# Super+Space to toggle float
riverctl  map -layout 0 normal Super Space toggle-float

# Super+F to toggle fullscreen
riverctl  map -layout 0 normal Super F toggle-fullscreen

# Screenshots (requires grim, slurp, wl-clipboard)
# Super+Shift+S — выделить область и скопировать в буфер
riverctl  map -layout 0 normal Super+Shift S spawn 'grim -g "$(slurp)" - | wl-copy --type image/png'
# Super+Shift+P — весь экран в буфер
riverctl  map -layout 0 normal Super+Shift P spawn 'grim - | wl-copy --type image/png'

# Super+{Up,Right,Down,Left} to change layout orientation
riverctl  map -layout 0 normal Super Up    send-layout-cmd rivertile "main-location top"
riverctl  map -layout 0 normal Super Right send-layout-cmd rivertile "main-location right"
riverctl  map -layout 0 normal Super Down  send-layout-cmd rivertile "main-location bottom"
riverctl  map -layout 0 normal Super Left  send-layout-cmd rivertile "main-location left"

# Declare a passthrough mode. This mode has only a single mapping to return to
# normal mode. This makes it useful for testing a nested wayland compositor
riverctl declare-mode passthrough

# Super+F11 to enter passthrough mode
riverctl  map -layout 0 normal Super F11 enter-mode passthrough

# Super+F11 to return to normal mode
riverctl map passthrough Super F11 enter-mode normal

for mode in normal locked
do
    # Eject the optical drive (well if you still have one that is)
    riverctl map $mode None XF86Eject spawn 'eject -T'

    # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
    riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
    riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
    riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'

    # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
    riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
    riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
    riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
    riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

    # Control screen backlight brightness with brightnessctl (https://github.com/Hummer12007/brightnessctl)
    riverctl map $mode None XF86MonBrightnessUp   spawn 'brightnessctl set +5%'
    riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
done


riverctl set-repeat 50 300
