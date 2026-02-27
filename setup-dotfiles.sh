#!/bin/bash

# This script sets up the dotfiles by creating symbolic links in the home directory.

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to create a symbolic link, replacing any existing target
create_symlink() {
  local source="$1"
  local target="$2"

  # Check if target already exists
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "Removing existing target: $target"
    rm -rf "$target"
  fi

  # Create the symbolic link
  ln -s "$source" "$target"
  echo "Created symlink: $target -> $source"
}

# List of dotfiles to link
# Format: "source_file:target_location"
DOTFILES=(
  "$SCRIPT_DIR/.aliases:$HOME/.aliases"
  "$SCRIPT_DIR/.tmux.conf:$HOME/.tmux.conf"
  "$SCRIPT_DIR/.tmux.conf.local:$HOME/.tmux.conf.local"
  "$SCRIPT_DIR/.zshrc:$HOME/.zshrc"
  "$SCRIPT_DIR/.vimrc:$HOME/.vimrc"
  "$SCRIPT_DIR/.config/topgrade.toml:$HOME/.config/topgrade.toml"
  "$SCRIPT_DIR/.config/starship.toml:$HOME/.config/starship.toml"
  "$SCRIPT_DIR/.config/mise:$HOME/.config/mise"
  "$SCRIPT_DIR/.config/nvim:$HOME/.config/nvim"
  "$SCRIPT_DIR/bat:$(bat --config-dir)"
)

# Create symbolic links for all dotfiles
echo "Setting up dotfiles..."
for dotfile in "${DOTFILES[@]}"; do
  IFS=':' read -r source target <<<"$dotfile"
  create_symlink "$source" "$target"
done

echo "Dotfiles setup complete!"
