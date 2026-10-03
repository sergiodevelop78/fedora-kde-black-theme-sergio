#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BACKUP_ROOT="$HOME/.local/share/fedora-kde-black-theme-sergio/backups"
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"

COLOR_FILE="CatppuccinMacchiatoBlack_sergio.colors"
COLOR_SCHEME="CatppuccinMacchiatoBlack_sergio"

KVANTUM_THEME="catppuccin-macchiato-black-sergio"

ICON_THEME="Papirus-Dark"
FOLDER_COLOR="teal"


printf '%s\n' \
"============================================" \
" Fedora KDE Black Theme - Sergio" \
"============================================" \
""


# ============================================================
# COMPROBACIÓN DE REQUISITOS
# ============================================================

missing=0

check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "ERROR: No se encontró: $1"
        missing=1
    else
        echo "OK: $1"
    fi
}


echo "Comprobando requisitos..."

check_command kwriteconfig6
check_command kbuildsycoca6
check_command kitty
check_command kvantummanager
check_command papirus-folders


# ------------------------------------------------------------
# Papirus-Dark
# ------------------------------------------------------------

if [[ ! -d "$HOME/.local/share/icons/Papirus-Dark" ]] &&
   [[ ! -d "/usr/share/icons/Papirus-Dark" ]]; then

    echo "ERROR: No se encontró Papirus-Dark."
    missing=1
else
    echo "OK: Papirus-Dark"
fi


# ------------------------------------------------------------
# Archivos del repositorio
# ------------------------------------------------------------

if [[ ! -f "$REPO_DIR/kde/colors/$COLOR_FILE" ]]; then
    echo "ERROR: Falta kde/colors/$COLOR_FILE"
    missing=1
fi


if [[ ! -d "$REPO_DIR/kvantum/$KVANTUM_THEME" ]]; then
    echo "ERROR: Falta kvantum/$KVANTUM_THEME"
    missing=1
fi


for required_file in \
    "$REPO_DIR/kitty/kitty.conf" \
    "$REPO_DIR/kitty/current-theme.conf"; do

    if [[ ! -f "$required_file" ]]; then
        echo "ERROR: Falta ${required_file#$REPO_DIR/}"
        missing=1
    fi

done


if (( missing != 0 )); then
    echo
    echo "Faltan requisitos o archivos necesarios."
    echo "Consulta README.md antes de continuar."
    exit 1
fi


# ============================================================
# BACKUP
# ============================================================

echo
echo "Creando backup en:"
echo "$BACKUP_DIR"

mkdir -p "$BACKUP_DIR"


backup_file() {

    local src="$1"

    if [[ -e "$src" ]]; then

        local rel="${src#$HOME/}"

        mkdir -p "$BACKUP_DIR/$(dirname "$rel")"

        cp -a "$src" "$BACKUP_DIR/$rel"

    fi
}


backup_file "$HOME/.config/Kvantum/$KVANTUM_THEME"
backup_file "$HOME/.config/Kvantum/kvantum.kvconfig"

backup_file "$HOME/.config/kitty/kitty.conf"
backup_file "$HOME/.config/kitty/current-theme.conf"

backup_file "$HOME/.config/kdeglobals"
backup_file "$HOME/.config/plasmarc"
backup_file "$HOME/.config/kwinrc"

backup_file "$HOME/.local/share/color-schemes/$COLOR_FILE"


# ============================================================
# INSTALAR ARCHIVOS DEL TEMA
# ============================================================

echo
echo "Copiando configuración..."


# ------------------------------------------------------------
# KDE Color Scheme
# ------------------------------------------------------------

mkdir -p "$HOME/.local/share/color-schemes"

cp \
    "$REPO_DIR/kde/colors/$COLOR_FILE" \
    "$HOME/.local/share/color-schemes/"


# ------------------------------------------------------------
# Kvantum
# ------------------------------------------------------------

mkdir -p "$HOME/.config/Kvantum"

rm -rf "$HOME/.config/Kvantum/$KVANTUM_THEME"

cp -a \
    "$REPO_DIR/kvantum/$KVANTUM_THEME" \
    "$HOME/.config/Kvantum/"


# ------------------------------------------------------------
# Kitty
# ------------------------------------------------------------

mkdir -p "$HOME/.config/kitty"

cp \
    "$REPO_DIR/kitty/kitty.conf" \
    "$HOME/.config/kitty/kitty.conf"

cp \
    "$REPO_DIR/kitty/current-theme.conf" \
    "$HOME/.config/kitty/current-theme.conf"


# ============================================================
# APLICAR APARIENCIA KDE
# ============================================================

echo
echo "Aplicando Black Sergio..."


# KDE Colors

kwriteconfig6 \
    --file kdeglobals \
    --group General \
    --key ColorScheme \
    "$COLOR_SCHEME"


# Papirus-Dark

kwriteconfig6 \
    --file kdeglobals \
    --group Icons \
    --key Theme \
    "$ICON_THEME"


# Kvantum

kwriteconfig6 \
    --file kdeglobals \
    --group KDE \
    --key widgetStyle \
    kvantum-dark


# Plasma Breeze Dark

kwriteconfig6 \
    --file plasmarc \
    --group Theme \
    --key name \
    breeze-dark


# Window Decoration Breeze

kwriteconfig6 \
    --file kwinrc \
    --group org.kde.kdecoration2 \
    --key library \
    org.kde.breeze

kwriteconfig6 \
    --file kwinrc \
    --group org.kde.kdecoration2 \
    --key theme \
    Breeze


# Seleccionar tema Kvantum

kwriteconfig6 \
    --file Kvantum/kvantum.kvconfig \
    --group General \
    --key theme \
    "$KVANTUM_THEME"


# ============================================================
# PAPIRUS FOLDERS
# ============================================================

echo
echo "Aplicando color $FOLDER_COLOR a Papirus-Dark..."

papirus-folders \
    -C "$FOLDER_COLOR" \
    --theme "$ICON_THEME"


# ============================================================
# ACTUALIZAR CACHÉS
# ============================================================

echo
echo "Actualizando cachés..."

gtk-update-icon-cache \
    -f "$HOME/.local/share/icons/$ICON_THEME" \
    >/dev/null 2>&1 || true

kbuildsycoca6 \
    --noincremental \
    >/dev/null 2>&1 || true


# ============================================================
# FINAL
# ============================================================

echo

printf '%s\n' \
"============================================" \
" Instalación terminada" \
"============================================" \
""

echo "Backup:"
echo "$BACKUP_DIR"

echo
echo "Configuración aplicada:"
echo "  KDE Colors:         $COLOR_SCHEME"
echo "  Plasma Style:       Breeze Dark"
echo "  Window Decoration:  Breeze"
echo "  Kvantum:            $KVANTUM_THEME"
echo "  Icons:              $ICON_THEME"
echo "  Folder color:       $FOLDER_COLOR"

echo
echo "Cierra y vuelve a iniciar sesión en Plasma"
echo "para asegurarte de que todos los cambios se apliquen."
