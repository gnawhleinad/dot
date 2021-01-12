export PATH=/usr/local/bin:/usr/local/sbin:$PATH

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export EDITOR=vim

exists() {
  local cmd="$1"
  command -v "${cmd}" >/dev/null 2>&1
}
source_bash_completion() {
  local file="$1"
  local share="${2:-}"
  if [[ -f "/etc/bash_completion.d/${file}" ]]; then
    . "/etc/bash_completion.d/${file}"
  elif [[ -n "${share}" ]] && [[ -f "/usr/share/${share}/${file}" ]]; then
    . "/usr/share/${share}/${file}"
  elif [[ -n "${share}" ]] && [[ -f "/usr/share/${share}/completion/${file}" ]]; then
    . "/usr/share/${share}/completion/${file}"
  elif [[ -n "${share}" ]] && [[ -f "/usr/share/${share}/completions/${file}" ]]; then
    . "/usr/share/${share}/completions/${file}"
  fi
}

if exists git; then
  source_bash_completion git-completion.bash git
  source_bash_completion git-prompt.sh git

  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWUNTRACKEDFILES=true
  export GIT_PS1_SHOWCOLORHINTS=true

  GIT_PS1='\[\e[0;31m\]$(__git_ps1)\[\e[0m\]'
fi

for b in ag googler; do
  ! exists $b && continue

  case $b in
    ag)           bc="ag.bashcomp.sh"; s="the_silver_searcher" ;;
    googler)      bc="googler-completion.bash"; s= ;;
    *)            continue ;;
  esac

  source_bash_completion "${bc}" "${s}"
done

if exists tab; then
  . ~/.local/share/tab/completion/tab.bash
fi

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

export CODE=$HOME/code

if [[ -d ~/.goenv ]]; then
  export GOENV_ROOT="${HOME}/.goenv"
  export PATH="${GOENV_ROOT}/bin:${PATH}"
  eval "$(goenv init - --no-rehash bash)"
  export GOROOT=$(goenv prefix)
  export GOPATH="${HOME}/go/$(goenv version-name)"
  export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"
fi

if [[ -d ~/.rbenv ]]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init - --no-rehash bash)"
fi

if [[ -d ~/.pyenv ]]; then
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  eval "$(pyenv init - --no-rehash bash)"
fi

if [[ -d ~/.nodenv ]]; then
  export PATH="${HOME}/.nodenv/bin:${PATH}"
  eval "$(nodenv init - --no-rehash bash)"
fi

[ -f ~/.config/tabtab/serverless.bash ] && . ~/.config/tabtab/serverless.bash
[ -f ~/.config/tabtab/sls.bash ] && . ~/.config/tabtab/sls.bash
[ -f ~/.config/tabtab/slss.bash ] && . ~/.config/tabtab/slss.bash

if exists gnupg; then
  if [ -z "$(pgrep gpg-agent)" ]; then
    eval "$(gpg-agent --daemon)"
  fi
  export GPG_TTY=$(tty)
fi

lpasscp() {
  lpass show --clip --password "$1"
}
exists lpass && alias lpasscp=lpasscp

lpassgen() {
  len=$1
  name=$2
  site=${3:-"https://$(basename ${name})"}
  user=${4:-$(git config --get user.email)}
  printf -- "Username: %s\nPassword: %s\nURL: %s" "${user}" "$(pwgen --secure --symbols ${len} 1)" "${site}" | \
    lpass add --non-interactive --sync now $name
}
exists lpass && alias lpassgen=lpassgen

git_force_reset() {
  git clean -dffx
  git submodule foreach --recursive git clean -dffx
  git reset --hard
  git submodule foreach --recursive git reset --hard
  git submodule update --init --recursive
}
alias git-force-reset=git_force_reset

mdquote() {
  pbpaste | awk '{ print "> " $0 }'
}

mdquotecode() {
  mdquote | sed '1i\
> ```
' | echo -e "$(cat -)\n"'> ```'
}

if [[ -e "$HOME/.ssh/config" ]]; then
  complete -o "default" \
           -o "nospace" \
           -W "$(grep "^Host" ~/.ssh/config | \
    grep -v "[?*]" | cut -d " " -f2 | \
    tr ' ' '\n')" scp sftp ssh
fi

eval "$(starship init bash)"
