#!/bin/sh


riverctl set-cursor-warp on-output-change

riverctl background-color 0x002b36
riverctl border-color-focused 0x93a1a1
riverctl border-color-unfocused 0x586e75


riverctl default-layout rivertile
rivertile -view-padding 0 -outer-padding 0 &
