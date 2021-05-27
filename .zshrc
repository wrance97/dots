# Antibody must be installed separately
# It can be found here: https://getantibody.github.io/
# Make sure ~/.config/zsh/antibody/antibody exists, then run the following
# antibody bundle < ~/.config/zsh/antibody/antibody > ~/.config/zsh/antibody/antibody.sh
source ~/.config/zsh/antibody/antibody.sh

# Aliases
alias pls="sudo"
alias vim="nvim"
alias vims="nvim -S"
alias vimc="nvim ~/.config/nvim/init.lua"
alias vimz="nvim ~/.zshrc"
# Exa must be installed separately
# It can be found here: https://github.com/ogham/exa
alias ls="exa -l --no-time --no-filesize --no-permissions --no-user --git"
alias dot="git --git-dir=$HOME/.dots/ --work-tree=$HOME"
alias bat="bat --theme=base16-256"
alias man="batman"
# Git
alias glo="git log --oneline"
alias gcm="git commit -m"
alias gap="git add -p"
alias ga="git add"
alias gs="git status -sb"
alias gsl="git status"
alias gco="git checkout"
alias gst="git stash"
alias gd="git diff"
alias gb="git branch"
alias grbi="git rebase --interactive"

# Options
setopt autocd

# Set pure ZSH as a prompt
fpath+=$HOME/.config/zsh/pure
autoload -U promptinit; promptinit
# Place pure options here
PURE_CMD_MAX_EXEC_TIME=300
PURE_GIT_UNTRACKED_DIRTY=0
zstyle :prompt:pure:git:stash show yes
prompt pure

# Base16 Shell must be installed separately
# It can be found here: https://github.com/chriskempson/base16-shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.config/zsh/git-completion.bash
fpath=(~/.config/zsh $fpath)

autoload -Uz compinit && compinit
