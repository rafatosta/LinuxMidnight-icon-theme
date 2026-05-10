#!/usr/bin/env bash

set -e

THEME_NAME="LinuxDark-icon-theme"
TARGET_DIR="$HOME/.local/share/icons/$THEME_NAME"

mkdir -p "$HOME/.local/share/icons"

rm -rf "$TARGET_DIR"
cp -r . "$TARGET_DIR"

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t "$TARGET_DIR"
fi

echo "Theme installed successfully!"
