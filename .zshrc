#
#
#                    █████████
#                   ███░░░░░███
#  █████████████   ███     ░░░   ██████  ████████   ██████  ████████
# ░░███░░███░░███ ░███          ███░░███░░███░░███ ███░░███░░███░░███
#  ░███ ░███ ░███ ░███         ░███████  ░███ ░░░ ░███ ░███ ░███ ░███
#  ░███ ░███ ░███ ░░███     ███░███░░░   ░███     ░███ ░███ ░███ ░███
#  █████░███ █████ ░░█████████ ░░██████  █████    ░░██████  ████ █████
# ░░░░░ ░░░ ░░░░░   ░░░░░░░░░   ░░░░░░  ░░░░░      ░░░░░░  ░░░░ ░░░░░
#
#

# Define el directorio deonde se almacenará Zinit y sus plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Descarga Zinit, si aún no se ha hecho
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Cargar Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Agrega plugins a zsh
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode

# Agrega snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::docker
zinit snippet OMZP::command-not-found

# Determina el estilo del cursor
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

# Cargar completions
autoload -Uz compinit && compinit

zinit cdreplay -q

#######################################################
# Opciones Básicas de ZSH
#######################################################
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export FCEDIT=nvim
export TERMINAL=foot
export BROWSER=firefox

if [[ -x "$(command -v fzf)" ]]; then
	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
	  --info=inline-right \
	  --ansi \
	  --layout=reverse \
	  --border=rounded \
	  --color=border:#5a6570 \
	  --color=fg:#c8d4dc \
	  --color=gutter:#1c2127 \
	  --color=header:#c9a84c \
	  --color=hl+:#5fb3b3 \
	  --color=hl:#5fb3b3 \
	  --color=info:#6878a0 \
	  --color=marker:#c96a6a \
	  --color=pointer:#c96a6a \
	  --color=prompt:#5fb3b3 \
	  --color=query:#c0caf5:regular \
	  --color=scrollbar:#27a1b9 \
	  --color=separator:#c9a84c \
	  --color=spinner:#c96a6a \
	"
fi

#######################################################
# ZSH Keybindings
#######################################################
bindkey -v
bindkey "^[[A" history-beginning-search-backward  # search history with up key
bindkey "^[[B" history-beginning-search-forward   # search history with down key

#######################################################
# Configuracion del Historial
#######################################################
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#######################################################
# Completion styling
#######################################################
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

#######################################################
# Agregar Directorios Comunes de Binarios al PATH
#######################################################

# Agregar directorios al final del path si existen y aún no estan en el path
# Link: https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
function pathappend() {
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="${PATH:+"$PATH:"}$ARG"
        fi
    done
}

# Agregar directorios al comienzo del path si existen y aún no estan en el path
function pathprepend() {
    for ARG in "$@"
    do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="$ARG${PATH:+":$PATH"}"
        fi
    done
}

# y shell wrapper que proporciona la habilidad de cambiar el directorio actual cuando cierras Yazi.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Agrega los paths binarios personales más comunes ubicados en home
# (estos directorios solo son agregados si existen)
pathprepend "$HOME/bin" "$HOME/sbin" "$HOME/.local/bin" "$HOME/local/bin" "$HOME/.bin"

# Add Tmuxifier to path
pathappend "$HOME/.config/tmux/plugins/tmuxifier/bin"

#######################################################
# Aliases
#######################################################

alias c='clear'
alias q='exit'
alias ..='cd ..'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Alias para neovim
if [[ -x "$(command -v nvim)" ]]; then
	alias vi='nvim'
	alias vim='nvim'
	alias svi='sudo nvim'
	alias vis='nvim "+set si"'
elif [[ -x "$(command -v vim)" ]]; then
	alias vi='vim'
	alias svi='sudo vim'
	alias vis='vim "+set si"'
fi

# Alias para lsd
if [[ -x "$(command -v lsd)" ]]; then
	alias ls='lsd -F --group-dirs first'
	alias ll='lsd --all --header --long --group-dirs first'
	alias tree='lsd --tree'
fi

# Alias para abrir un documento, archivo, o URL en su aplicación X predeterminada
if [[ -x "$(command -v xdg-open)" ]]; then
	alias open='runfree xdg-open'
fi

# Alias para abrir un documento, archivo, o URL en el lector de PDF predeterminado
if [[ -x "$(command -v zathura)" ]]; then
    alias pdf='runfree zathura'
fi

# Alias para lazygit
# Link: https://github.com/jesseduffield/lazygit
if [[ -x "$(command -v lazygit)" ]]; then
    alias lg='lazygit'
fi

# Alias para FZF
# Link: https://github.com/junegunn/fzf
if [[ -x "$(command -v fzf)" ]]; then
    alias fzf='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
    # Alias to fuzzy find files in the current folder(s), preview them, and launch in an editor
	if [[ -x "$(command -v xdg-open)" ]]; then
		alias preview='open $(fzf --info=inline --query="${@}")'
	else
		alias preview='edit $(fzf --info=inline --query="${@}")'
	fi
fi

# Devolver dirección IP local
if [[ -x "$(command -v ip)" ]]; then
    alias iplocal="ip -br -c a"
else
    alias iplocal="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
fi

# Devolver dirección IP pública
if [[ -x "$(command -v curl)" ]]; then
    alias ipexternal="curl -s ifconfig.me && echo"
elif [[ -x "$(command -v wget)" ]]; then
    alias ipexternal="wget -qO- ifconfig.me && echo"
fi

#######################################################
# Funciones
#######################################################

# Inicia un programa, pero inmediatamente lo libera de la terminal
function runfree() {
	"$@" > /dev/null 2>&1 & disown
}

# Copiar archivos con barra de progreso
function cpp() {
	if [[ -x "$(command -v rsync)" ]]; then		
		rsync -ah --info=progress2 "${1}" "${2}"
	else
		set -e
		strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
		| awk '{
		count += $NF
		if (count % 10 == 0) {
			percent = count / total_size * 100
			printf "%3d%% [", percent
			for (i=0;i<=percent;i++)
				printf "="
				printf ">"
				for (i=percent;i<100;i++)
					printf " "
					printf "]\r"
				}
			}
		END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
	fi
}

# Copiar e ir al directorio
function cpg() {
	if [[ -d "$2" ]];then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Mover e ir al directorio
function mvg() {
	if [[ -d "$2" ]];then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Crear e ir al directorio
function mkdirg() {
	mkdir -p "$@" && cd "$@"
}

#######################################################
# ZSH Syntax highlighting
#######################################################
source ~/.config/zsh/zsh-syntax-highlighting-blueprint-slate.zsh

#######################################################
# Integraciones del shell
#######################################################

# Configuración de los ky bindings de fzf y fuzzy completion
source <(fzf --zsh)

# Zoxide config para plugins zsh
eval "$(zoxide init --cmd cd zsh)"

# Oh My Posh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/blueprint-slate.omp.json)"
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
