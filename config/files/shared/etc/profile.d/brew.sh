if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  [[ $- == *i* ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
