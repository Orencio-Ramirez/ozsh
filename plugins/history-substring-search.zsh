###########################################################################
# plugins/history-substring-search.zsh
#
# Integración de zsh-history-substring-search.
#
# Muestra sugerencias en gris basadas en historial.
#
# Ejemplo:
#
#   git status  ← sugerido en gris
#
###########################################################################

###########################################################################
# Comprobación de existencia
###########################################################################

if [[ -f $ZSH_DIR/externos/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source $ZSH_DIR/externos/zsh-history-substring-search/zsh-history-substring-search.zsh
else
    return
fi

###########################################################################
# Atajos de Teclado
###########################################################################
autoload -Uz history-substring-search-up
autoload -Uz history-substring-search-down

zle -N history-substring-search-up
zle -N history-substring-search-down

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char