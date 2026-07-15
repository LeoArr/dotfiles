# ~/.bash_profile — login shells only. Environment/one-time setup lives here;
# all interactive setup lives in ~/.bashrc so tmux panes get it too.

# User bin dirs (idempotent)
case ":$PATH:" in
	*":$HOME/.local/bin:"*) ;;
	*) PATH="$HOME/.local/bin:$HOME/bin:$PATH" ;;
esac
export PATH

# Caps Lock → Escape, only on GNOME desktops
if [[ "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]] && command -v gsettings >/dev/null; then
	gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']" 2>/dev/null
fi

[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
