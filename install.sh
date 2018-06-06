#!/usr/bin/env bash
set -eu pipefail

if [ "$PWD" != "$HOME/dotfiles" ]; then
  echo "the install script has to run from ~/dotfiles"
  exit 1
fi

echo "=> Adding symlinks..."

installed=0
already=0
skipped=0
total=0

for link in .*.link; do
  final_name="${link%.link}"
  printf "\t%s" "$final_name"

  # check if destiny is a symlink and if points here
  if [ -f "$HOME/$final_name" ]; then
    skipped=$((skipped + 1))
    if [ -L "$HOME/$final_name" ]; then
      if [ $(readlink "$HOME/$final_name") = "$HOME/dotfiles/$link" ]; then
        echo " [skipping; already installed]"
        already=$((already + 1))
      else
        echo " [skipping; there'a a straneous symlink]"
      fi
    else
      echo " [skipping; there's an existing file with that name]"
    fi
  else
    echo
    ln -s "$HOME/dotfiles/$link" "$HOME/$final_name"
    installed=$((installed + 1))
  fi

  total=$((total + 1))
done

echo "Installed $installed new links of a total of $total"
echo "$((installed + already))/$total already installed"
