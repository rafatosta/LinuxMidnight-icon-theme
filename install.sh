#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="LinuxMidnight"
SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.local/share/icons/$THEME_NAME"

printf 'Installing %s...\n' "$THEME_NAME"

mkdir -p "$HOME/.local/share/icons"
rm -rf -- "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

cp "$SOURCE_DIR/index.theme" "$TARGET_DIR/"

for dir in scalable symbolic; do
    if [[ -d "$SOURCE_DIR/$dir" ]]; then
        cp -a "$SOURCE_DIR/$dir" "$TARGET_DIR/"
    fi
done

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    printf 'Updating icon cache...\n'
    gtk-update-icon-cache -f -t "$TARGET_DIR"
fi

printf 'Installation complete: %s\n' "$TARGET_DIR"
