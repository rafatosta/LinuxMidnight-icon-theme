#!/usr/bin/env bash

set -e

THEME_NAME="LinuxDark-icon-theme"
TARGET_DIR="$HOME/.local/share/icons/$THEME_NAME"

echo "Installing $THEME_NAME..."

mkdir -p "$HOME/.local/share/icons"

rm -rf "$TARGET_DIR"
cp -r . "$TARGET_DIR"

echo
echo "Updating icon cache..."

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t "$TARGET_DIR"
fi

echo
echo "Updating desktop database..."

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" || true
fi

echo
echo "Updating mime database..."

if command -v update-mime-database >/dev/null 2>&1; then
    update-mime-database "$HOME/.local/share/mime" || true
fi

echo
echo "Installation complete."
echo
echo "Now select the theme in:"
echo
echo "GNOME Tweaks"
echo "KDE System Settings"
echo "XFCE Appearance"