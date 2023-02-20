export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

DEFAULT_USER=`whoami`

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

alias ls='exa -lah --color=auto'
alias v='nvim'
alias cat='bat'
alias pacs='sudo pacman -Ss'
alias pi='sudo pacman -S'
alias config='nvim ~/dotfiles/editor/nvim/init.vim'
alias rc='nvim ~/.zshrc'
alias src='source ~/.zshrc'
alias aterm='nvim ~/dotfiles/alacritty.yml'
alias pdl='conda activate pdl'
alias tmux="TERM=screen-256color-bce tmux"
alias tmuxconf="nvim ~/dotfiles/.tmux.conf"
alias dots="cd ~/dotfiles"
alias work="timer 40m && terminal-notifier -message 'Pomodoro'\
        -title 'Work Timer is up! Take a Break 😊'\
        -appIcon '~/Pictures/pumpkin.png'\
        -sound Crystal"

alias rest="timer 10m && terminal-notifier -message 'Pomodoro'\
        -title 'Break is over! Get back to work 😬'\
        -appIcon '~/Pictures/pumpkin.png'\
        -sound Crystal"

bindkey '^ ' autosuggest-accept
bindkey '^n' autosuggest-accept

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/nicolas/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/nicolas/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/nicolas/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/nicolas/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

