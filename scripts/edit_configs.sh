#!/bin/bash

# --- ОПЦІЇ МЕНЮ ---
# Формат: "Назва для відображення"
OPT_HYPR="📐 Hyprland (Main)"
OPT_WAYBAR_CONF="🍫 Waybar (Config)"
OPT_WAYBAR_STYLE="🎨 Waybar (Style)"
OPT_SCRIPTS="📜 Scripts Dir"
OPT_SWAYNC="🔔 SwayNC"
OPT_ROFI="🔍 Rofi Theme"
OPT_ZSH="🐚 .zshrc"

# Створюємо список опцій розділених новим рядком
OPTIONS="$OPT_HYPR\n$OPT_WAYBAR_CONF\n$OPT_WAYBAR_STYLE\n$OPT_SCRIPTS\n$OPT_SWAYNC\n$OPT_ROFI\n$OPT_ZSH"

# Відкриваємо Rofi (використовуємо той самий стиль, що й для шпалер)
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -no-config -p "Edit Config" \
    -theme-str 'window {width: 400px; border: 2px; border-radius: 10px; padding: 10px;}' \
    -theme-str 'listview {lines: 7; spacing: 5px;}' \
    -theme-str 'element {border-radius: 5px; padding: 5px;}' \
    -theme-str 'element selected {background-color: grey; text-color: white;}' \
    -theme-str 'entry {placeholder: "Що редагуємо?";}')

# Логіка вибору (відкриваємо у VS Code)
case "$CHOICE" in
    "$OPT_HYPR")
        code ~/.config/hypr/hyprland.conf
        ;;
    "$OPT_WAYBAR_CONF")
        code ~/.config/waybar/config.jsonc
        ;;
    "$OPT_WAYBAR_STYLE")
        code ~/.config/waybar/style.css
        ;;
    "$OPT_SCRIPTS")
        code ~/.config/hypr/scripts/
        ;;
    "$OPT_SWAYNC")
        # Якщо конфігу ще немає, відкриваємо папку
        if [ -f ~/.config/swaync/config.json ]; then
            code ~/.config/swaync/config.json
        else
            code ~/.config/swaync/
        fi
        ;;
    "$OPT_ROFI")
        code ~/.config/rofi/
        ;;
    "$OPT_ZSH")
        code ~/.zshrc
        ;;
    *)
        exit 1
        ;;
esac
