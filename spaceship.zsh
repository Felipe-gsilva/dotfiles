#!/bin/zsh
# Display time
SPACESHIP_TIME_SHOW=true
# Display username always
SPACESHIP_USER_SHOW=always
SPACESHIP_DIR_TRUNC_REPO=false

# Add custom Ember section
# See: https://github.com/spaceship-prompt/spaceship-ember
spaceship add ember

# Add a custom vi-mode section to the prompt
# See: https://github.com/spaceship-prompt/spaceship-vi-mode
spaceship add --before char vi_mode

SPACESHIP_PROMPT_ORDER=(
  time           # Time stamps section
  user           # Username section
  dir            # Current directory section
  host           # Hostname section
  git            # Git section (git_branch + git_status)
  ember          # <-- Your custom Ember section exactly where you want it
  exec_time      # Execution time
  line_sep       # Line break
  battery        # Battery level and status
  vi_mode        # <-- Your custom vi-mode section right before the character
  jobs           # Background jobs indicator
  char           # Prompt character (usually ➜)
)

# Change the default prompt character (➜) to something else
SPACESHIP_CHAR_SYMBOL="❯ "
# Customize Directory App
SPACESHIP_CHAR_SYMBOL_SUCCESS="%F{green}❯ %f"
SPACESHIP_CHAR_SYMBOL_FAILURE="%F{red}❯ %f"
SPACESHIP_DIR_COLOR="cyan"
SPACESHIP_DIR_PREFIX="in "

# Customize Git Appearance
SPACESHIP_GIT_BRANCH_COLOR="magenta"
SPACESHIP_GIT_SYMBOL="🐙 "

# Disable tools you don't use to speed up prompt loading
SPACESHIP_DOCKER_SHOW=true
SPACESHIP_AWS_SHOW=false
SPACESHIP_GCLOUD_SHOW=false

# Speed up git by only checking status when you hit Enter
SPACESHIP_GIT_STATUS_SHOW=true
