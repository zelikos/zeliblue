# Ensure Homebrew is loaded properly (See: https://github.com/orgs/Homebrew/discussions/4412#discussioncomment-8651316)
if test -d /var/home/linuxbrew/.linuxbrew
    set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
	set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
	set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"

	fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin";
    ! set -q MANPATH; and set MANPATH ''; set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH;
    ! set -q INFOPATH; and set INFOPATH ''; set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH;
end

if status is-interactive
  if command -q atuin
    atuin init fish | source
  end

  if command -q starship
    starship init fish | source
  end

  if command -q zoxide
    zoxide init --cmd cd fish | source
  end

  if command -q bat
    # bat for cat
    alias cat='bat --style plain' 2>/dev/null
  end

  if command -q eza
    # Eza for ls
    alias ll='eza -l --icons=auto --group-directories-first' 2>/dev/null
    alias l.='eza -d .*' 2>/dev/null
    alias ls='eza' 2>/dev/null
    alias l1='eza -1'
  end

  if command -q rg
    # Ripgrep for grep
    alias grep='rg' 2>/dev/null
    alias egrep='rg' 2>/dev/null
    alias fgrep='rg -F' 2>/dev/null
    alias xzgrep='rg -z' 2>/dev/null
    alias xzegrep='rg -z' 2>/dev/null
    alias xzfgrep='rg -z -F' 2>/dev/null
  end

  if command -q fd
    # Fd for find
    alias find='fd' 2>/dev/null
  end
end
