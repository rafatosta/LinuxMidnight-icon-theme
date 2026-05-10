#!/usr/bin/env bash

set -e

THEME_NAME="LinuxDark"
TARGET_DIR="$HOME/.local/share/icons/$THEME_NAME"

rm -rf "$TARGET_DIR"

echo "Theme removed."
