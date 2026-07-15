# ~/.bashrc — sourced by every interactive shell (including tmux panes).
# Everything is guarded so this same file works on Fedora, Ubuntu, and
# headless servers where some tools are missing.

# Non-interactive shells (scp, cron, ssh <cmd>) need none of this
[[ $- != *i* ]] && return

# Global definitions (Fedora/RHEL; Debian handles /etc/bash.bashrc itself)
[ -f /etc/bashrc ] && . /etc/bashrc

# Terminfo fallback: ghostty's terminfo isn't installed on most servers,
# and an unknown $TERM breaks colors, keys, and clipboard.
if [[ $TERM == xterm-ghostty ]] && ! infocmp "$TERM" &>/dev/null; then
  export TERM=xterm-256color
fi

export EDITOR=nvim

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) PATH="$HOME/.local/bin:$HOME/bin:$PATH" ;;
esac

# pyenv (if installed)
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  [ -d "$PYENV_ROOT/bin" ] && PATH="$PYENV_ROOT/bin:$PATH"
  command -v pyenv >/dev/null && eval "$(pyenv init - bash)"
fi

# yazi: change the shell's cwd on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# starship prompt (falls back to the distro default prompt if not installed)
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
command -v starship >/dev/null && eval "$(starship init bash)"

# Machine-specific config (work setup, secrets, JAVA_HOME, …) — never tracked.
# Must NOT source ~/.bash_profile or ~/.bashrc back.
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"
