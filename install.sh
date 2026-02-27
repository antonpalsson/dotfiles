#!/bin/sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --profile=*) PROFILE="${1#--profile=}" ;;
    --profile) shift; PROFILE="$1" ;;
  esac
  shift
done

if [ -z "$PROFILE" ]; then
  echo "Error: --profile is required. Available profiles: mac, raspi"
  exit 1
fi

echo "Profile: $PROFILE"
mkdir -p "$HOME/.config"

case "$PROFILE" in
  raspi)
    stow --target "$HOME/.config" --dir "$DOTFILES_DIR" --restow --ignore='ghostty' --ignore='tmux' --ignore='zsh' config
    stow --target "$HOME" --dir "$DOTFILES_DIR" --restow --ignore='\.zshenv' home
    ;;
  mac)
    stow --target "$HOME/.config" --dir "$DOTFILES_DIR" --restow config
    stow --target "$HOME" --dir "$DOTFILES_DIR" --restow --ignore='\.bashrc' home
    ;;
  *)
    echo "Error: Unknown profile '$PROFILE'. Available profiles: mac, raspi"
    exit 1
    ;;
esac

echo "Done."
