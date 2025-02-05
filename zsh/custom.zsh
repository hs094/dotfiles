# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then 
  mkdir -p "$(dirname $ZINIT_HOME)" 
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"


export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
# Poetry
export PATH="$HOME/.local/bin:$PATH"
# Add Homebrew binaries to PATH
export PATH="/opt/homebrew/bin:$PATH"
# Add GCC binaries
export PATH="/opt/homebrew/Cellar/gcc/14.2.0_1/bin:$PATH"
export HOMEBREW_NO_AUTO_UPDATE=1
# Pipenv
export PIPENV_VENV_IN_PROJECT=1

# Conda Setup
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup


# Configure Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Activate syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# Change colors
# export ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue
# export ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue
# export ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

# Activate autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# eval $(thefuck --alias)

# Load Git completion
zstyle ':completion:*:*:git:*' script $HOME/.config/zsh/git-completion.bash
fpath=($HOME/.config/zsh $fpath)

# History 
HISTSIZE=5000 
HISTFILE=~/.zsh_history 
SAVEHIST=$HISTSIZE 
HISTDUP=erase 
setopt appendhistory 
setopt sharehistory 
setopt hist_ignore_space 
setopt hist_ignore_all_dups 
setopt hist_save_no_dups 
setopt hist_ignore_dups 
setopt hist_find_no_dups

# Completion styling 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ================================================================================================================================================================================




# Redshift
# export ODBCINI="$HOME/.odbc.ini"
# export ODBCSYSINI="/opt/amazon/redshift/Setup"
# export AMAZONREDSHIFTODBCINI="/opt/amazon/redshift/lib/amazon.redshiftodbc.ini"
# export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/usr/local/lib"

# fzf
# [ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# export FZF_CTRL_T_OPTS="
#   --preview 'bat -n --color=always {}'
#   --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# export FZF_DEFAULT_COMMAND='rg --hidden -l ""' # Include hidden files

# bindkey "ç" fzf-cd-widget # Fix for ALT+C on Mac

# # fd - cd to selected directory
# fd() {
#   local dir
#   dir=$(find ${1:-.} -path '*/\.*' -prune \
#                   -o -type d -print 2> /dev/null | fzf +m) &&
#   cd "$dir"
# }

# fh - search in your command history and execute selected command
# fh() {
#   eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
# }

# # Tmux
# # Always work in a tmux session if Tmux is installed
# if which tmux 2>&1 >/dev/null; then
#   if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ]; then
#     tmux attach -t default || tmux new -s default; exit
#   fi
# fi

# Vi mode
# ANSI cursor escape codes:
# \e[0 q: Reset to the default cursor style.
# \e[1 q: Blinking block cursor.
# \e[2 q: Steady block cursor (non-blinking).
# \e[3 q: Blinking underline cursor.
# \e[4 q: Steady underline cursor (non-blinking).
# \e[5 q: Blinking bar cursor.
# \e[6 q: Steady bar cursor (non-blinking).
# bindkey -v
# export KEYTIMEOUT=1 # Makes switching modes quicker
# export VI_MODE_SET_CURSOR=true 

# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]]; then
#     echo -ne '\e[1 q' # block
#   else
#     echo -ne '\e[5 q' # beam
#   fi
# }
# zle -N zle-keymap-select
# zle-line-init() {
#   zle -K viins # initiate 'vi insert' as keymap (can be removed if 'binkey -V has been set elsewhere')
#   echo -ne '\e[5 q'
# }
# zle -N zle-line-init
# echo -ne '\e[5 q' # Use beam shape cursor on startup

# # Yank to the system clipboard
# function vi-yank-xclip {
#   zle vi-yank
#   echo "$CUTBUFFER" | pbcopy -i
# }

# zle -N vi-yank-xclip
# bindkey -M vicmd 'y' vi-yank-xclip
