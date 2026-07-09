###########################################################################
# plugins/fzf.zsh
#
# Integración de FZF con ZSH.
#
# Proporciona:
# - búsqueda de historial (CTRL+R)
# - búsqueda de archivos (CTRL+T)
# - navegación de directorios (ALT+C)
#
# No depende de frameworks.
###########################################################################

###########################################################################
# Comprobación de existencia
###########################################################################

if ! command -v fzf >/dev/null 2>&1; then
    return
fi

###########################################################################
# Configuración base
###########################################################################

export FZF_DEFAULT_OPTS="
--height=40%
--layout=reverse
--border
--info=inline
--cycle
--ansi
"

###########################################################################
# CTRL + R (historial mejorado)
###########################################################################

fzf-history-widget() {
    local selected

    selected=$(
        fc -rl 1 \
        | awk '{$1=""; sub(/^ +/, ""); print}' \
        | fzf \
            --tac \
            --no-sort \
            --prompt="Historial > "
    )

    [[ -n "$selected" ]] && LBUFFER="$selected"
}

zle -N fzf-history-widget
bindkey '^R' fzf-history-widget

###########################################################################
# CTRL + T (archivos)
###########################################################################

fzf-file-widget() {

    local file

    file=$(
        find . -type f 2>/dev/null | fzf \
            --prompt="Archivos > " \
            --preview="bat --style=numbers --color=always {} 2>/dev/null"
    )

    if [[ -n "$file" ]]; then
        LBUFFER+="$file"
    fi
}

zle -N fzf-file-widget
bindkey '^T' fzf-file-widget

###########################################################################
# ALT + C (directorios)
###########################################################################

fzf-cd-widget() {

    local dir

    dir=$(
        find . -type d 2>/dev/null | fzf \
            --prompt="Directorios > "
    )

    if [[ -n "$dir" ]]; then
        cd "$dir"
    fi
}

zle -N fzf-cd-widget
bindkey '^[c' fzf-cd-widget

###########################################################################
# Fin
###########################################################################