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

echo -n "Install recommended packages? (y/N): " 
read confirm
if [[ "$confirm" =~ ^[yY]([eE][sS])?$ ]]; then
  echo "Installing general packages..."
  yay -S --noconfirm git neovim kitty rofi tmux picom discord \
                     pulseaudio i3 polybar pavucontrol fastfetch \
                     flameshot zathura zoxide firefox libreoffice \
                     feh luarocks ttf-jetbrains-mono thunar \
                     thunar-archive-plugin thunar-media-tags-plugin \
                     tumbler
fi

typeset -A CONFIG_PATHS
CONFIG_PATHS=(
  "nvim" "$HOME/.config/nvim"
  ".zshrc" "$HOME/.zshrc"
  ".oh-my-zsh" "$HOME/.oh-my-zsh"
  "kitty" "$HOME/.config/kitty"
  "composer" "$HOME/.config/composer"
  "i3" "$HOME/.config/i3"
  "i3status" "$HOME/.config/i3status"
  "polybar" "$HOME/.config/polybar"
  "rofi" "$HOME/.config/rofi"
  "tmux" "$HOME/.config/tmux"
  "tmux/tmux.conf" "$HOME/.tmux.conf"
  "picom" "$HOME/.config/picom"
  "pulse" "$HOME/.config/pulse"
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


echo -n "Do you want to remap caps with escape? (y/N)"
read confirm_caps
if [[ "$confirm_caps" =~ ^[yY]([eE][sS])?$ ]]; then
  setxkbmap -option "caps:swapescape"
fi

echo "Configuration setup completed."
