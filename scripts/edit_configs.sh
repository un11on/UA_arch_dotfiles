#!/bin/bash

# --- НАЛАШТУВАННЯ ШЛЯХІВ ---
PATH_HYPR="~/.config/hypr/hyprland.conf"
PATH_WAYBAR_CONF="~/.config/waybar/config.jsonc"
PATH_WAYBAR_STYLE="~/.config/waybar/style.css"
PATH_SCRIPTS="~/.config/hypr/scripts/"
PATH_SWAYNC="~/.config/swaync/"
PATH_ROFI="~/.config/rofi/"
PATH_ZSH="~/.zshrc"
PATH_KITTY="~/.config/kitty/kitty.conf"
PATH_CAVA="~/.config/cava/config"
PATH_BTOP="~/.config/btop/btop.conf"
PATH_FASTFETCH="~/.config/fastfetch/config.jsonc"
PATH_WALLPAPERS="~/.config/Wallpapers/"

# --- ОПЦІЇ МЕНЮ ---
OPT_HYPR="📐 Hyprland (Main)"
OPT_WAYBAR_CONF="🍫 Waybar (Config)"
OPT_WAYBAR_STYLE="🎨 Waybar (Style)"
OPT_SCRIPTS="📜 Scripts Dir"
OPT_SWAYNC="🔔 SwayNC"
OPT_ROFI="🔍 Rofi Theme"
OPT_ZSH="🐚 .zshrc"
OPT_KITTY="🐱 Kitty"
OPT_CAVA="📊 Cava"
OPT_BTOP="📈 Btop"
OPT_FASTFETCH="🐰 Fastfetch"
OPT_WALLPAPERS="🖼️ Wallpapers Dir"

# Створюємо список опцій
OPTIONS="$OPT_HYPR\n$OPT_WAYBAR_CONF\n$OPT_WAYBAR_STYLE\n$OPT_SCRIPTS\n$OPT_SWAYNC\n$OPT_ROFI\n$OPT_ZSH\n$OPT_KITTY\n$OPT_CAVA\n$OPT_BTOP\n$OPT_FASTFETCH\n$OPT_WALLPAPERS"

# --- ВІДКРИТТЯ ROFI ---
# Налаштування вигляду: 2 колонки, компактний список, іконка зліва
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Edit Config" \
    -theme-str 'window {width: 800px; padding: 20px;}' \
    -theme-str 'listview {columns: 2; lines: 6; spacing: 10px;}' \
    -theme-str 'element {orientation: horizontal; children: [ element-icon, element-text ]; spacing: 10px; padding: 10px;}' \
    -theme-str 'element-icon {size: 32px;}' \
    -theme-str 'element-text {vertical-align: 0.5;}' \
    -theme-str 'entry {placeholder: "Пошук конфіга...";}')

# --- ЛОГІКА ВИБОРУ ---
case "$CHOICE" in
    "$OPT_HYPR")
        code "$(eval echo $PATH_HYPR)" ;;
    "$OPT_WAYBAR_CONF")
        code "$(eval echo $PATH_WAYBAR_CONF)" ;;
    "$OPT_WAYBAR_STYLE")
        code "$(eval echo $PATH_WAYBAR_STYLE)" ;;
    "$OPT_SCRIPTS")
        code "$(eval echo $PATH_SCRIPTS)" ;;
    "$OPT_SWAYNC")
        swaync_path="$(eval echo $PATH_SWAYNC)"
        if [ -f "$swaync_path/config.json" ]; then
            code "$swaync_path/config.json"
        else
            code "$swaync_path"
        fi
        ;;
    "$OPT_ROFI")
        code "$(eval echo $PATH_ROFI)" ;;
    "$OPT_ZSH")
        code "$(eval echo $PATH_ZSH)" ;;
    "$OPT_KITTY")
        code "$(eval echo $PATH_KITTY)" ;;
    "$OPT_CAVA")
        code "$(eval echo $PATH_CAVA)" ;;
    "$OPT_BTOP")
        code "$(eval echo $PATH_BTOP)" ;;
    "$OPT_FASTFETCH")
        code "$(eval echo $PATH_FASTFETCH)" ;;
    "$OPT_WALLPAPERS")
        # ТУТ ЗМІНА: Відкриваємо через Thunar
        thunar "$(eval echo $PATH_WALLPAPERS)" ;;
    *)
        exit 1 ;;
esac
