export LANG=en_US.UTF-8
export INPUTRC="$HOME/.config/readline/inputrc"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/opt/homebrew/opt/python@3.10/libexec/bin"
export PATH="$PATH:/opt/homebrew/Cellar/gcc/14.2.0_1/bin"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/Users/hs094/.local/bin"
export PATH="$PATH:$HOME/.config/scripts"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$PATH:$BUN_INSTALL/bin"
export PATH="$PATH:/Users/hardiksoni/.meteor"
export PATH="$PATH:/Users/hardiksoni/Library/pnpm"

export STARSHIP_CONFIG="~/.config/starship/starship.toml"
export FUNCNEST=1000
export EDITOR="nvim"

export AWS_CLI_AUTO_PROMPT=on
export PIPENV_VENV_IN_PROJECT=1
export NVM_DIR="$HOME/.nvm"
export ZSH="$HOME/.config/.oh-my-zsh"
export HOMEBREW_NO_AUTO_UPDATE=1
export GOPATH=$HOME/go

export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="/Users/hardiksoni/Library/pnpm"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_TMUX_OPTS=" -p90%,70% "

export obsidian="/Users/hs094/Library/Mobile Documents/iCloud~md~obsidian/Documents"
export rcscriptcmd="$HOME/.config/raycast/commands"

# Function to count files up to a specified depth level
countfiles() {
  local depth=${1:-100}
  find . -maxdepth "$depth" -type f | wc -l
}
