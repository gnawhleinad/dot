if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

source "/opt/homebrew/opt/fzf/shell/completion.bash" 2> /dev/null

source "/opt/homebrew/opt/fzf/shell/key-bindings.bash"

bind "$(bind -s | grep '^"\\C-r"' | grep -v '\\C-m' | sed 's/"$/\\C-m"/')"
