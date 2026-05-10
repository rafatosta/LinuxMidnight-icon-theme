# Contributing Guide (English)

## Goal

This project aims to keep a consistent visual language for the **LinuxMidnight-icon-theme** while making contributions simple and predictable.

## Repository Structure

- `scalable/apps/` → application icons (SVG).
- `scalable/places/` → folder/place icons (SVG).
- `scalable/status/` → status icons (SVG).
- `templates/` → reusable SVG templates.
- `aliases/*.txt` → alias definition files used by `scripts/install-dev.sh` to generate symbolic-link icon names for app/desktop compatibility.
- `scripts/install-dev.sh` → development installer that validates project structure, generates alias symlinks from `aliases/*.txt`, installs to `~/.local/share/icons`, and refreshes icon cache.
- `install.sh` / `uninstall.sh` → standard install and removal scripts.

## Current Standardization Rules

### Rounded icons (current official rule)

For **rounded icons**, use the following standard:

1. Use the project template as the base (`templates/app-template-black.svg`).
2. Keep the icon **centered** in the template.
3. Use **40 mm width** and **40 mm height** as the reference area for composition.

> Note: This is the only formal standard currently defined in the project.

## How to Contribute

1. Fork the repository.
2. Create a feature branch (example: `feat/new-icon-name`).
3. Add or edit SVG files in the correct folder.
4. Update alias files in `aliases/` when compatibility names are needed.
5. Open a Pull Request with:
   - What was changed.
   - Which icon category was affected.
   - Whether the rounded-icon standard (40x40 mm, centered) was followed.

## Pull Request Checklist

- [ ] Icon is in the correct category folder.
- [ ] SVG is clean (no unnecessary metadata/layers).
- [ ] Rounded icon is centered in template.
- [ ] Rounded icon composition follows 40 mm x 40 mm reference.
- [ ] Alias updated (if required for compatibility).
- [ ] Visual check done in desktop environment.

## Naming Suggestions

- Prefer names aligned with desktop/app conventions (example: `google-chrome.svg`, `user-home.svg`).
- Keep lowercase filenames and use hyphens.
- Avoid duplicate names and inconsistent variants.
