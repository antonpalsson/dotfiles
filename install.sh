#!/bin/zsh

set -e

DOTFILES_DIR="${0:A:h}"

AUTO_YES=false
for arg in "$@"; do
  case "$arg" in
    -y|--yes)
      AUTO_YES=true
      ;;
  esac
done

typeset -A FILES
FILES=(
  ".zshenv"            "$HOME/.zshenv"
  "zsh"                "$HOME/.config/zsh"
  "nvim"               "$HOME/.config/nvim"
  "tmux"               "$HOME/.config/tmux"
  "ghostty"            "$HOME/.config/ghostty"
  "yazi"               "$HOME/.config/yazi"
)

echo "Starting symlink process..."

for FILE in ${(k)FILES}; do
  SOURCE="$DOTFILES_DIR/$FILE"
  TARGET="${FILES[$FILE]}"

  mkdir -p "$(dirname "$TARGET")"

  if [[ -e "$TARGET" || -L "$TARGET" ]]; then
    if $AUTO_YES; then
      rm -rf "$TARGET"
      echo "Removed existing $TARGET"
    else
      echo -n "$TARGET already exists. Remove it? (y/N): "
      read -k 1 confirm
      echo ""

      if [[ $confirm == [yY] ]]; then
        rm -rf "$TARGET"
        echo "Removed existing $TARGET"
      else
        echo "Skipping $TARGET"
        continue
      fi
    fi
  fi

  ln -s "$SOURCE" "$TARGET"
  echo "Linked $TARGET -> $SOURCE"
done
