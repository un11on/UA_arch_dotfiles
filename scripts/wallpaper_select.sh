#!/bin/bash

# --- ШЛЯХ ДО ШПАЛЕР ---
WALLPAPERS_PATH="$HOME/.config/wallpapers"

# 1. Запуск swww-daemon (НОВА КОМАНДА), якщо він не працює
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1
fi

# 2. Відкриваємо Rofi
SELECTED=$(ls "$WALLPAPERS_PATH" | rofi -dmenu -i -no-config -p "Wallpapers" \
    -theme-str 'window {width: 500px; border: 2px; border-radius: 10px; padding: 10px;}' \
    -theme-str 'listview {lines: 8; spacing: 5px;}' \
    -theme-str 'element {border-radius: 5px; padding: 5px;}' \
    -theme-str 'element selected {background-color: grey; text-color: white;}' \
    -theme-str 'entry {placeholder: "Пошук...";}')

# 3. Перевірка вибору
if [ -z "$SELECTED" ]; then
    exit 0
fi

# 4. Встановлення шпалер
echo "Встановлюю: $SELECTED"
swww img "$WALLPAPERS_PATH/$SELECTED" --transition-type any --transition-fps 60 --transition-step 90

# 5. Сповіщення
notify-send "Шпалери змінено" "$SELECTED"