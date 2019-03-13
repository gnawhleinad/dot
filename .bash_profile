export PATH=/usr/local/bin:/usr/local/sbin:$PATH

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

if [ -d "$(brew --prefix git)" ]; then
  . $(brew --prefix git)/etc/bash_completion.d/git-completion.bash
  . $(brew --prefix git)/etc/bash_completion.d/git-prompt.sh

  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWUNTRACKEDFILES=true
  export GIT_PS1_SHOWCOLORHINTS=true

  GIT_PS1='\[\e[0;31m\]$(__git_ps1)\[\e[0m\]'
fi

for b in ag googler hub lastpass-cli youtube-dl; do
  ! [ -d "$(brew --prefix ${b})" ] && continue

  case $b in
    ag)           bc="ag.bashcomp.sh" ;;
    googler)      bc="googler-completion.bash" ;;
    hub)          bc="hub.bash_completion.sh" ;;
    lastpass-cli) bc="lpass_bash_completion" ;;
    youtube-dl)   bc="youtube-dl.bash-completion" ;;
    *)            continue ;;
  esac

  . $(brew --prefix ${b})/etc/bash_completion.d/${bc}
done

if [[ "$HOSTNAME" == "vader" ]]; then
  export PS1='(｡▼皿▼): \[\e[1m\]\W\[\e[0m\]'$GIT_PS1'\$ '
elif [[ "$HOSTNAME" == "snoke" ]]; then
  export PS1='●~*: \[\e[1m\]\W\[\e[0m\]'$GIT_PS1'\$ '
fi

export HISTCONTROL=ignorespace

export EDITOR="mvim -v"
alias mvim="mvim -v"

export CODE=$HOME/code

export GOPATH=$CODE/go
export PATH=$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin

command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - --no-rehash bash)"

if [ -z "$(pgrep gpg-agent)" ]; then
  eval "$(gpg-agent --daemon)"
fi
export GPG_TTY=$(tty)

lpasscp() {
  lpass show --clip --password "$1"
}
alias lpasscp=lpasscp

alias lockscreen='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
