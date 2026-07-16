# ~/.bashrc — sourced by every interactive shell (including tmux panes).
# Everything is guarded so this same file works on Fedora, Ubuntu, and
# headless servers where some tools are missing.

# Non-interactive shells (scp, cron, ssh <cmd>) need none of this
[[ $- != *i* ]] && return

# Global definitions (Fedora/RHEL; Debian handles /etc/bash.bashrc itself)
[ -f /etc/bashrc ] && . /etc/bashrc

# Terminfo fallback: ghostty's and kitty's terminfo entries aren't installed
# on most servers, and an unknown $TERM breaks colors, keys, and clipboard.
if [[ $TERM == xterm-ghostty || $TERM == xterm-kitty ]] && ! infocmp "$TERM" &>/dev/null; then
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

# History: big, deduped, appended after every command so all tmux panes
# share one history and nothing is lost when a pane closes.
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# fzf: fuzzy Ctrl+R history search and Ctrl+T file picker (if installed)
if command -v fzf >/dev/null; then
  if fzf --bash &>/dev/null; then
    eval "$(fzf --bash)"
  else # older packages (e.g. Ubuntu apt) lack --bash
    for _f in /usr/share/fzf/shell/key-bindings.bash /usr/share/doc/fzf/examples/key-bindings.bash; do
      [ -f "$_f" ] && . "$_f"
    done
    unset _f
  fi
fi

# zoxide: `z <fuzzy-name>` jumps to frecent directories (if installed)
command -v zoxide >/dev/null && eval "$(zoxide init bash)"

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
