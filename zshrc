# ~/.zshrc — container dotfiles version (lean, Linux-only).
#
# Your Mac's ~/.zshrc is full of Homebrew/asdf/sdkman/nvm/erlang wiring —
# none of that applies inside a container, so it deliberately isn't ported
# here. Add container-relevant tooling (asdf, mise, etc.) back in only if
# a given project actually needs it.

export EDITOR="hx"
export PATH="$HOME/.local/bin:$PATH"

alias ll="ls -la"
alias k="kubectl"
alias tf="terraform"

# direnv, if the project's devcontainer includes it
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Minimal fallback prompt — replace with starship/etc. once you pick one.
PROMPT='%F{cyan}%~%f %# '
