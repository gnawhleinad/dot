export PATH=/usr/local/bin:/usr/local/sbin:$PATH

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

HOMEBREW_PREFIX=$(brew --prefix)
exists() {
  [ -d "${HOMEBREW_PREFIX}/opt/${1}" ]
}
get_path() {
  echo "${HOMEBREW_PREFIX}/opt/${1}"
}

if exists bash-completion; then
  . $(get_path bash-completion)/etc/profile.d/bash_completion.sh
fi

if exists git; then
  . $(get_path git)/etc/bash_completion.d/git-completion.bash
  . $(get_path git)/etc/bash_completion.d/git-prompt.sh

  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWUNTRACKEDFILES=true
  export GIT_PS1_SHOWCOLORHINTS=true

  GIT_PS1='\[\e[0;31m\]$(__git_ps1)\[\e[0m\]'
fi

for b in ag googler hub lastpass-cli youtube-dl; do
  ! exists $b && continue

  case $b in
    ag)           bc="ag.bashcomp.sh" ;;
    googler)      bc="googler-completion.bash" ;;
    hub)          bc="hub.bash_completion.sh" ;;
    lastpass-cli) bc="lpass_bash_completion" ;;
    youtube-dl)   bc="youtube-dl.bash-completion" ;;
    *)            continue ;;
  esac

  . $(get_path ${b})/etc/bash_completion.d/${bc}
done

if [[ "$HOSTNAME" == "vader" ]]; then
  export PS1='(｡▼皿▼): \[\e[1m\]\W\[\e[0m\]'$GIT_PS1'\$ '
elif [[ "$HOSTNAME" == "snoke" ]]; then
  export PS1='●~*: \[\e[1m\]\W\[\e[0m\]'$GIT_PS1'\$ '
elif [[ "$HOSTNAME" == "hodor" ]]; then
  export PS1='⊿: \[\e[1m\]\W\[\e[0m\]'$GIT_PS1'\$ '
elif [[ "$HOSTNAME" == "sidious" ]]; then
  export PS1='⚈: \[\e[1m\]\W\[\e[0m\]'$GIT_PS1'\$ '
fi

export HISTCONTROL=ignorespace

if exists macvim; then
  export EDITOR="mvim -v"
  alias mvim="mvim -v"
fi

export CODE=$HOME/code

if exists golang; then
  export GOPATH=$CODE/go
  export PATH=$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin
fi

command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - --no-rehash bash)"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init - --no-rehash bash)"
command -v nodenv >/dev/null 2>&1 && eval "$(nodenv init - --no-rehash bash)"

if exists gnupg; then
  if [ -z "$(pgrep gpg-agent)" ]; then
    eval "$(gpg-agent --daemon)"
  fi
  export GPG_TTY=$(tty)
fi

lpasscp() {
  lpass show --clip --password "$1"
}
command -v lpass >/dev/null 2>&1 && alias lpasscp=lpasscp

lpassgen() {
  len=$1
  name=$2
  site=${3:-"https://${name}"}
  user=${4:-$(git config --get user.email)}
  printf "Username: ${user}\nPassword: $(pwgen --secure --symbols ${len} 1)\nURL: ${site}" | \
    lpass add --non-interactive --sync now $name
}
command -v lpass >/dev/null 2>&1 && alias lpassgen=lpassgen

git_force_reset() {
  git clean -dffx
  git submodule foreach --recursive git clean -dffx
  git reset --hard
  git submodule foreach --recursive git reset --hard
  git submodule update --init --recursive
}
alias git-force-reset=git_force_reset

if [[ -e "$HOME/.ssh/config" ]]; then
  complete -o "default" \
           -o "nospace" \
           -W "$(grep "^Host" ~/.ssh/config | \
    grep -v "[?*]" | cut -d " " -f2 | \
    tr ' ' '\n')" scp sftp ssh
fi

alias lockscreen='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'

export DD_VNC=5901
