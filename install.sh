#!/bin/zsh

# Check if the current shell is zsh
if [[ "$(echo $SHELL)" == "/usr/bin/zsh" ]]; then
  echo "zsh found!"
else 
  # Check if zsh is installed
  if [[ "$(which zsh)" == "/usr/bin/zsh" ]]; then
    echo "zsh installed and setting as default"
    chsh -s "$(which zsh)"
  else 
    # Install zsh using yay (AUR helper)
    echo "installing zsh"
    yay -S zsh
    chsh -s "$(which zsh)"
  fi
fi

echo "zsh installed and set as default"

# Check if oh-my-zsh is installed
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "oh-my-zsh found!"
else 
  echo "installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Check if the .config directory exists
if [[ -d "$HOME/.config" ]]; then
  echo "$HOME/.config directory exists"
  # Symlink all config files
  ln -sf "$PWD/nvim" "$HOME/.config/nvim"
  ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
  ln -sf "$PWD/.oh-my-zsh" "$HOME/.oh-my-zsh"
  ln -sf "$PWD/alacritty" "$HOME/.config/alacritty"
  ln -sf "$PWD/composer" "$HOME/.config/composer"
  ln -sf "$PWD/i3" "$HOME/.config/i3"
  ln -sf "$PWD/i3blocks" "$HOME/.config/i3blocks"
  ln -sf "$PWD/neofetch" "$HOME/.config/neofetch"
  ln -sf "$PWD/i3status" "$HOME/.config/i3status"
  ln -sf "$PWD/i3bus" "$HOME/.config/i3bus"
  ln -sf "$PWD/rofi" "$HOME/.config/rofi"
  ln -sf "$PWD/zoxide" "$HOME/.config/zoxide"
  ln -sf "$PWD/flameshot" "$HOME/.config/flameshot"
  ln -sf "$PWD/copyq" "$HOME/.config/copyq"
  ln -sf "$PWD/tmux" "$HOME/.config/tmux"
  echo "config files linked"
else 
  echo "$HOME/.config directory does not exist, creating and linking config files"
  mkdir -p "$HOME/.config"
  ln -sf "$PWD/nvim" "$HOME/.config/nvim"
  ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
  ln -sf "$PWD/.oh-my-zsh" "$HOME/.oh-my-zsh"
  ln -sf "$PWD/alacritty" "$HOME/.config/alacritty"
  ln -sf "$PWD/composer" "$HOME/.config/composer"
  ln -sf "$PWD/i3" "$HOME/.config/i3"
  ln -sf "$PWD/i3blocks" "$HOME/.config/i3blocks"
  ln -sf "$PWD/neofetch" "$HOME/.config/neofetch"
  ln -sf "$PWD/i3status" "$HOME/.config/i3status"
  ln -sf "$PWD/i3bus" "$HOME/.config/i3bus"
  ln -sf "$PWD/rofi" "$HOME/.config/rofi"
  ln -sf "$PWD/zoxide" "$HOME/.config/zoxide"
  ln -sf "$PWD/flameshot" "$HOME/.config/flameshot"
  ln -sf "$PWD/copyq" "$HOME/.config/copyq"
  ln -sf "$PWD/tmux" "$HOME/.config/tmux"
  echo "config files linked"
fi

