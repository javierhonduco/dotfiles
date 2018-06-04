set -eu pipefail

if [ "$PWD" != "$HOME/dotfiles" ]; then
  echo "the install script has to run from ~/dotfiles"
  exit 1
fi

echo "=> Adding symlinks..."

installed=0
skipped=0
total=0

for link in $(ls .*.link); do
  final_name="${link::-5}"
  printf "\t$final_name"

  # check if destiny is a symlink and if points here
  if [ -f ~/$final_name ]; then
    skipped=$(($skipped + 1))
    if [ -L ~/$final_name ]; then
      if [ "$(readlink ~/$final_name)" = "$HOME/dotfiles/$link" ]; then
        echo " [skipping; already installed]"
      else
        echo " [skipping; there'a a straneous symlink]"
      fi
    else
      echo " [skipping; there's an existing file with that name]"
    fi
  else
    echo
    ln -s ~/dotfiles/$link ~/$final_name
    installed=$(($installed + 1))
  fi

  total=$(($total + 1))
done

echo "Installed $installed of a total of $total"
