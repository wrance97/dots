git clone --bare https://github.com/wrance97/dots.git $HOME/.dots
alias dot="git --git-dir=$HOME/.dots/ --work-tree=$HOME"
dot config status.showUntrackedFiles no
dot checkout
