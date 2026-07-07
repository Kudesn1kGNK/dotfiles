#!/usr/bin/env bash
set -euo pipefail

for folder in ~/dotfiles/*; do
  folderName=$(basename "$folder")
  [ "$folderName" = "apply.sh" ] && continue

  target="$HOME/.config/$folderName"

  if [ -L "$target" ]; then
    echo !"$folder -> $target"
    continue
  elif [ -e "$target" ]; then
    echo backup "$target -> $target.backup"
    mv "$target" "$target.backup"
  fi

  echo "$folder -> $target"
  ln -sf "$folder" "$target"
done
