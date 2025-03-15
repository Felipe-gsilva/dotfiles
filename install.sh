#!/bin/zsh

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

# Check if the default shell is zsh
if [[ $SHELL == */zsh ]]; then
  echo "zsh is already the default shell."
else
  # Check if zsh is installed
  if ! command -v zsh &>/dev/null; then
    echo "Installing zsh..."
    yay -S zsh --noconfirm
  fi
  echo "Setting zsh as the default shell..."
  chsh -s "$(command -v zsh)"
fi

# Install oh-my-zsh 
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "oh-my-zsh is already installed."
else
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Ensure ~/.config exists
mkdir -p "$HOME/.config"

echo -n "Install recommended packages? (Y/n): " 
read confirm
if [[ "$confirm" =~ ^[yY]([eE][sS])?$ ]]; then
  echo "Installing general packages..."
  yay -S --noconfirm git neovim composer kitty rofi-wayland tmux \
                     pulseaudio waybar hyprpaper hyprland pavucontrol neofetch \
                     wl-clipboard grim slurp 
fi

typeset -A CONFIG_PATHS
CONFIG_PATHS=(
  "nvim" "$HOME/.config/nvim"
  ".zshrc" "$HOME/.zshrc"
  ".oh-my-zsh" "$HOME/.oh-my-zsh"
  "kitty" "$HOME/.config/kitty"
  "composer" "$HOME/.config/composer"
  "hypr" "$HOME/.config/hypr"
  "neofetch" "$HOME/.config/neofetch"
  "rofi" "$HOME/.config/rofi"
  "copyq" "$HOME/.config/copyq"
  "tmux" "$HOME/.config/tmux"
  "tmux.conf" "$HOME/.tmux.conf"
  "pulse" "$HOME/.config/pulse"
  "waybar" "$HOME/.config/waybar"
)

# Link config files
echo "Linking configuration files..."
for key in ${(k)CONFIG_PATHS}; do
  target="${CONFIG_PATHS[$key]}"
  if [[ ! -e "$target" ]]; then
    ln -sf "$PWD/$key" "$target"
    echo "Linked $key -> $target"
  fi
done

echo "Configuration setup completed."
