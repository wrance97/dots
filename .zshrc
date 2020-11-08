# Antibody must be installed separately
# It can be found here: https://getantibody.github.io/
source ~/dots/zsh/antibody.sh

# Aliases
alias home="cd ~"
alias pls="sudo"
alias vim="nvim" 
alias vims="nvim -S"
alias vimc="nvim ~/.config/nvim/init.vim"
# Exa must be installed separately
# It can be found here: https://github.com/ogham/exa
alias ls="exa --oneline"
alias dot="git --git-dir=$HOME/.dots/ --work-tree=$HOME"

# Options
setopt autocd

# Set pure ZSH as a prompt
fpath+=$HOME/.config/zsh/pure
autoload -U promptinit; promptinit
prompt pure

# Base16 Shell must be installed separately
# It can be found here: https://github.com/chriskempson/base16-shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
