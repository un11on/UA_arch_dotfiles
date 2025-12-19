#!/usr/bin/env bash
set -e

# ===============================
#  UA_arch_dotfiles installer
# ===============================

# --- НАЛАШТУВАННЯ ---
REPO_URL="https://github.com/un11on/UA_arch_dotfiles.git"
CLONE_DIR="$HOME/UA_arch_dotfiles"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# Кольори
GREEN="\e[32m"
BLUE="\e[34m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${BLUE}>>> UA_arch_dotfiles installer${RESET}"
echo

# ===============================
#  ПЕРЕВІРКИ
# ===============================

# ❌ Не запускати від root
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}❌ Не запускай цей скрипт від root${RESET}"
  exit 1
fi

# ❌ Тільки Arch Linux
if [ ! -f /etc/arch-release ]; then
  echo -e "${RED}❌ Цей скрипт призначений тільки для Arch Linux${RESET}"
  exit 1
fi

# ===============================
#  БАЗОВІ ПАКЕТИ
# ===============================

echo -e "${GREEN}>>> Встановлення базових пакетів (git, base-devel)...${RESET}"
sudo pacman -S --needed --noconfirm git base-devel

# ===============================
#  YAY (AUR helper)
# ===============================

if ! command -v yay &> /dev/null; then
  echo -e "${BLUE}>>> Yay не знайдено. Встановлюємо...${RESET}"
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
else
  echo -e "${GREEN}>>> Yay вже встановлено${RESET}"
fi

# ===============================
#  PACMAN ПАКЕТИ
# ===============================

echo -e "${GREEN}>>> Встановлення основних програм (pacman)...${RESET}"

PACMAN_PACKAGES=(
  hyprland
  kitty
  waybar
  rofi
  thunar
  swaync
  grim
  slurp
  wl-clipboard
  fastfetch
  btop
  obs-studio
  discord
)

sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# ===============================
#  AUR ПАКЕТИ
# ===============================

echo -e "${GREEN}>>> Встановлення AUR пакетів...${RESET}"

AUR_PACKAGES=(
  swww
  eww-wayland-git
  cava
  ttf-jetbrains-mono-nerd
)

yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

# ===============================
#  КЛОНУВАННЯ REPO
# ===============================

if [ -d "$CLONE_DIR" ]; then
  echo -e "${BLUE}>>> Repo вже існує. Робимо backup...${RESET}"
  mv "$CLONE_DIR" "${CLONE_DIR}.bak.$(date +%H%M%S)"
fi

echo -e "${BLUE}>>> Клонування UA_arch_dotfiles...${RESET}"
git clone "$REPO_URL" "$CLONE_DIR"

# ===============================
#  BACKUP .config
# ===============================

echo -e "${BLUE}>>> Backup поточних конфігів → $BACKUP_DIR${RESET}"
mkdir -p "$BACKUP_DIR"

for dir in hypr waybar kitty rofi fastfetch swaync cava; do
  [ -d "$HOME/.config/$dir" ] && mv "$HOME/.config/$dir" "$BACKUP_DIR/"
done

mkdir -p "$HOME/.config"

# ===============================
#  КОПІЮВАННЯ КОНФІГІВ
# ===============================

echo -e "${GREEN}>>> Копіювання конфігів...${RESET}"
cp -r "$CLONE_DIR/config/"* "$HOME/.config/"

# ===============================
#  HYPRLAND FIX
# ===============================

echo -e "${BLUE}>>> Налаштування Hyprland...${RESET}"
mkdir -p "$HOME/.config/hypr"

if [ -f "$CLONE_DIR/config/hyprland.conf" ]; then
  cp "$CLONE_DIR/config/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
else
  echo -e "${RED}❌ hyprland.conf не знайдено в репозиторії${RESET}"
fi

# ===============================
#  WALLPAPERS
# ===============================

if [ -d "$CLONE_DIR/config/wallpapers" ]; then
  mkdir -p "$HOME/.config/wallpapers"
  cp -r "$CLONE_DIR/config/wallpapers/"* "$HOME/.config/wallpapers/"
fi

# ===============================
#  SCRIPTS
# ===============================

if [ -d "$HOME/.config/scripts" ]; then
  echo -e "${BLUE}>>> Встановлення прав на скрипти...${RESET}"
  chmod +x "$HOME/.config/scripts/"*.sh 2>/dev/null || true
fi

# ===============================
#  DONE
# ===============================

echo
echo -e "${GREEN}✅ Встановлення завершено успішно!${RESET}"
echo -e "${BLUE}ℹ️ Backup збережено у:${RESET} $BACKUP_DIR"
echo
echo "🔄 Виконай: hyprctl reload"
echo "🚪 Або перелогінься в Hyprland"
