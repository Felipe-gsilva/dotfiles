#!/bin/zsh

if [[ "$(which yay)" ] != "sbin/yay"]; then
  echo "installing yay"
  sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
  yay -Y --gendb
  yay -Syu --devel
  yay -Y --devel --save
else   
  # Check if the current shell is zsh
  if [[ "$(echo $SHELL)" == "/usr/bin/zsh" ]]; then
    echo "zsh found!"
  else 
    # Check if zsh is installed
    if [[ "$(which zsh)" == "/usr/bin/zsh" ]]; then
      echo "zsh installed and setting as default"
      chsh -s "$(which zsh)"
    else 
      echo "installing zsh"
      yay -S zsh
      chsh -s "$(which zsh)"
    fi
  fi
  echo "zsh installed and set as default"
fi

# Check if oh-my-zsh is installed
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "oh-my-zsh found!"
else 
  echo "installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if ! [[ -d "$HOME/.config" ]]; then
  echo "$HOME/.config directory does not exist, creating and linking config files"
  mkdir -p "$HOME/.config"
fi

echo "installing general packages"
yay -S git nvim composer kitty rofi-wayland tmux pulse waybar hyprpaper hyprland pavucontrol neofetch wl-clipboard

if ! [[-d "$HOME/.config/nvim"]]; then
  ln -sf "$PWD/nvim" "$HOME/.config/nvim"
fi

if ! [[-d "$HOME/.zshrc"]]; then
  ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
fi

if ! [[-d "$HOME/.oh-my-zsh"]]; then
  ln -sf "$PWD/.oh-my-zsh" "$HOME/.oh-my-zsh"
fi

if ! [[-d "$HOME/.config/kitty"]]; then
  ln -sf "$PWD/kitty" "$HOME/.config/kitty"
fi

if ! [[-d "$HOME/.config/composer"]]; then
  ln -sf "$PWD/composer" "$HOME/.config/composer"
fi

if ! [[-d "$HOME/.config/hypr"]]; then
  ln -sf "$PWD/hypr" "$HOME/.config/hypr"
fi

if ! [[-d "$HOME/.config/neofetch"]]; then
  ln -sf "$PWD/neofetch" "$HOME/.config/neofetch"
fi

if ! [[-d "$HOME/.config/rofi"]]; then
  ln -sf "$PWD/rofi" "$HOME/.config/rofi"
  # ln -sf "$PWD/flameshot" "$HOME/.config/flameshot"
fi
#
if ! [[-d "$HOME/.config/copyq"]]; then
  ln -sf "$PWD/copyq" "$HOME/.config/copyq"
fi

if ! [[-d "$HOME/.config/nvim"]]; then
  ln -sf "$PWD/tmux" "$HOME/.config/tmux"
fi

if ! [[-d "$HOME/tmux.conf"]]; then
  ln -sf "$PWD/tmux.conf" "$HOME/tmux.conf"
fi

if ! [[-d "$HOME/.config/pulse"]]; then
  ln -sf "$PWD/pulse" "$HOME/.config/pulse"
fi

if ! [[-d "$HOME/.config/waybar"]]; then
  #ln -sf "$PWD/polybar" "$HOME/.config/polybar"
  ln -sf "$PWD/waybar" "$HOME/.config/waybar"
fi

echo "config files linked"
