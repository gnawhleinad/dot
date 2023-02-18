if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null

source "/usr/local/opt/fzf/shell/key-bindings.bash"
# bind "$(bind -s | grep '^"\\C-r"' | grep -v '\\C-m' | sed 's/"$/\\C-m"/')"
