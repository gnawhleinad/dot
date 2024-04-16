DIR="$(cd "$(dirname "$(readlink "${BASH_SOURCE[0]}")")" >/dev/null 2>&1 && pwd)"

export BASH_SILENCE_DEPRECATION_WARNING=1

shopt -s histappend
shopt -s histverify

export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:$PATH

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

HOMEBREW_PREFIX=$(brew --prefix)
HOMEBREW_CASK_PREFIX="${HOMEBREW_PREFIX}/Caskroom"
exists_brew() {
  [ -d "${HOMEBREW_PREFIX}/opt/${1}" ]
}
exists_brew_cask() {
  [ -d "${HOMEBREW_CASK_PREFIX}/${1}" ]
}
exists() {
  exists_brew "${1}" || command -v "${1}" &>/dev/null
}
get_path() {
  if exists_brew "${1}"; then
    echo "${HOMEBREW_PREFIX}/opt/${1}"
  else
    # TODO
    exit 1
  fi
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

for b in googler hub lastpass-cli tab youtube-dl; do
  ! exists $b && continue

  case $b in
    gh)           bc="gh" ;;
    googler)      bc="googler-completion.bash" ;;
    hub)          bc="hub.bash_completion.sh" ;;
    lastpass-cli) bc="lpass_bash_completion" ;;
    tab)          bc="tab" ;;
    youtube-dl)   bc="youtube-dl.bash-completion" ;;
    *)            continue ;;
  esac

  . $(get_path ${b})/etc/bash_completion.d/${bc}
done

if exists_brew_cask google-cloud-sdk; then
    . ${HOMEBREW_CASK_PREFIX}/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
    . ${HOMEBREW_CASK_PREFIX}/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc
fi

[ -f ~/.fzf.bash ] && . ~/.fzf.bash
if exists rg; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

if [[ "$HOSTNAME" =~ ^vader ]]; then
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

command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - --no-rehash bash)"
command -v pyenv >/dev/null 2>&1 && {
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init - --no-rehash bash)"
  exists pyenv-virtualenv && eval "$(pyenv virtualenv-init -)"
}
command -v nodenv >/dev/null 2>&1 && eval "$(nodenv init - --no-rehash bash)"

if command -v goenv >/dev/null 2>&1; then
  eval "$(goenv init - --no-rehash bash)"
  export GOROOT=$(goenv prefix)
  export GOPATH="${HOME}/go/$(goenv version-name)"
  export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"
fi

exists rustup-init &&
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
command -v lpass >/dev/null 2>&1 && alias lpasscp=lpasscp

lpassgen() {
  len=$1
  name=$2
  site=${3:-"https://$(basename ${name})"}

  check="${DIR}/.gitconfigs/$(dirname ${name})"
  if [ -f "${check}" ]; then
    user=${4:-$(git config --file "${check}" --get user.email)}
  else
    user=${4:-$(git config --get user.email)}
  fi

  printf -- "Username: %s\nPassword: %s\nURL: %s" "${user}" "$(pwgen --secure --symbols ${len} 1)" "${site}" | \
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

alias cdp='cd "$(git rev-parse --show-toplevel)"'

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

alias lockscreen='pmset displaysleepnow'

alias ssh='kitty +kitten ssh'
alias icat="kitty +kitten icat"

# zoom() {
#   agenda=$(gcalcli agenda \
#     --tsv \
#     --details location \
#     --details description \
#     $(date "+%Y-%m-%dT%H:%M") $(date -v+15M "+%Y-%m-%dT%H:%M"))
#   if [[ -z "${agenda}" ]]; then
#     echo "no meetings \o/"
#     return
#   fi
# 
#   candidate=$(echo -E "${agenda}" | head -n1 | awk -F'\t' '{print $6}')
#   if [[ -z "$candidate" ]] && [[ "$candidate" =~ http ]]; then
#     candidate=$(echo -E "${agenda}" | head -n1 | awk -F'\t' '{print $7}')
#     if [[ -z "$candidate" ]] && [[ "$candidate" =~ http ]]; then
#       echo "ERROR: missing zoom.us meeting"
#       echo -E "${agenda}"
#     fi
#   fi
# 
#   re="https[^ ]+\/([[:digit:]]+)"
#   if [[ $candidate =~ $re ]]; then
#     open "zoommtg://zoom.us/join?confno=${BASH_REMATCH[1]}"
#     return
#   fi
# 
#   echo "ERROR: unable to parse zoom.us meeting"
#   echo -E "${agenda}"
# }
# command -v gcalcli >/dev/null 2>&1 && alias zoom=zoom

eval "$(starship init bash)"
. "$HOME/.cargo/env"
