#!/bin/bash

# Get the absolute path to the directory this script is in
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if yay is installed
if ! command -v yay &>/dev/null; then
  echo "Installing yay..."
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit
  makepkg -si
  cd ..
  rm -rf yay
  yay -Y --gendb
  yay -Syu --devel
  yay -Y --devel --save
else
  echo "yay is already installed."
fi

# Check if zsh is installed
if ! command -v zsh &>/dev/null; then
  echo "Installing zsh..."
  yay -S zsh --noconfirm
fi

# Set zsh as default shell
if [[ $SHELL != */zsh ]]; then
  echo "Setting zsh as the default shell..."
  chsh -s "$(command -v zsh)"
else
  echo "zsh is already the default shell."
fi

# Install oh-my-zsh unattended
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "oh-my-zsh is already installed."
else
  echo "Installing oh-my-zsh..."
  # RUNZSH=no prevents OMZ from dropping you into a new shell
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Ensure ~/.config exists
mkdir -p "$HOME/.config"

echo -n "Install recommended packages? (y/N): " 
read -r confirm
if [[ "$confirm" =~ ^[yY]([eE][sS])?$ ]]; then
  echo "Installing general packages..."
  yay -S --noconfirm git neovim kitty rofi tmux picom discord \
                     pulseaudio i3 polybar pavucontrol fastfetch \
                     flameshot zathura zoxide firefox libreoffice \
                     feh luarocks ttf-jetbrains-mono-nerd thunar \
                     thunar-archive-plugin thunar-media-tags-plugin \
                     tumbler rofi-greenclip noto-fonts-emoji
fi

# Use Bash associative array
declare -A CONFIG_PATHS=(
  ["nvim"]="$HOME/.config/nvim"
  [".zshrc"]="$HOME/.zshrc"
  [".oh-my-zsh"]="$HOME/.oh-my-zsh"
  ["kitty"]="$HOME/.config/kitty"
  ["composer"]="$HOME/.config/composer"
  ["i3"]="$HOME/.config/i3"
  ["i3status"]="$HOME/.config/i3status"
  ["polybar"]="$HOME/.config/polybar"
  ["rofi"]="$HOME/.config/rofi"
  ["tmux"]="$HOME/.config/tmux"
  ["tmux/tmux.conf"]="$HOME/.tmux.conf"
  ["picom"]="$HOME/.config/picom"
  ["pulse"]="$HOME/.config/pulse"
  ["spaceship.zsh"]="$HOME/.spaceshiprc.zsh"
)

# Link config files
echo "Linking configuration files..."
for key in "${!CONFIG_PATHS[@]}"; do
  target="${CONFIG_PATHS[$key]}"
  source_file="$DOTFILES_DIR/$key"
  
  # Backup existing files/directories if they aren't already symlinks
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "${target}.backup"
    echo "Backed up existing $target to ${target}.backup"
  fi
  
  # Create the symlink (-n ensures we overwrite directories properly)
  ln -sfn "$source_file" "$target"
  echo "Linked $key -> $target"
done

echo "Configuration setup completed. Remember to add your setxkbmap command to your i3 config!"
