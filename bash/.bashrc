case $- in
*i*) ;;
*) return ;;
esac

[[ -r ~/.bashrc.d/variables.bash ]] && source ~/.bashrc.d/variables.bash
[[ -r ~/.bashrc.d/options.bash ]] && source ~/.bashrc.d/options.bash
[[ -r ~/.bashrc.d/completion-cache.bash ]] && source ~/.bashrc.d/completion-cache.bash

for config_file in ~/.bashrc.d/tools/*.bash; do
	[[ -r "$config_file" ]] && source "$config_file"
done

[[ -r ~/.bashrc.d/aliases.bash ]] && source ~/.bashrc.d/aliases.bash
. "$HOME/.cargo/env"
